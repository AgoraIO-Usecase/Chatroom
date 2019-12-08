//
//  MemberViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/26.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {
    @IBOutlet weak var listMember: UITableView!
    
    private var mMemberMap = RtmManager.sharedInstance.mMemberMap
    private var mAudioStatusMap = RtcManager.sharedInstance.mAudioStatusMap
    
    @IBAction func onClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MemberViewController: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mMemberMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell

        let dic = getItem(indexPath.row)
        
        if let it = dic {
            let userId = it.0
            let member = it.1
            cell.update(member) { (userId) -> AudioStatus? in
                return mAudioStatusMap[userId]
            }
            
            cell.changeRole.tag = indexPath.row
            cell.changeRole.addTarget(self, action: #selector(changeRole(_:)), for: .touchUpInside)
            
            cell.muteSeat.tag = indexPath.row
            cell.muteSeat.addTarget(self, action: #selector(muteSeat(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    private func getItem(_ position: Int) -> (String, Member)? {
        for (index, map) in mMemberMap.enumerated() {
            if index == position {
                return map
            }
        }
        return nil
    }
    
    @objc func changeRole(_ sender: UIButton) {
//        BussinessManager.sharedInstance.autoRole(mMemberMap[sender.tag].userId)
    }
    
    @objc func muteSeat(_ sender: UIButton) {
//        BussinessManager.sharedInstance.muteAudio(mMemberMap[sender.tag].userId)
    }
}
