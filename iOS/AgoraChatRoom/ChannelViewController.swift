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
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_0"), backgroudRes: #imageLiteral(resourceName: "bg_channel_0"), name: "001"),
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_1"), backgroudRes: #imageLiteral(resourceName: "bg_channel_1"), name: "002"),
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_2"), backgroudRes: #imageLiteral(resourceName: "bg_channel_2"), name: "003"),
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_3"), backgroudRes: #imageLiteral(resourceName: "bg_channel_3"), name: "004"),
        Channel(drawableRes: #imageLiteral(resourceName: "img_channel_4"), backgroudRes: #imageLiteral(resourceName: "bg_channel_4"), name: "005"),
    ]
    
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RtmManager.sharedInstance.addDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RtmManager.sharedInstance.removeDelegate(self)
    }
    
    private func login() {
        RtmManager.sharedInstance.login(userId: Constant.sUserId) { (code) in
            if code == .ok {
                self.isLogin = true
                BussinessManager.sharedInstance.initUserInfo()
            } else {
                self.isLogin = false
                // TODO
            }
        }
    }
    
    private func join(_ channel: Channel) {
        if isLogin {
            RtmManager.sharedInstance.joinChannel(channelId: channel.name) { (code) in
                if code == .channelErrorOk {
                    self.performSegue(withIdentifier: "chatRoom", sender: channel)
                }
            }
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chatRoom":
            let channel = sender as! Channel
            let vc = segue.destination as! ChatRoomViewController
            vc.bgImg = channel.backgroudRes
            vc.title = channel.name
            break;
        default:
            break;
        }
    }
    
}

extension ChannelViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return mChannelArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
    
        // Configure the cell
        let channel = mChannelArray[indexPath.row]
        cell.image.image = channel.drawableRes
        cell.name.text = channel.name
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        join(mChannelArray[indexPath.row])
    }
}

extension ChannelViewController: RtmDelegate {
    func onAttributeArrayUpdated(isInit: Bool) {
        BussinessManager.sharedInstance.updateSeatArray()
        if isInit {
            BussinessManager.sharedInstance.checkAndBeAnchor()
        }
    }
    
    func onMemberUpdated(userId: String, member: Member?) {
        
    }
    
    func onMessageUpdated() {
        
    }
    
    func onOrderReceived(message: AgoraRtmMessage) {
        
    }
    
    func onMessageReceived(message: AgoraRtmMessage) {
        
    }
}
