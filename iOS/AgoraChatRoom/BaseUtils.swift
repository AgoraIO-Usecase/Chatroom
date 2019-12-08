//
//  BaseUtils.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

class BaseUtils: NSObject {
    static func isMyself(_ userId: String?) -> Bool {
        if userId == nil {
            return false
        }
        return userId == String(Constant.sUserId)
    }
    
    static func isAnchor(_ userId: String?) -> Bool {
        let anchorId = RtmManager.sharedInstance.findValueFromAttributeList(BussinessManager.KEY_ANCHOR_ID)
        return userId == anchorId
    }
    
    static func isAnchorMyself() -> Bool {
        return isAnchor(String(Constant.sUserId))
    }
}
