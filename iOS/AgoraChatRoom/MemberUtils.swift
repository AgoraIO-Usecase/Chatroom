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
    static let headerImages: [UIImage] = [#imageLiteral(resourceName: "img_header_0"), #imageLiteral(resourceName: "img_header_1"), #imageLiteral(resourceName: "img_header_2"), #imageLiteral(resourceName: "img_header_3"), #imageLiteral(resourceName: "img_header_4"), #imageLiteral(resourceName: "img_header_5"), #imageLiteral(resourceName: "img_header_6"), #imageLiteral(resourceName: "img_header_7"), #imageLiteral(resourceName: "img_header_8"), #imageLiteral(resourceName: "img_header_9"), #imageLiteral(resourceName: "img_header_10"), #imageLiteral(resourceName: "img_header_11")]
    
    static func getName() -> String {
        return "\(randonName(surNames)) \(randonName(names))"
    }
    
    private static func randonName(_ strArray: [String]) -> String {
        return strArray[Int.random(in: 0..<strArray.count)]
    }
    
    static func getHeaderIndex() -> Int {
        return Int.random(in: 0..<headerImages.count)
    }
    
    static func getHeaderRes(member: Member?) -> UIImage {
        if member == nil {
            return #imageLiteral(resourceName: "ic_unkown")
        }
        return headerImages[member!.headerIndex]
    }
}
