//
//  ChannelData.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/10.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation
import UIKit

class ChannelData {
    static let MAX_SEAT_NUM = 10

    func release() {
        mAnchorId = nil
        for i in 0..<mSeatArray.count {
            mSeatArray[i] = nil
        }
        mUserStatus.removeAll()
        mMemberArray.removeAll()
        mMessageArray.removeAll()
    }

    // MARK: - AnchorId
    private var mAnchorId: String?

    func setAnchorId(_ anchorId: String) -> Bool {
        if anchorId == mAnchorId {
            return false
        }
        mAnchorId = anchorId
        return true
    }

    func hasAnchor() -> Bool {
        guard let `mAnchorId` = mAnchorId else {
            return false
        }
        return !mAnchorId.isEmpty
    }

    func isAnchor(_ userId: String) -> Bool {
        userId == mAnchorId
    }

    func isAnchorMyself() -> Bool {
        isAnchor(String(Constant.sUserId))
    }

    // MARK: - SeatArray
    private var mSeatArray = [Seat?].init(repeating: nil, count: ChannelData.MAX_SEAT_NUM)

    func getSeatArray() -> [Seat?] {
        mSeatArray
    }

    func updateSeat(_ position: Int, _ seat: Seat?) -> Bool {
        if let `seat` = seat {
            if let temp = mSeatArray[position] {
                if seat.userId == temp.userId {
                    return false
                }
            }
        } else {
            if mSeatArray[position] == nil {
                return false
            }
        }
        mSeatArray[position] = seat
        return true
    }

    func indexOfSeatArray(_ userId: String) -> Int {
        for (i, seat) in mSeatArray.enumerated() {
            guard let `seat` = seat else {
                continue
            }
            if userId == seat.userId {
                return i
            }
        }
        return NSNotFound
    }

    func firstIndexOfEmptySeat() -> Int {
        for (i, seat) in mSeatArray.enumerated() {
            guard let `seat` = seat, let userId = seat.userId else {
                return i
            }
            if !isUserOnline(userId) {
                return i
            }
        }
        return NSNotFound
    }

    // MARK: - UserStatus
    private var mUserStatus = [String: Bool]()

    func isUserOnline(_ userId: String) -> Bool {
        let muted = mUserStatus[userId]
        return muted != nil
    }

    func isUserMuted(_ userId: String) -> Bool {
        guard let muted = mUserStatus[userId] else {
            return false
        }
        return muted
    }

    func addOrUpdateUserStatus(_ uid: UInt, _ muted: Bool) {
        mUserStatus[String(uid)] = muted
    }

    func removeUserStatus(_ uid: UInt) {
        mUserStatus.removeValue(forKey: String(uid))
    }

    // MARK: - MemberArray
    private var mMemberArray = [Member]()

    func getMemberArray() -> [Member] {
        mMemberArray
    }

    func addOrUpdateMember(_ member: Member) {
        let index = mMemberArray.firstIndex { (item) -> Bool in
            member.userId == item.userId
        }
        if let `index` = index, index != NSNotFound {
            mMemberArray[index].update(member)
        } else {
            mMemberArray.append(member)
        }
    }

    func removeMember(_ userId: String) {
        let index = mMemberArray.firstIndex { (item) -> Bool in
            userId == item.userId
        }
        if let `index` = index, index != NSNotFound {
            mMemberArray.remove(at: index)
        }
    }

    func getMember(_ userId: String) -> Member? {
        for member in mMemberArray {
            if userId == member.userId {
                return member
            }
        }
        return nil
    }

    func getMemberAvatar(_ userId: String) -> UIImage {
        guard let member = getMember(userId), let avatarIndex = member.avatarIndex else {
            return #imageLiteral(resourceName: "ic_unkown")
        }
        return MemberUtil.getAvatarRes(avatarIndex)
    }

    func indexOfMemberArray(_ userId: String) -> Int {
        let index = mMemberArray.firstIndex { (member) -> Bool in
            userId == member.userId
        }
        if let it = index {
            return it
        } else {
            return NSNotFound
        }
    }

    // MARK: - MessageArray
    private var mMessageArray = [Message]()

    func getMessageArray() -> [Message] {
        mMessageArray
    }

    func addMessage(message: Message) -> Int {
        mMessageArray.append(message)
        return mMessageArray.count - 1
    }
}
