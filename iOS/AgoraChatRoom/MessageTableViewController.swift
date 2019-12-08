//
//  MessageTableViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/22.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit
import AgoraRtmKit

class MessageTableViewController: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RtmManager.sharedInstance.addDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RtmManager.sharedInstance.removeDelegate(self)
    }
    
    func reloadData() {
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: RtmManager.sharedInstance.mMessageArray.count - 1, section: 0), at: .bottom, animated: false)
    }
}

extension MessageTableViewController {
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RtmManager.sharedInstance.mMessageArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MessageCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

        let message = RtmManager.sharedInstance.mMessageArray[indexPath.row]
        cell.update(message)

        return cell
    }
}

extension MessageTableViewController: RtmDelegate {
    // MARK: RtmDelegate
    
    func onAttributeArrayUpdated(isInit: Bool) {
        
    }
    
    func onMemberUpdated(userId: String, member: Member?) {
        
    }
    
    func onMessageUpdated() {
        reloadData()
    }
    
    func onOrderReceived(message: AgoraRtmMessage) {
        
    }
    
    func onMessageReceived(message: AgoraRtmMessage) {
        
    }
}
