//
//  MemberCell.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/26.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    @IBOutlet weak var header: UIImageView!
    @IBOutlet weak var mute: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var changeRole: UIButton!
    @IBOutlet weak var muteSeat: UIButton!
    
    func update(_ member: Member, block: (_ userId: String) -> AudioStatus?) {
//        let userId = member.userId
        
//        if let it = block(userId) {
//            mute.isHidden = !(it.mute ?? false)
//            changeRole.setTitle("下麦", for: .normal)
//            muteSeat.isHidden = false
//        } else {
//            mute.isHidden = true
//            changeRole.setTitle("上麦", for: .normal)
//            muteSeat.isHidden = true
//        }
//        name.text = userId
//        name.textColor = BaseUtils.isMyself(userId) ? UIColor.black : UIColor.gray
    }
}
