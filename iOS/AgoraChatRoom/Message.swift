//
//  Message.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

struct Message: Codable {
    static var TYPE_TEXT = 0
    static var TYPE_IMAGE = 1
    static var TYPE_GIFT = 2
    
    var type: Int = Message.TYPE_TEXT
    var content: String?
    var sendId: String
    
    init(type: Int, sendId: UInt) {
        self.type = type
        self.sendId = String(sendId)
    }
    
    init(content: String, sendId: UInt) {
        self.content = content
        self.sendId = String(sendId)
    }
}
