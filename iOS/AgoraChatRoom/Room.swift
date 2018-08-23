//
//  Room.swift
//  AgoraChatRoom
//
//  Created by CavanSu on 2018/8/15.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

enum RoomType: Int {
    // 开黑聊天室，娱乐聊天室，K 歌房，FM 超高音质
    case gamingStandard, entertainmentStandard, entertainmentHighQuality, gamingHighQuality
    
    func description() -> String {
        switch self {
        case .gamingStandard:
            return "ChatRoomGamingStandard"
        case .entertainmentStandard:
            return "ChatRoomEntertainmentStandard"
        case .entertainmentHighQuality:
            return "ChatRoomEntertainmentHighQuality"
        case .gamingHighQuality:
            return "ChatRoomGamingHighQuality"
        }
    }
    
    
}

struct Room {
    static func channelId(roomType: RoomType) -> String {
        switch roomType {
        case .gamingStandard:
            return "ChatRoomGamingStandard"
        case .entertainmentStandard:
            return "ChatRoomEntertainmentStandard"
        case .entertainmentHighQuality:
            return "ChatRoomEntertainmentHighQuality"
        case .gamingHighQuality:
            return "ChatRoomGamingHighQuality"
        }
    }
    
    static func title(roomType: RoomType) -> String {
        switch roomType {
        case .gamingStandard:
            return "开黑聊天室"
        case .entertainmentStandard:
            return "娱乐房间"
        case .entertainmentHighQuality:
            return "K 歌房"
        case .gamingHighQuality:
            return "FM 超高音质房间"
        }
    }
}
