//
//  ChatRoomViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/21.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation
import UIKit

import AgoraRtmKit

class ChatRoomViewController: UIViewController {
    @IBOutlet weak var num: UIButton!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mixing: UIButton!
    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var gift: GiftPopView!

    private lazy var mManager: ChatRoomManager = {
        let manager = ChatRoomManager.shared
        manager.delegate = self
        return manager
    }()

    private var mSeatVC: SeatCollectionViewController?
    private var mMessageVC: MessageTableViewController?
    private var mMemberVC: MemberViewController?

    var bgImg: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = bgImg
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mManager.joinChannel(channelId: title!)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mManager.leaveChannel()
    }

    @IBAction func onDidEndOnExit(_ sender: UITextField) {
        if let text = sender.text {
            mManager.sendMessage(text: text)
            sender.text = nil
        }
    }

    @IBAction func onExit(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onClick(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                mManager.getRtcManager().startAudioMixing(Bundle.main.path(forResource: "Sound Horizon - 記憶の水底", ofType: ".mp3"))
            } else {
                mManager.getRtcManager().stopAudioMixing()
            }
        case 103:
            let myUserId = String(Constant.sUserId)
            mManager.muteMic(myUserId, !mManager.getChannelData().isUserMuted(myUserId))
        case 104:
            sender.isSelected = !sender.isSelected
            mManager.getRtcManager().muteAllRemoteAudioStreams(!sender.isSelected)
        case 105:
            mManager.givingGift()
        default:
            break
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "seat":
            mSeatVC = segue.destination as? SeatCollectionViewController
            break
        case "message":
            mMessageVC = segue.destination as? MessageTableViewController
            break
        case "member":
            mMemberVC = segue.destination as? MemberViewController
            mMemberVC?.popoverPresentationController?.delegate = self
            break
        case "changer":
            if let it = segue.destination as? VoiceChangerViewController {
                it.popoverPresentationController?.delegate = self
            }
            break
        default:
            break
        }
    }
}

extension ChatRoomViewController: ChatRoomDelegate {
    // MARK: - ChatRoomDelegate

    func onSeatUpdated(position: Int) {
        mSeatVC?.reloadItems(position)
    }

    func onUserGivingGift(userId: String) {
        gift.show(userId)
    }

    func onMessageAdded(position: Int) {
        mMessageVC?.insertRows(position)
    }

    func onMemberListUpdated(userId: String?) {
        num.setTitle(String(mManager.getChannelData().getMemberArray().count), for: .normal)
        mSeatVC?.reloadItems(userId)
        mMemberVC?.reloadData()
    }

    func onUserStatusChanged(userId: String, muted: Bool?) {
        if Constant.isMyself(userId) {
            if let `muted` = muted {
                mic.isSelected = !muted
            } else {
                mic.isSelected = true
            }
        }
        mSeatVC?.reloadItems(userId)
        mMemberVC?.reloadRowsByUserId(userId)
    }

    func onAudioMixingStateChanged(isPlaying: Bool) {
        mixing.isSelected = isPlaying
    }

    func onAudioVolumeIndication(userId: String, volume: UInt) {

    }
}

extension ChatRoomViewController: UIPopoverPresentationControllerDelegate {
    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .overFullScreen
    }
}
