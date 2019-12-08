//
//  BusinessManager.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

import AgoraAudioKit
import AgoraRtmKit

protocol BussinessDelegate: class {
    func onSeatsUpdated(start: Int, count: Int)
    
    func onGiftReceived(userId: String)
}

class BussinessManager: NSObject {
    static var MAX_SEAT_NUM = 10
    static var KEY_ANCHOR_ID = "anchorId"
    static var KEY_SEAT_ARRAY = "seatArray"
    static var KEY_USER_INFO = "userInfo"
    static var ORDER_TO_AUDIENCE = "toAudience"
    static var ORDER_TO_BROADCASTER = "toBroadcaster"
    static var ORDER_SWITCH_MUTE = "switchMute"
    
    static let sharedInstance = BussinessManager()
    
    private let mName = MemberUtils.getName()
    private let mHeader = MemberUtils.getHeaderIndex()
    
    weak var delegate: BussinessDelegate?
    var mSeatArray = [Seat?](repeating: nil, count: MAX_SEAT_NUM)
    
    private override init() {}
    
    private func indexOfSeatArray(_ userId: String) -> Int {
        for (index, seat) in mSeatArray.enumerated() {
            if seat?.userId == userId {
                return index
            }
        }
        return NSNotFound
    }
    
    func updateSeatArray() {
        let value = RtmManager.sharedInstance.findValueFromAttributeList(BussinessManager.KEY_SEAT_ARRAY)
        if let it = value {
            do {
                let data = it.data(using: .utf8)
                let seats = try JSONDecoder().decode([Seat?].self, from: data!)
                for (index, seat) in seats.enumerated() {
                    let str1 = try JSONEncoder().encode(mSeatArray[index])
                    let str2 = try JSONEncoder().encode(seat)
                    if str1 != str2 {
                        mSeatArray[index] = seat
                        delegate?.onSeatsUpdated(start: index, count: 1)
                    }
                }
            } catch let err as NSError {
                print(err)
            }
        }
    }
    
    func toBroadcaster(_ userId: String, _ position: Int) -> Bool {
        let index = indexOfSeatArray(userId)
        if index != NSNotFound {
            // TODO alert
            return false
        } else {
            let seat = mSeatArray[position]
            
            if seat != nil {
                return false
            }
        
            if BaseUtils.isMyself(userId) {
                RtcManager.sharedInstance.setClientRole(.broadcaster)
            } else {
                if !BaseUtils.isAnchorMyself() {
                    return false
                }
                RtmManager.sharedInstance.sendMessageToPeer(userId, BussinessManager.ORDER_TO_BROADCASTER)
            }
            
            mSeatArray[position] = Seat(userId: userId)
            notifySeatArrayUpdated(position)
        }
        return true
    }
    
    private func notifySeatArrayUpdated(_ position: Int) {
        do {
            let data = try JSONEncoder().encode(mSeatArray)
            let value = String(data: data, encoding: .utf8)
            RtmManager.sharedInstance.addOrUpdateChannelAttributes(BussinessManager.KEY_SEAT_ARRAY, value!)
        } catch let err as NSError {
            print(err)
        }
        
        delegate?.onSeatsUpdated(start: position, count: 1)
    }
    
    func toAudience(_ userId: String) {
        let index = indexOfSeatArray(userId)
        if index != NSNotFound {
            toAudience(index)
        }
    }
    
    func autoRole(_ userId: String) {
        let index = indexOfSeatArray(userId)
        if index != NSNotFound {
            toAudience(index)
        } else {
            for (index, seat) in mSeatArray.enumerated() {
                if seat == nil {
                    toBroadcaster(userId, index)
                    return
                }
            }
        }
    }
    
    func toAudience(_ position: Int) {
        let seat = mSeatArray[position]
        if let it = seat {
            if it.isClosed {
                return
            }
            
            let userId = it.userId
            if BaseUtils.isMyself(userId) {
                RtcManager.sharedInstance.setClientRole(.audience)
            } else {
                if !BaseUtils.isAnchorMyself() {
                    return
                }
                RtmManager.sharedInstance.sendMessageToPeer(userId, BussinessManager.ORDER_TO_AUDIENCE)
            }
            
            mSeatArray[position] = nil
            notifySeatArrayUpdated(position)
        }
    }
    
    func switchMute(_ userId: String) {
        let index = indexOfSeatArray(userId)
        if index != NSNotFound {
            switchMute(index)
        }
    }
    
    func switchMute(_ position: Int) {
        let seat = mSeatArray[position]
        if let it = seat {
            if it.isClosed {
                return
            }
            
            let userId = it.userId
            if BaseUtils.isMyself(userId) {
                RtcManager.sharedInstance.muteLocalAudioStream(!isMuted(userId))
            } else {
                if !BaseUtils.isAnchorMyself() {
                    return
                }
                RtmManager.sharedInstance.sendMessageToPeer(userId, BussinessManager.ORDER_SWITCH_MUTE)
            }
        }
    }
    
    func closeSeat(_ position: Int) {
        if !BaseUtils.isAnchorMyself() {
            return
        }
        
        let seat = mSeatArray[position]
        if let it = seat {
            if it.isClosed {
                return
            }
            RtmManager.sharedInstance.sendMessageToPeer(it.userId, BussinessManager.ORDER_TO_AUDIENCE)
        }
        
        mSeatArray[position] = Seat(isClosed: true)
        notifySeatArrayUpdated(position)
    }
    
    func openSeat(_ position: Int) {
        if !BaseUtils.isAnchorMyself() {
            return
        }
        
        let seat = mSeatArray[position]
        if let it = seat {
            if !it.isClosed {
                return
            }
        }
        
        mSeatArray[position] = nil
        notifySeatArrayUpdated(position)
    }
    
    func checkAndBeAnchor() {
        let anchorId = RtmManager.sharedInstance.findValueFromAttributeList(BussinessManager.KEY_ANCHOR_ID)
        if anchorId == nil {
            beAnchor()
        }
    }
    
    func beAnchor() {
        let userId = String(Constant.sUserId)
        let flag = toBroadcaster(userId, 0)
        if flag {
            RtmManager.sharedInstance.addOrUpdateChannelAttributes(BussinessManager.KEY_ANCHOR_ID, userId)
        }
    }
    
    func processOrder(_ message: AgoraRtmMessage) {
        switch message.text {
        case BussinessManager.ORDER_TO_AUDIENCE:
            RtcManager.sharedInstance.setClientRole(.audience)
            break
        case BussinessManager.ORDER_TO_BROADCASTER:
            RtcManager.sharedInstance.setClientRole(.broadcaster)
            break
        case BussinessManager.ORDER_SWITCH_MUTE:
            switchMute(String(Constant.sUserId))
            break
        default:
            break
        }
    }
    
    func processMessage(_ message: AgoraRtmMessage) {
        do {
            let data = message.text.data(using: .utf8)
            let msg = try JSONDecoder().decode(Message.self, from: data!)
            switch msg.type {
            case Message.TYPE_GIFT:
                delegate?.onGiftReceived(userId: msg.sendId)
                break
            default:
                RtmManager.sharedInstance.saveMessageToList(msg)
                break
            }
        } catch let err as NSError {
            print(err)
        }
    }
    
    func sendMessage(_ text: String) {
        do {
            let message = Message(content: text, sendId: Constant.sUserId)
            let data = try JSONEncoder().encode(message)
            let content = String(data: data, encoding: .utf8)
            if let it = content {
                RtmManager.sharedInstance.saveMessageToList(message)
                RtmManager.sharedInstance.sendMessage(it)
            }
        } catch let err as NSError {
            print(err)
        }
    }
    
    func givingGift() {
        do {
            let message = Message(type: Message.TYPE_GIFT, sendId: Constant.sUserId)
            let data = try JSONEncoder().encode(message)
            let content = String(data: data, encoding: .utf8)
            if let it = content {
                RtmManager.sharedInstance.sendMessage(it)
            }
        
            delegate?.onGiftReceived(userId: message.sendId)
        } catch let err as NSError {
            print(err)
        }
    }
    
    func isMuted(_ userId: String?) -> Bool {
        if userId == nil {
            return false
        }
        let audioStatus = RtcManager.sharedInstance.mAudioStatusMap[userId!]
        if let it = audioStatus {
            return it.mute
        }
        return false
    }
    
    func initUserInfo() {
        do {
            let member = Member(name: mName, headerIndex: mHeader)
            let data = try JSONEncoder().encode(member)
            let value = String(data: data, encoding: .utf8)
            if let it = value {
                RtmManager.sharedInstance.setLocalUserAttributes(BussinessManager.KEY_USER_INFO, it)
            }
        } catch let err as NSError {
            print(err)
        }
    }
    
    func destroy() {
        delegate = nil
        mSeatArray.removeAll()
        if BaseUtils.isAnchorMyself() {
            // just for demo, delete anchorId from channel attributes
            RtmManager.sharedInstance.deleteChannelAttributesByKey(BussinessManager.KEY_ANCHOR_ID)
        }
    }
}
