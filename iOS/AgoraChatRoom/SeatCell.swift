//
//  SeatCell.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class SeatCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var seat: UIImageView!
    @IBOutlet weak var mute: UIImageView!
    
    private var frameSize: CGFloat = 0
    private var size: CGFloat = 0
    private var x: CGFloat = 0
    private var y: CGFloat = 0
    
    override func prepareForReuse() {
        frameSize = self.frame.size.width
        size = frameSize / 2
        x = (frameSize - size) / 2
        y = frameSize - size
    }
    
    func update(_ value: Seat?, block: (_ userId: String) -> AudioStatus?) {
        if let it = value {
            let userId = it.userId
            
            if it.isClosed {
                seat.image = #imageLiteral(resourceName: "ic_ban")
            } else {
                if BaseUtils.isMyself(userId) {
                    seat.image = #imageLiteral(resourceName: "img_header_1")
                } else {
                    seat.image = #imageLiteral(resourceName: "img_header_5")
                }
            }
            
//            if BaseUtils.isAnchor(userId) {
//                size = frameSize
//                x = 0
//                y = 0
//            }
            
            if userId != nil {
                if let it = block(userId!) {
                    mute.isHidden = !it.mute
                } else {
                    mute.isHidden = true
                }
            }
        } else {
            seat.image = #imageLiteral(resourceName: "ic_join")
            mute.isHidden = true
        }
        
//        container.frame = CGRect(x: x, y: y,width: size, height: size)
    }
}
