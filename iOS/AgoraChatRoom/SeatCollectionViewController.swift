//
//  SeatCollectionViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class SeatCollectionViewController: UICollectionViewController {
    private var mChannelData = ChatRoomManager.shared.getChannelData()

    func reloadItems(_ position: Int) {
        collectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
    }

    func reloadItems(_ userId: String?) {
        if let `userId` = userId {
            let index = mChannelData.indexOfSeatArray(userId)
            if index != NSNotFound {
                collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
}

extension SeatCollectionViewController {
    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mChannelData.getSeatArray().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> SeatCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! SeatCell

        cell.update(mChannelData, indexPath.item)
        cell.seat.layoutIfNeeded()
        cell.seat.cornerRadius = cell.seat.frame.size.height / 2

        return cell
    }
}

extension SeatCollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIApplication.shared.windows[0].bounds.size.width
        let size = Int((width - 10 * 2 * 5) / 5)
        return CGSize.init(width: size, height: size)
    }
}
