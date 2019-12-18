//
//  ChannelCollectionViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/5.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit
import AgoraRtmKit

class ChannelViewController: UIViewController {
    let mChannelArray: [Channel] = [
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_0"), backgroundRes: #imageLiteral(resourceName: "bg_channel_0"), name: "001"),
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_1"), backgroundRes: #imageLiteral(resourceName: "bg_channel_1"), name: "002"),
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_2"), backgroundRes: #imageLiteral(resourceName: "bg_channel_2"), name: "003"),
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_3"), backgroundRes: #imageLiteral(resourceName: "bg_channel_3"), name: "004"),
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_4"), backgroundRes: #imageLiteral(resourceName: "bg_channel_4"), name: "005"),
    ]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chatRoom":
            let channel = sender as! Channel
            let vc = segue.destination as! ChatRoomViewController
            vc.bgImg = channel.backgroundRes
            vc.title = channel.name
            break;
        default:
            break;
        }
    }
}

extension ChannelViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mChannelArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell

        cell.update(mChannelArray[indexPath.row])

        return cell
    }
}

extension ChannelViewController: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "chatRoom", sender: mChannelArray[indexPath.row])
    }
}
