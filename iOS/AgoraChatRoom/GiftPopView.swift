//
//  GiftPopView.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/16.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

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
        groupAnimation()
        perform(#selector(hide), with: nil, afterDelay: 2.5)
    }

    func groupAnimation() {
        let animation = CAAnimationGroup()
        animation.animations = [positionAnimation(), opacityAnimation()]
        animation.duration = 1
        layer.add(animation, forKey: "groupAnimation")
    }

    func positionAnimation() -> CABasicAnimation {
        let size = UIApplication.shared.windows[0].bounds.size
        let animation = CABasicAnimation.init(keyPath: "position")
        animation.fromValue = CGPoint.init(x: size.width / 2, y: size.height / 2 + self.frame.size.height)
        animation.toValue = CGPoint.init(x: size.width / 2, y: size.height / 2)
        return animation
    }

    func opacityAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = NSNumber.init(value: 0)
        animation.toValue = NSNumber.init(value: 1)
        return animation
    }

    @objc private func hide() {
        isHidden = true
    }
}
