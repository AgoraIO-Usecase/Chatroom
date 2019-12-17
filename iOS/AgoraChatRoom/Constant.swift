//
//  Constant.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/27.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

class Constant: NSObject {
    static let sAppId = <#Agora App Id#>
    static let sRtcToken = <#Agora Rtc Token#>
    static let sRtmToken = <#Agora Rtm Token#>

    static let sUserId: UInt = UInt(UInt32(bitPattern: MemberUtils.getUserId()))

    static func isMyself(_ userId: String) -> Bool {
        userId == String(sUserId)
    }

    static let sName = MemberUtils.getName()
    static let sAvatarIndex = MemberUtils.getAvatarIndex()
}
