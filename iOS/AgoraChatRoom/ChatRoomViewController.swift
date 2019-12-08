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
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var num: UIBarButtonItem!
    @IBOutlet weak var inputMsg: UITextField!
    @IBOutlet weak var accents: UIButton!
    @IBOutlet weak var gift: UIImageView!
    
    var mBusinessManager = BussinessManager.sharedInstance
    var mRtmManager = RtmManager.sharedInstance
    var mRtcManager = RtcManager.sharedInstance
    
    var mSeatVC: SeatCollectionViewController?
    var mMessageVC: MessageTableViewController?
    var mMemberVC: MemberViewController?
    
    var bgImg: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        background.image = bgImg
        mBusinessManager.delegate = self
        mRtmManager.addDelegate(self)
        mRtcManager.addDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mRtcManager.leave()
        mRtmManager.leave()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mRtcManager.joinChannel(title!, Constant.sUserId)
    }
    
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
        case "accents":
            if let it = segue.destination as? VoiceChangerTableViewController {
                it.delegate = self
                it.popoverPresentationController?.delegate = self
            }
            break
        default:
            break
        }
    }
    
    private func setButtonState(_ button: UIButton, _ isSelected: Bool) {
        let image = button.image(for: .selected)
        let title = button.attributedTitle(for: .selected)
        if image == nil {
            return
        }
        button.isSelected = isSelected
        if title == nil {
            return
        }
        button.tintColor = isSelected ? #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        setButtonState(sender, !sender.isSelected)
        switch sender.tag {
        case 100:
            let text = inputMsg.text
            if let it = text {
                if it.isEmpty {
                    return
                }
                mBusinessManager.sendMessage(it)
            }
            break
        case 101:
            if sender.isSelected {
                mRtcManager.startAudioMixing()
            } else {
                mRtcManager.stopAudioMixing()
            }
            break
        case 102:
            if sender.isSelected {
                self.performSegue(withIdentifier: "accents", sender: nil)
            } else {
//                mRtcManager.setLocalVoiceChanger(.off)
            }
            break
        case 103:
            mRtcManager.muteLocalAudioStream(!sender.isSelected)
            break
        case 104:
            mRtcManager.muteAllRemoteAudioStreams(!sender.isSelected)
            break
        case 105:
            mBusinessManager.givingGift()
            break
        default:
            break
        }
    }
}

extension ChatRoomViewController: BussinessDelegate {
    // MARK: BussinessDelegate
    
    func onSeatsUpdated(start: Int, count: Int) {
        
    }
    
    func onGiftReceived(userId: String) {
        gift.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.gift.isHidden = true
        }
    }
}

extension ChatRoomViewController: RtmDelegate {
    // MARK: RtmDelegate
    
    func onAttributeArrayUpdated(isInit: Bool) {
        if isInit {
            mBusinessManager.checkAndBeAnchor()
        }
        mBusinessManager.updateSeatArray()
        
        if isInit {
            mBusinessManager.beAnchor()
        }
    }
    
    func onMemberUpdated(userId: String, member: Member?) {
//        num.title = "\(memberArray.count) 人"
//        mMemberVC?.updateMemberArray(memberArray)
    }
    
    func onMessageUpdated() {
//        mMessageVC?.updateMessageArray(messageArray)
    }
    
    func onOrderReceived(message: AgoraRtmMessage) {
        mBusinessManager.processOrder(message)
    }
    
    func onMessageReceived(message: AgoraRtmMessage) {
        mBusinessManager.processMessage(message)
    }
}

extension ChatRoomViewController: RtcDelegate {
    // MARK: RtcDelegate
    
    func onAudioMuteUpdated(userId: String, mute: Bool?) {
//        mSeatVC?.updateAudioStatusMap(audioStatusMap)
//        mMemberVC?.updateAudioStatusMap(audioStatusMap)
    }
    
    func onAudioVolumeUpdated(userId: String, volume: Int?) {
        
    }
}

extension ChatRoomViewController: UIPopoverPresentationControllerDelegate {
    // MARK: UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension ChatRoomViewController: VoiceChangerDelegate {
    // MARK: VoiceChangerDelegate
    
    func onDismiss(isRowSelected: Bool) {
        setButtonState(accents, isRowSelected)        
    }
}
