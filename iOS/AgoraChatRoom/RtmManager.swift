//
//  RtmManager.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

import AgoraRtmKit

protocol RtmDelegate: class {
    func onChannelAttributesLoaded()

    func onChannelAttributesUpdated(attributes: [String: String])

    func onInitMembers(members: [AgoraRtmMember])

    func onMemberJoined(userId: String, attributes: [String: String])

    func onMemberLeft(userId: String)

    func onMessageReceived(message: AgoraRtmMessage)
}

struct Key {
    static var key = "channelId"
}

extension AgoraRtmChannel {
    var channelId: String {
        get {
            return objc_getAssociatedObject(self, &Key.key) as! String
        }
        set {
            objc_setAssociatedObject(self, &Key.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

class RtmManager: NSObject {
    static let shared = RtmManager()

    weak var delegate: RtmDelegate?
    private var mRtmKit: AgoraRtmKit?
    private var mRtmChannel: AgoraRtmChannel?
    private var mIsLogin: Bool = false

    private override init() {
        super.init()
    }

    func initialize() {
        if mRtmKit == nil {
            mRtmKit = AgoraRtmKit.init(appId: KeyCenter.AppId, delegate: self)
        }
    }

    func login(_ userId: UInt, _ block: AgoraRtmLoginBlock?) {
        if mIsLogin {
            block?(.ok)
            return
        }

        mRtmKit?.login(byToken: KeyCenter.RtmToken, user: String(userId), completion: { [weak self] (code) in
            print("rtm login \(code.rawValue)")

            self?.mIsLogin = code == .ok
            block?(code)
        })
    }

    func joinChannel(_ channelId: String, _ block: AgoraRtmJoinChannelBlock?) {
        if let `mRtmKit` = mRtmKit {
            leaveChannel()

            print("joinChannel \(channelId)")

            guard let `rtmChannel` = mRtmKit.createChannel(withId: channelId, delegate: self) else {
                return
            }
            rtmChannel.channelId = channelId
            rtmChannel.join(completion: { [weak self] (code) in
                print("rtm join \(code.rawValue)")

                guard let `self` = self else {
                    return
                }

                self.mRtmChannel = rtmChannel

                if code == .channelErrorOk {
                    self.getChannelAllAttributes(channelId)
                    self.getMembers()
                }

                block?(code)
            })
        }
    }

    private func getChannelAllAttributes(_ channelId: String) {
        mRtmKit?.getChannelAllAttributes(channelId, completion: { [weak self] (attributeArray, code) in
            print("getChannelAllAttributes \(code.rawValue)")

            guard let `self` = self else {
                return
            }

            if code == .attributeOperationErrorOk {
                self.processChannelAttributes(attributeArray)
                self.delegate?.onChannelAttributesLoaded()
            }
        })
    }

    private func processChannelAttributes(_ attributeArray: [AgoraRtmChannelAttribute]?) {
        guard let `attributeArray` = attributeArray else {
            return
        }

        var attributes = [String: String]()
        for attribute in attributeArray {
            attributes[attribute.key] = attribute.value
        }

        delegate?.onChannelAttributesUpdated(attributes: attributes)
    }

    private func getMembers() {
        mRtmChannel?.getMembersWithCompletion({ [weak self] (rtmMembers, code) in
            if code == .ok {
                guard let `self` = self, let `rtmMembers` = rtmMembers else {
                    return
                }
                self.delegate?.onInitMembers(members: rtmMembers)

                for member in rtmMembers {
                    self.getUserAllAttributes(member.userId)
                }
            }
        })
    }

    private func getUserAllAttributes(_ userId: String) {
        mRtmKit?.getUserAllAttributes(userId, completion: { [weak self] (rtmAttributes, uid, code) in
            print("getUserAllAttributes \(code.rawValue)")

            self?.processUserAttributes(userId, rtmAttributes)
        })
    }

    private func processUserAttributes(_ userId: String, _ attributeArray: [AgoraRtmAttribute]?) {
        if let `attributeArray` = attributeArray {
            var attributes = [String: String]()
            for attribute in attributeArray {
                attributes[attribute.key] = attribute.value
            }

            delegate?.onMemberJoined(userId: userId, attributes: attributes)
        }
    }

    func setLocalUserAttributes(_ key: String, _ value: String) {
        if let `mRtmKit` = mRtmKit {
            let attribute = AgoraRtmAttribute()
            attribute.key = key
            attribute.value = value
            mRtmKit.setLocalUserAttributes([attribute], completion: nil)
        }
    }

    func addOrUpdateChannelAttributes(_ key: String, _ value: String, _ block: AgoraRtmAddOrUpdateChannelAttributesBlock?) {
        if let `mRtmKit` = mRtmKit, let `mRtmChannel` = mRtmChannel {
            let attribute = AgoraRtmChannelAttribute()
            attribute.key = key
            attribute.value = value
            mRtmKit.addOrUpdateChannel(mRtmChannel.channelId, attributes: [attribute], options: options(), completion: { (code) in
                print("addOrUpdateChannelAttributes \(key) \(value) \(code.rawValue)")

                block?(code)
            })
        }
    }

    private func options() -> AgoraRtmChannelAttributeOptions {
        let options = AgoraRtmChannelAttributeOptions()
        options.enableNotificationToChannelMembers = true
        return options
    }

    func deleteChannelAttributesByKey(_ key: String) {
        if let `mRtmKit` = mRtmKit, let `mRtmChannel` = mRtmChannel {
            mRtmKit.deleteChannel(mRtmChannel.channelId, attributesByKeys: [key], options: options(), completion: nil)
        }
    }

    func sendMessage(_ content: String?, _ block: AgoraRtmSendChannelMessageBlock?) {
        if let `content` = content, let mRtmChannel = mRtmChannel {
            let message = AgoraRtmMessage(text: content)
            mRtmChannel.send(message, completion: { (code) in
                print("sendMessage \(code.rawValue)")

                block?(code)
            })
        }
    }

    func sendMessageToPeer(_ userId: String, _ content: String?, _ block: AgoraRtmSendPeerMessageBlock?) {
        if let `content` = content, let `mRtmKit` = mRtmKit {
            let message = AgoraRtmMessage(text: content)
            mRtmKit.send(message, toPeer: userId, completion: { (code) in
                print("sendMessageToPeer \(code.rawValue)")

                block?(code)
            })
        }
    }

    func leaveChannel() {
        print("leaveChannel \(mRtmChannel?.channelId)")

        mRtmChannel?.leave(completion: nil)
        mRtmChannel = nil
    }
}

extension RtmManager: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        print("onPeerMessageReceived \(message.text) \(peerId)")

        delegate?.onMessageReceived(message: message)
    }
}

extension RtmManager: AgoraRtmChannelDelegate {
    func channel(_ channel: AgoraRtmChannel, attributeUpdate attributes: [AgoraRtmChannelAttribute]) {
        print("onAttributeUpdate")

        processChannelAttributes(attributes)
    }

    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        print("onChannelMessageReceived \(message.text) \(member.userId)")

        delegate?.onMessageReceived(message: message)
    }

    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        let userId = member.userId
        print("onMemberJoined \(userId)")

        getUserAllAttributes(userId)
    }

    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        let userId = member.userId
        print("onMemberLeft \(userId)")

        delegate?.onMemberLeft(userId: userId)
    }
}
