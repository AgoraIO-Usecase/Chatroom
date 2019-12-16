//
//  MemberUtils.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/5.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class MemberUtils: NSObject {
    static let surNames = ["赵", "钱", "孙", "李", "周", "吴", "郑", "王", "冯", "陈", "褚", "卫"]
    static let names = ["富强", "民主", "文明", "和谐", "自由", "平等", "公正", "法治", "爱国", "敬业", "诚信", "友善"]
    static let avatarImages: [UIImage] = [#imageLiteral(resourceName: "img_header_0"), #imageLiteral(resourceName: "img_header_1"), #imageLiteral(resourceName: "img_header_2"), #imageLiteral(resourceName: "img_header_3"), #imageLiteral(resourceName: "img_header_4"), #imageLiteral(resourceName: "img_header_5"), #imageLiteral(resourceName: "img_header_6"), #imageLiteral(resourceName: "img_header_7"), #imageLiteral(resourceName: "img_header_8"), #imageLiteral(resourceName: "img_header_9"), #imageLiteral(resourceName: "img_header_10"), #imageLiteral(resourceName: "img_header_11")]
    
    static func getUserId() -> Int32 {
        var userId = Int32(truncatingIfNeeded: UserDefaults.standard.integer(forKey: "userId"))
        if userId == 0 {
            userId = abs(Int32(truncatingIfNeeded: UUID().uuidString.hashValue))
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.synchronize()
        }
        return userId
    }
    
    static func getName() -> String {
        guard let name = UserDefaults.standard.string(forKey: "name") else {
            let name = "\(randomName(surNames)) \(randomName(names))"
            UserDefaults.standard.set(name, forKey: "name")
            UserDefaults.standard.synchronize()
            return name
        }
        return name
    }

    private static func randomName(_ strArray: [String]) -> String {
        strArray[Int.random(in: 0..<strArray.count)]
    }
    
    static func getAvatarIndex() -> Int {
        var avatarIndex = UserDefaults.standard.integer(forKey: "avatarIndex")
        if avatarIndex == 0 {
            avatarIndex = Int.random(in: 0..<avatarImages.count)
            UserDefaults.standard.set(avatarIndex, forKey: "avatarIndex")
            UserDefaults.standard.synchronize()
        }
        return avatarIndex
    }
    
    static func getAvatarRes(_ index: Int) -> UIImage {
        avatarImages[index]
    }
}
