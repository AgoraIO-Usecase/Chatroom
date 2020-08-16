//
//  SeatCell.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class SeatCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var seat: UIImageView!
    @IBOutlet weak var mute: UIImageView!

    private var mChannelData: ChannelData?
    private var mPosition: Int?
    private var mSeat: Seat?

    func update(_ channelData: ChannelData, _ position: Int) {
        mChannelData = channelData
        mPosition = position
        mSeat = channelData.getSeatArray()[position]
        if let `mSeat` = mSeat {
            if mSeat.isClosed {
                seat.image = #imageLiteral(resourceName: "ic_ban")
                mute.isHidden = true
            } else {
                if let userId = mSeat.userId, channelData.isUserOnline(userId) {
                    seat.image = channelData.getMemberAvatar(userId)
                    mute.isHidden = !channelData.isUserMuted(userId)
                } else {
                    seat.image = #imageLiteral(resourceName: "ic_join")
                    mute.isHidden = true
                }
            }
        } else {
            seat.image = #imageLiteral(resourceName: "ic_join")
            mute.isHidden = true
        }
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard let menuItems = UIMenuController.shared.menuItems else {
            return false
        }
        if !menuItems.contains(where: { (item) -> Bool in
            action == item.action
        }) {
            return false
        }

        if let `mChannelData` = mChannelData {
            let isAnchor = mChannelData.isAnchorMyself()
            if let `mSeat` = mSeat {
                if mSeat.isClosed {
                    if isAnchor {
                        return action == #selector(openSeat)
                    }
                    return false
                } else {
                    if let userId = mSeat.userId {
                        if mChannelData.isUserOnline(userId) {
                            if isAnchor {
                                if Constant.isMyself(userId) {
                                    return false
                                }
                                let muted = mChannelData.isUserMuted(userId)
                                return [#selector(toAudience), muted ? #selector(turnOnMic) : #selector(turnOffMic), #selector(closeSeat)].contains(action)
                            } else {
                                if Constant.isMyself(userId) {
                                    return action == #selector(toAudience)
                                }
                            }
                            return false
                        }
                    }
                }
            }
            if isAnchor {
                return [#selector(toBroadcast), #selector(closeSeat)].contains(action)
            } else {
                return action == #selector(toBroadcast)
            }
        }
        return false
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        AlertUtil.showMenu(self, [#selector(toBroadcast), #selector(toAudience), #selector(turnOffMic), #selector(turnOnMic), #selector(closeSeat), #selector(openSeat)])
    }

    @objc private func toBroadcast() {
        if let `mPosition` = mPosition {
            ChatRoomManager.shared.toBroadcaster(String(Constant.sUserId), mPosition)
        }
    }

    @objc private func toAudience() {
        if let `mSeat` = mSeat, let userId = mSeat.userId {
            ChatRoomManager.shared.toAudience(userId, nil)
        }
    }

    @objc private func turnOffMic() {
        if let `mSeat` = mSeat, let userId = mSeat.userId {
            ChatRoomManager.shared.muteMic(userId, true)
        }
    }

    @objc private func turnOnMic() {
        if let `mSeat` = mSeat, let userId = mSeat.userId {
            ChatRoomManager.shared.muteMic(userId, false)
        }
    }

    @objc private func closeSeat() {
        if let `mPosition` = mPosition {
            ChatRoomManager.shared.closeSeat(mPosition)
        }
    }

    @objc private func openSeat() {
        if let `mPosition` = mPosition {
            ChatRoomManager.shared.openSeat(mPosition)
        }
    }
}
