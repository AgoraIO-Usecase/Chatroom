//
//  RtmManager.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

import AgoraRtmKit

protocol RtmDelegate {
    func onAttributeArrayUpdated(isInit: Bool)
    
    func onMemberUpdated(userId: String, member: Member?)

    func onMessageUpdated()
    
    func onOrderReceived(message: AgoraRtmMessage)
    
    func onMessageReceived(message: AgoraRtmMessage)
}

class RtmManager: NSObject {
    static let sharedInstance = RtmManager()
        
    private var mRtmKit: AgoraRtmKit?
    private var mRtmChannel: AgoraRtmChannel?
    private var delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    private var mAttributeArray = [AgoraRtmChannelAttribute]()
    private var mChannelId: String?
    
    var mMemberMap = [String: Member]()
    var mMessageArray = [Message]()
    
    private override init() {}
    
    func addDelegate(_ delegate: RtmDelegate) {
        delegates.add(delegate as AnyObject)
    }
    
    func removeDelegate(_ delegate: RtmDelegate) {
        delegates.remove(delegate as AnyObject)
    }
    
    func initialize() {
        if mRtmKit == nil {
            mRtmKit = AgoraRtmKit.init(appId: Constant.sAppId, delegate: self)
        }
    }
    
    func login(userId: UInt, block: @escaping AgoraRtmLoginBlock) {
        mRtmKit?.login(byToken: nil, user: String(userId), completion: block)
    }
    
    func joinChannel(channelId: String, block: @escaping AgoraRtmJoinChannelBlock) {
        mChannelId = channelId
        
        if mRtmChannel == nil {
            mRtmChannel = mRtmKit?.createChannel(withId: mChannelId!, delegate: self)
        }
        
        mRtmChannel?.join(completion: { (code) in
            if code == .channelErrorOk {
                print("rtm join success")
                self.initMembers()
                self.initAttributes(self.mChannelId!)
                block(.channelErrorOk)
            } else {
                print("rtm join fail \(code)")
                block(code)
            }
        })
    }
    
    private func initAttributes(_ channelId: String) {
        mRtmKit?.getChannelAllAttributes(channelId, completion: { (attributeArray, code) in
            if code == .attributeOperationErrorOk {
                print("getChannelAllAttributes \(String(describing: attributeArray))")
                self.mAttributeArray.removeAll()
                if let it = attributeArray {
                    for attribute in it {
                        self.mAttributeArray.append(attribute)
                    }
                }
                
                for delegate in self.delegates.allObjects {
                    (delegate as! RtmDelegate).onAttributeArrayUpdated(isInit: true)
                }
            }
        })
    }
    
    func findValueFromAttributeList(_ key: String) -> String? {
        for attribute in mAttributeArray {
            if attribute.key == key {
                return attribute.value
            }
        }
        return nil
    }
    
    private func initMembers() {
        mRtmChannel?.getMembersWithCompletion({ (rtmMembers, code) in
            if code == .ok {
                if let it = rtmMembers {
                    for member in it {
                        self.getUserAttributes(member)
                    }
                }
            }
        })
    }
    
    private func getUserAttributes(_ rtmMember: AgoraRtmMember) {
        let userId = rtmMember.userId
        mRtmKit?.getUserAllAttributes(rtmMember.userId, completion: { (rtmAttributes, uid, code) in
            if let it = rtmAttributes, it.count > 0 {
                let value = it[0].value
                do {
                    let data = value.data(using: .utf8)
                    let member = try JSONDecoder().decode(Member.self, from: data!)
                    
                    self.mMemberMap.removeValue(forKey: userId)
                    self.mMemberMap[userId] = member
                    
                    for delegate in self.delegates.allObjects {
                        (delegate as! RtmDelegate).onMemberUpdated(userId: userId, member: member)
                    }
                } catch let err as NSError {
                    print(err)
                }
            }
        })
    }
    
    func setLocalUserAttributes(_ key: String, _ value: String) {
        let attribute = AgoraRtmAttribute()
        attribute.key = key
        attribute.value = value
        setLocalUserAttributes(attribute)
    }
    
    private func setLocalUserAttributes(_ attribute: AgoraRtmAttribute) {
        setLocalUserAttributes([attribute])
    }
    
    private func setLocalUserAttributes(_ attributes: [AgoraRtmAttribute]) {
        mRtmKit?.setLocalUserAttributes(attributes, completion: nil)
    }
    
    func addOrUpdateChannelAttributes(_ key: String, _ value: String) {
        let attribute = AgoraRtmChannelAttribute()
        attribute.key = key
        attribute.value = value
        addOrUpdateChannelAttributes(attribute)
    }
    
    private func addOrUpdateChannelAttributes(_ attribute: AgoraRtmChannelAttribute) {
        addOrUpdateChannelAttributes([attribute])
    }
    
    private func addOrUpdateChannelAttributes(_ attributeArray: [AgoraRtmChannelAttribute]) {
        mRtmKit?.addOrUpdateChannel(mChannelId!, attributes: attributeArray, options: options(), completion: { (code) in
            if code == .attributeOperationErrorOk {
                print("addOrUpdateChannelAttributes success")
            } else {
                print("addOrUpdateChannelAttributes fail")
            }
        })
    }
    
    private func options() -> AgoraRtmChannelAttributeOptions {
        let options = AgoraRtmChannelAttributeOptions()
        options.enableNotificationToChannelMembers = true
        return options
    }
    
    func deleteChannelAttributesByKey(_ key: String) {
        mRtmKit?.deleteChannel(mChannelId!, attributesByKeys: [key], options: options(), completion: nil)
    }
    
    func sendMessage(_ content: String) {
        let message = AgoraRtmMessage(text: content)
        mRtmChannel?.send(message, completion: { (code) in
            if code == .errorOk {
                print("sendChannelMessage success")
            } else {
                print("sendChannelMessage fail")
            }
        })
    }
    
    func sendMessageToPeer(_ userId: String?, _ content: String) {
        if userId == nil {
            return
        }
        
        let message = AgoraRtmMessage.init(text: content)
        mRtmKit?.send(message, toPeer: userId!, completion: { (code) in
            if code == .ok {
                print("sendMessage success")
            } else {
                print("sendMessage fail")
            }
        })
    }
    
    func saveMessageToList(_ message: Message) {
        mMessageArray.append(message)
        for delegate in self.delegates.allObjects {
            (delegate as! RtmDelegate).onMessageUpdated()
        }
    }
    
    func leave() {
        mAttributeArray.removeAll()
        mMemberMap.removeAll()
        mMessageArray.removeAll()
        mRtmChannel?.leave(completion: nil)
        mRtmChannel = nil
    }
}

extension RtmManager: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        print("onPeerMessageReceived \(message) \(peerId)")
        for delegate in self.delegates.allObjects {
            (delegate as! RtmDelegate).onOrderReceived(message: message)
        }
    }
}

extension RtmManager: AgoraRtmChannelDelegate {
    func channel(_ channel: AgoraRtmChannel, attributeUpdate attributes: [AgoraRtmChannelAttribute]) {
        print("onAttributeUpdate \(attributes)")
        mAttributeArray.removeAll()
        for attribute in attributes {
            mAttributeArray.append(attribute)
        }
        for delegate in self.delegates.allObjects {
            (delegate as! RtmDelegate).onAttributeArrayUpdated(isInit: false)
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        print("onChannelMessageReceived \(message) \(member)")
        for delegate in self.delegates.allObjects {
            (delegate as! RtmDelegate).onMessageReceived(message: message)
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        print("onMemberJoined \(member)")
        getUserAttributes(member)
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        print("onMemberLeft \(member)")
        let userId = member.userId
        mMemberMap.removeValue(forKey: userId)
        for delegate in self.delegates.allObjects {
            (delegate as! RtmDelegate).onMemberUpdated(userId: userId, member: nil)
        }
    }
}
