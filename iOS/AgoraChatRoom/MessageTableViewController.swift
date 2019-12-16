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
    private var mChannelData = ChatRoomManager.shared.getChannelData()

    func insertRows(_ position: Int) {
        let indexPath = IndexPath(row: position, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
}

extension MessageTableViewController {
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mChannelData.getMessageArray().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MessageCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

        cell.selectionStyle = .none
        cell.update(mChannelData, indexPath.row)

        return cell
    }
}
