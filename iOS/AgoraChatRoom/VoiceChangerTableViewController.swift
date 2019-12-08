//
//  VoiceChangerTableViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/27.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

import AgoraAudioKit

enum VoiceChanger: Int, CaseIterable {
    case OldMan = 0
    case BabyBoy
    case BabyGirl
    case ZhuBaJie
    case Ethereal
    case Hulk
}

extension VoiceChanger {
    func description() -> String {
        switch self {
        case .OldMan:
            return "老人"
        case .BabyBoy:
            return "正太"
        case .BabyGirl:
            return "萝莉"
        case .ZhuBaJie:
            return "猪八戒"
        case .Ethereal:
            return "空灵"
        case .Hulk:
            return "浩克"
        }
    }
}

class VoiceChangerTableViewController: UITableViewController {
    var delegate: VoiceChangerDelegate?
    private var isRowSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onDismiss(isRowSelected: isRowSelected)
    }
}

extension VoiceChangerTableViewController {
    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let changer = AgoraAudioVoiceChanger.init(rawValue: indexPath.row + 1)
        if let it = changer {
            isRowSelected = true
//            RtcManager.sharedInstance.setLocalVoiceChanger(it)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension VoiceChangerTableViewController {
    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VoiceChanger.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceChangerCell", for: indexPath) as! VoiceChangerCell

        cell.name.text = VoiceChanger.init(rawValue: indexPath.row)?.description()

        return cell
    }
}

protocol VoiceChangerDelegate {
    func onDismiss(isRowSelected: Bool)
}
