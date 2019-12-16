//
//  Member.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

struct Member: Codable {
    var userId: String
    var name: String?
    var avatarIndex: Int?

    init(userId: String) {
        self.userId = userId
    }

    init(userId: String, name: String, avatarIndex: Int) {
        self.init(userId: userId)
        self.name = name
        self.avatarIndex = avatarIndex
    }

    mutating func update(_ member: Member) {
        self.name = member.name
        self.avatarIndex = member.avatarIndex
    }

    func toJsonString() -> String? {
        if let data = try? JSONEncoder().encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    static func fromJsonString(_ str: String) -> Member? {
        if let data = str.data(using: .utf8) {
            return try? JSONDecoder().decode(Member.self, from: data)
        }
        return nil
    }
}
