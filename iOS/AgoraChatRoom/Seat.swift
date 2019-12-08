//
//  Seat.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

struct Seat: Codable {
    var userId: String?
    var isClosed: Bool = false
    
    init(userId: String) {
        self.userId = userId
    }
    
    init(isClosed: Bool) {
        self.isClosed = isClosed
    }
}
