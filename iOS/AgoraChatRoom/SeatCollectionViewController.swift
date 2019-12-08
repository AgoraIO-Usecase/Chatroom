//
//  SeatCollectionViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class SeatCollectionViewController: UICollectionViewController {
    private var mSeatArray = BussinessManager.sharedInstance.mSeatArray
    private var mAudioStatusMap = RtcManager.sharedInstance.mAudioStatusMap
}

extension SeatCollectionViewController {
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mSeatArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> SeatCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! SeatCell
        
        let seat = mSeatArray[indexPath.row]
        cell.update(seat) { (userId) -> AudioStatus? in
            return mAudioStatusMap[userId]
        }
        
        return cell
    }
}

extension SeatCollectionViewController {
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let position = indexPath.row
        let seat = mSeatArray[position]
        if let it = seat {
            if it.isClosed {
                BussinessManager.sharedInstance.openSeat(position)
            } else {
                if BaseUtils.isMyself(it.userId) {
                    BussinessManager.sharedInstance.toAudience(position)
                } else {
                    if BaseUtils.isAnchorMyself() {
                        AlertUtils.showMenu(root: self, position: position)
                    }
                }
            }
        } else {
            BussinessManager.sharedInstance.toBroadcaster(String(Constant.sUserId), position)
        }
    }
}

extension SeatCollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDelegateFlowLayout
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = UIApplication.shared.windows[0].bounds.size.width
//        let size = Int((width - 10 * 4) / 5)
//        return CGSize.init(width: size, height: size)
//    }
}
