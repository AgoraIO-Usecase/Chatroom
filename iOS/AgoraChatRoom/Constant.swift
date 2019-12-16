//
//  Constant.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/27.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

class Constant: NSObject {
    static let sAppId = "2b4b76e458cf439aa7cd313b9504f0a4"

    static let sUserId: UInt = UInt(UInt32(bitPattern: MemberUtils.getUserId()))

    static func isMyself(_ userId: String) -> Bool {
        userId == String(sUserId)
    }

    static let sName = MemberUtils.getName()
    static let sAvatarIndex = MemberUtils.getAvatarIndex()
}
