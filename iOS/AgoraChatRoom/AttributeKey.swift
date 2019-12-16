//
//  AttributeKey.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/11.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

class AttributeKey {
    static let KEY_ANCHOR_ID = "anchorId"
    static let KEY_SEAT_ARRAY = initSeatKeys()
    static let KEY_USER_INFO = "userInfo"

    private static func initSeatKeys() -> [String] {
        var strings = [String]()
        for i in 0..<ChannelData.MAX_SEAT_NUM {
            strings.append("seat\(i)")
        }
        return strings
    }

    static func indexOfSeatKey(_ key: String) -> Int {
        for (i, item) in KEY_SEAT_ARRAY.enumerated() {
            if key == item {
                return i
            }
        }
        return NSNotFound
    }
}
