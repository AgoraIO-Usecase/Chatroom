//
//  AudioStatus.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

struct AudioStatus {
    var volume = 0
    var mute = false
    
    init(volume: Int) {
        self.volume = volume
    }
    
    init(mute: Bool) {
        self.mute = mute
    }
}
