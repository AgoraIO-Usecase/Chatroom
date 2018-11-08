//
//  MainViewController.swift
//  AgoraChatRoom
//
//  Created by CavanSu on 2018/8/15.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import AgoraAudioKit

class MainViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, !identifier.isEmpty, let infos = sender as? [String : Any],
            let role = infos["role"] as? AgoraClientRole, let type = infos["type"] as? RoomType else {
            return
        }
        
        let roomVC = segue.destination as! RoomViewController
        roomVC.role = role
        roomVC.roomType = type
    }
    
    @IBAction func doJoinGamingStandardRoomPressed(_ sender: UIButton) {
        joinRoom(type: .gamingStandard)
    }
    
    @IBAction func doJoinEntertainmentStandardRoomPressed(_ sender: UIButton) {
        joinRoom(type: .entertainmentStandard)
    }
    
    @IBAction func doJoinEntertainmentHighQualityRoomPressed(_ sender: UIButton) {
        joinRoom(type: .entertainmentHighQuality)
    }
    
    @IBAction func doJoinGamingHighQualityRoomPressed(_ sender: UIButton) {
        joinRoom(type: .gamingHighQuality)
    }
}

private extension MainViewController {
    func joinRoom(type: RoomType) {
        let sheet = UIAlertController(title: "选择加入房间的角色", message: nil, preferredStyle: .alert)
        let broadcaster = UIAlertAction(title: "主播", style: .default) { [unowned self] _ in
            self.enterRoom(withRole: .broadcaster, type: type)
        }
        let audience = UIAlertAction(title: "观众", style: .default) { [unowned self] _ in
            self.enterRoom(withRole: .audience, type: type)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        sheet.addAction(broadcaster)
        sheet.addAction(audience)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
    }
    
    func enterRoom(withRole role: AgoraClientRole, type: RoomType) {
        let infos: [String: Any] = ["role": role, "type": type]
        performSegue(withIdentifier: "mainToRoom", sender: infos)
    }
}
