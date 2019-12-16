//
//  ChannelCell.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/5.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class ChannelCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func update(_ channel: Channel) {
        self.image.image = channel.drawableRes
        self.name.text = channel.name
    }
}
