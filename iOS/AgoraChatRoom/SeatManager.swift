//
// Created by LXH on 2019/12/11.
// Copyright (c) 2019 CavanSu. All rights reserved.
//

import Foundation

import AgoraRtmKit

protocol SeatManager: class {
    func getChannelData() -> ChannelData

    func getMessageManager() -> MessageManager

    func getRtcManager() -> RtcManager

    func getRtmManager() -> RtmManager

    func onSeatUpdated(position: Int)
}

extension SeatManager {
    func toBroadcaster(_ userId: String, _ position: Int) {
        print("toBroadcaster \(userId) \(position)")

        let channelData = getChannelData()
        if Constant.isMyself(userId) {
            let index = channelData.indexOfSeatArray(userId)
            if index != NSNotFound {
                if position == index {
                    getRtcManager().setClientRole(.broadcaster)
                } else {
                    changeSeat(userId, index, position, { [weak self] (code) in
                        if code == .attributeOperationErrorOk {
                            self?.getRtcManager().setClientRole(.broadcaster)
                        }
                    })
                }
            } else {
                occupySeat(userId, position, { [weak self] (code) in
                    if code == .attributeOperationErrorOk {
                        self?.getRtcManager().setClientRole(.broadcaster)
                    }
                })
            }
        } else {
            getMessageManager().sendOrder(userId: userId, orderType: Message.ORDER_TYPE_BROADCASTER, content: String(position), callback: nil)
        }
    }

    func toAudience(_ userId: String, _ callback: ((_ success: Bool) -> Void)?) {
        print("toAudience \(userId)")

        let channelData = getChannelData()
        if Constant.isMyself(userId) {
            resetSeat(channelData.indexOfSeatArray(userId), { [weak self] (code) in
                if code == .attributeOperationErrorOk {
                    self?.getRtcManager().setClientRole(.audience)
                }

                callback?(code == .attributeOperationErrorOk)
            })
        } else {
            getMessageManager().sendOrder(userId: userId, orderType: Message.ORDER_TYPE_AUDIENCE, content: nil, callback: { (code) in
                callback?(code == .ok)
            })
        }
    }

    private func occupySeat(_ userId: String, _ position: Int, _ callback: AgoraRtmAddOrUpdateChannelAttributesBlock?) {
        modifySeat(position, Seat(userId: userId), callback)
    }

    private func resetSeat(_ position: Int, _ callback: AgoraRtmAddOrUpdateChannelAttributesBlock?) {
        modifySeat(position, nil, callback)
    }

    private func changeSeat(_ userId: String, _ oldPosition: Int, _ newPosition: Int, _ callback: AgoraRtmAddOrUpdateChannelAttributesBlock?) {
        resetSeat(oldPosition, { [weak self] (code) in
            if code == .attributeOperationErrorOk {
                guard let `self` = self else {
                    return
                }

                if (self.getChannelData().updateSeat(oldPosition, nil)) {
                    // don't wait onChannelAttributesUpdated, refresh now
                    self.onSeatUpdated(position: oldPosition)
                }
                self.occupySeat(userId, newPosition, callback)
            }
        })
    }

    func muteMic(_ userId: String, _ muted: Bool) {
        if Constant.isMyself(userId) {
            if !getChannelData().isUserOnline(userId) {
                return
            }
            getRtcManager().muteLocalAudioStream(muted)
        } else {
            if !getChannelData().isAnchorMyself() {
                return
            }
            getMessageManager().sendOrder(userId: userId, orderType: Message.ORDER_TYPE_MUTE, content: String(muted), callback: nil)
        }
    }

    func closeSeat(_ position: Int) {
        let channelData = getChannelData()

        if !channelData.isAnchorMyself() {
            return
        }

        if let seat = channelData.getSeatArray()[position], let userId = seat.userId {
            if channelData.isUserOnline(userId) {
                toAudience(userId, { [weak self] (success) in
                    if success {
                        self?.modifySeat(position, Seat(isClosed: true), nil)
                    }
                })
                return
            }
        }

        modifySeat(position, Seat(isClosed: true), nil)
    }

    func openSeat(_ position: Int) {
        if !getChannelData().isAnchorMyself() {
            return
        }
        resetSeat(position, nil)
    }

    private func modifySeat(_ position: Int, _ seat: Seat?, _ callback: AgoraRtmAddOrUpdateChannelAttributesBlock?) {
        if position >= 0 && position < AttributeKey.KEY_SEAT_ARRAY.count {
            var json = "null"
            if let data = try? JSONEncoder().encode(seat) {
                if let str = String(data: data, encoding: .utf8) {
                    json = str
                }
            }
            getRtmManager().addOrUpdateChannelAttributes(AttributeKey.KEY_SEAT_ARRAY[position], json, callback)
        }
    }

    func updateSeatArray(_ position: Int, _ value: String) -> Bool {
        if let data = value.data(using: .utf8) {
            let seat = try? JSONDecoder().decode(Seat.self, from: data)
            return getChannelData().updateSeat(position, seat)
        }
        return false
    }
}
