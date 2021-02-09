//
//  ChatRoomManager.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

import AgoraRtcKit
import AgoraRtmKit

protocol ChatRoomDelegate: class {
    func onSeatUpdated(position: Int)

    func onUserGivingGift(userId: String)

    func onMessageAdded(position: Int)

    func onMemberListUpdated(userId: String?)

    func onUserStatusChanged(userId: String, muted: Bool?)

    func onAudioMixingStateChanged(isPlaying: Bool)

    func onAudioVolumeIndication(userId: String, volume: UInt)
}

class ChatRoomManager: SeatManager {
    static let shared = ChatRoomManager()

    private lazy var mRtcManager: RtcManager = {
        let manager = RtcManager.shared
        manager.delegate = self
        return manager
    }()
    private lazy var mRtmManager: RtmManager = {
        let manager = RtmManager.shared
        manager.delegate = self
        return manager
    }()
    weak var delegate: ChatRoomDelegate?

    private var mChannelData = ChannelData()

    private init() {
    }

    func getChannelData() -> ChannelData {
        mChannelData
    }

    func getMessageManager() -> MessageManager {
        self
    }

    func getRtcManager() -> RtcManager {
        mRtcManager
    }

    func getRtmManager() -> RtmManager {
        mRtmManager
    }

    func onSeatUpdated(position: Int) {
        delegate?.onSeatUpdated(position: position)
    }

    func joinChannel(channelId: String) {
        mRtmManager.login(Constant.sUserId, { [weak self] (code) in
            guard let `self` = self else {
                return
            }
            if code == .ok {
                let member = Member(userId: String(Constant.sUserId), name: Constant.sName, avatarIndex: Constant.sAvatarIndex)
                if let json = member.toJsonString() {
                    self.mRtmManager.setLocalUserAttributes(AttributeKey.KEY_USER_INFO, json)
                }

                self.mRtcManager.joinChannel(channelId, Constant.sUserId)
            }
        })
    }

    func leaveChannel() {
        mRtcManager.leaveChannel()
        mRtmManager.leaveChannel()
        mChannelData.release()
    }

    private func checkAndBeAnchor() {
        let myUserId = String(Constant.sUserId)

        if mChannelData.isAnchorMyself() {
            var index = mChannelData.indexOfSeatArray(myUserId)
            if index == NSNotFound {
                index = mChannelData.firstIndexOfEmptySeat()
            }
            toBroadcaster(myUserId, index)
        } else {
            if mChannelData.hasAnchor() {
                return
            }
            mRtmManager.addOrUpdateCloudAttributes(AttributeKey.KEY_ANCHOR_ID, myUserId, { [weak self] (code) in
                guard let `self` = self else {
                    return
                }
                if code == .attributeOperationErrorOk {
                    self.toBroadcaster(myUserId, self.mChannelData.firstIndexOfEmptySeat())
                }
            })
        }
    }

    func givingGift() {
        let message = Message(messageType: Message.MESSAGE_TYPE_GIFT, content: nil, sendId: Constant.sUserId)
        mRtmManager.sendMessage(message.toJsonString(), { [weak self] (code) in
            self?.delegate?.onUserGivingGift(userId: message.sendId)
        })
    }
}

extension ChatRoomManager: MessageManager {
    func sendOrder(userId: String, orderType: String, content: String?, callback: AgoraRtmSendPeerMessageBlock?) {
        if !mChannelData.isAnchorMyself() {
            return
        }
        let message = Message(orderType: orderType, content: content, sendId: Constant.sUserId)
        mRtmManager.sendMessageToPeer(userId, message.toJsonString(), callback)
    }

    func sendMessage(text: String) {
        let message = Message(content: text, sendId: Constant.sUserId)
        mRtmManager.sendMessage(message.toJsonString(), { [weak self] (code) in
            if code == .errorOk {
                self?.addMessage(message: message)
            }
        })
    }

    func processMessage(rtmMessage: AgoraRtmMessage) {
        if let message = Message.fromJsonString(rtmMessage.text) {
            switch message.messageType {
            case Message.MESSAGE_TYPE_TEXT:
                fallthrough
            case Message.MESSAGE_TYPE_IMAGE:
                addMessage(message: message)
            case Message.MESSAGE_TYPE_GIFT:
                delegate?.onUserGivingGift(userId: message.sendId)
            case Message.MESSAGE_TYPE_ORDER:
                let myUserId = String(Constant.sUserId)
                switch message.orderType {
                case Message.ORDER_TYPE_AUDIENCE:
                    toAudience(myUserId, nil)
                case Message.ORDER_TYPE_BROADCASTER:
                    if let content = message.content, let position = Int(content) {
                        toBroadcaster(myUserId, position)
                    }
                case Message.ORDER_TYPE_MUTE:
                    if let content = message.content, let muted = Bool(content) {
                        muteMic(myUserId, muted)
                    }
                default: break
                }
            default: break
            }
        }
    }

    func addMessage(message: Message) {
        let position = mChannelData.addMessage(message: message)
        delegate?.onMessageAdded(position: position)
    }
}

extension ChatRoomManager: RtcDelegate {
    func onJoinChannelSuccess(channelId: String) {
        mRtmManager.joinChannel(channelId, nil)
    }

    func onUserOnlineStateChanged(uid: UInt, isOnline: Bool) {
        if isOnline {
            mChannelData.addOrUpdateUserStatus(uid, false)

            delegate?.onUserStatusChanged(userId: String(uid), muted: false)
        } else {
            mChannelData.removeUserStatus(uid)

            delegate?.onUserStatusChanged(userId: String(uid), muted: nil)
        }
    }

    func onUserMuteAudio(uid: UInt, muted: Bool) {
        mChannelData.addOrUpdateUserStatus(uid, muted)

        delegate?.onUserStatusChanged(userId: String(uid), muted: muted)
    }

    func onAudioMixingStateChanged(isPlaying: Bool) {
        delegate?.onAudioMixingStateChanged(isPlaying: isPlaying)
    }

    func onAudioVolumeIndication(uid: UInt, volume: UInt) {
        delegate?.onAudioVolumeIndication(userId: String(uid), volume: volume)
    }
}

extension ChatRoomManager: RtmDelegate {
    func onCloudAttributesLoaded() {
        checkAndBeAnchor()
    }

    func onCloudAttributesUpdated(attributes: [String: String]) {
        for attribute in attributes {
            let key = attribute.key
            switch key {
            case AttributeKey.KEY_ANCHOR_ID:
                let userId = attribute.value
                if mChannelData.setAnchorId(userId) {
                    print("onCloudAttributesUpdated \(key) \(userId)")
                }
            default:
                let index = AttributeKey.indexOfSeatKey(key)
                if index != NSNotFound {
                    let value = attribute.value
                    if updateSeatArray(index, value) {
                        print("onCloudAttributesUpdated \(key) \(value)")

                        delegate?.onSeatUpdated(position: index)
                    }
                }
            }
        }
    }

    func onInitMembers(members: [AgoraRtmMember]) {
        for member in members {
            mChannelData.addOrUpdateMember(Member(userId: member.userId))
        }

        delegate?.onMemberListUpdated(userId: nil)
    }

    func onMemberJoined(userId: String, attributes: [String: String]) {
        for attribute in attributes {
            if AttributeKey.KEY_USER_INFO == attribute.key {
                if let member = Member.fromJsonString(attribute.value) {
                    mChannelData.addOrUpdateMember(member)

                    delegate?.onMemberListUpdated(userId: userId)
                }
                break
            }
        }
    }

    func onMemberLeft(userId: String) {
        mChannelData.removeMember(userId)

        delegate?.onMemberListUpdated(userId: userId)
    }

    func onMessageReceived(message: AgoraRtmMessage) {
        processMessage(rtmMessage: message)
    }
}
