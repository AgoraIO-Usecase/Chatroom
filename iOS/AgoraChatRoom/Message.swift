//
//  Message.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

struct Message: Codable {
    static let MESSAGE_TYPE_TEXT = 0
    static let MESSAGE_TYPE_IMAGE = 1
    static let MESSAGE_TYPE_GIFT = 2
    static let MESSAGE_TYPE_ORDER = 3

    static let ORDER_TYPE_AUDIENCE = "toAudience"
    static let ORDER_TYPE_BROADCASTER = "toBroadcaster"
    static let ORDER_TYPE_MUTE = "mute"

    var messageType: Int = Message.MESSAGE_TYPE_TEXT
    var orderType: String?
    var content: String?
    var sendId: String

    init(content: String?, sendId: UInt) {
        self.content = content
        self.sendId = String(sendId)
    }

    init(messageType: Int, content: String?, sendId: UInt) {
        self.init(content: content, sendId: sendId)
        self.messageType = messageType
    }

    init(orderType: String, content: String?, sendId: UInt) {
        self.init(content: content, sendId: sendId)
        self.messageType = Message.MESSAGE_TYPE_ORDER
        self.orderType = orderType
    }

    func toJsonString() -> String? {
        if let data = try? JSONEncoder().encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    static func fromJsonString(_ str: String) -> Message? {
        if let data = str.data(using: .utf8) {
            return try? JSONDecoder().decode(Message.self, from: data)
        }
        return nil
    }
}
