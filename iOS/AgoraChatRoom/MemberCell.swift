//
//  MemberCell.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/26.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var ivMute: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var role: UIButton!
    @IBOutlet weak var btnMute: UIButton!

    func update(_ channelData: ChannelData, _ position: Int) {
        let member = channelData.getMemberArray()[position]
        let userId = member.userId

        self.avatar.image = channelData.getMemberAvatar(userId)

        if channelData.isUserOnline(userId) {
            let muted = channelData.isUserMuted(userId)
            self.ivMute.isHidden = false
            self.ivMute.image = muted ? #imageLiteral(resourceName: "ic_mic_off_little") : #imageLiteral(resourceName: "ic_mic_on_little")
            self.role.setTitle(NSLocalizedString("to_audience", comment: ""), for: .normal)
            self.btnMute.isHidden = false
            self.btnMute.setTitle(muted ? NSLocalizedString("turn_on_mic", comment: "") : NSLocalizedString("turn_off_mic", comment: ""), for: .normal)
        } else {
            self.ivMute.isHidden = true
            self.role.setTitle(NSLocalizedString("to_broadcast", comment: ""), for: .normal)
            self.btnMute.isHidden = true
        }

        if !channelData.isAnchorMyself() {
            self.role.isHidden = true
            self.btnMute.isHidden = true
        }

        var name = member.name
        if channelData.isAnchor(userId) {
            name = "\(name ?? userId)\(NSLocalizedString("anchor", comment: ""))"
        }
        self.name.text = name
    }
}
