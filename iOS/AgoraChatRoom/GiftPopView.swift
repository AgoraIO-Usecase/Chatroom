//
//  GiftPopView.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/16.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

@IBDesignable
class GiftPopView: UIView {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!

    func show(_ userId: String) {
        let channelData = ChatRoomManager.shared.getChannelData()
        if let member = channelData.getMember(userId) {
            name.text = member.name
        } else {
            name.text = userId
        }
        avatar.image = channelData.getMemberAvatar(userId)
        isHidden = false
        perform(#selector(hide), with: nil, afterDelay: 2.5)
    }

    @objc private func hide() {
        isHidden = true
    }
}
