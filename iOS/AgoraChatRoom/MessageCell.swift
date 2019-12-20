//
//  MessageCell.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var message: UILabel!

    func update(_ channelData: ChannelData, _ position: Int) {
        let message = channelData.getMessageArray()[position]
        let userId = message.sendId

        avatar.image = channelData.getMemberAvatar(userId)

        switch message.messageType {
        case Message.MESSAGE_TYPE_TEXT:
            self.message.isHidden = false
            if let member = channelData.getMember(userId), let name = member.name {
                self.message.text = "\(name)：\(message.content!)"
            } else {
                self.message.text = "\(userId)：\(message.content!)"
            }
        case Message.MESSAGE_TYPE_IMAGE:
            // TODO
            break
        default:
            break
        }
    }
}
