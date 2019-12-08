//
//  MessageCell.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var header: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    func update(_ value: Message) {
        header.image = BaseUtils.isMyself(value.sendId) ? #imageLiteral(resourceName: "img_header_8") : #imageLiteral(resourceName: "img_header_2")
        message.text = value.content
    }
}
