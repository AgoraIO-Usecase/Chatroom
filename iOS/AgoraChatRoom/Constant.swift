//
//  Constant.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/27.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

struct Constant {
    static let sUserId: UInt = UInt(UInt32(bitPattern: MemberUtil.getUserId()))

    static func isMyself(_ userId: String) -> Bool {
        userId == String(sUserId)
    }

    static let sName = MemberUtil.getName()
    static let sAvatarIndex = MemberUtil.getAvatarIndex()
}
