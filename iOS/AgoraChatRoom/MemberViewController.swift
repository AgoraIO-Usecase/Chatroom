//
//  MemberViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/26.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var listMember: UITableView!

    private var mChannelData = ChatRoomManager.shared.getChannelData()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTitle()
    }

    func refreshTitle() {
        num.text = "\(NSLocalizedString("channel_member_list", comment: ""))（\(mChannelData.getMemberArray().count)\(NSLocalizedString("people", comment: ""))）"
    }

    func reloadData() {
        refreshTitle()
        listMember.reloadData()
    }

    func reloadRowsByUserId(_ userId: String) {
        let index = mChannelData.indexOfMemberArray(userId)
        if index != NSNotFound {
            listMember.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }

    @IBAction func onClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MemberViewController: UITableViewDataSource {
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mChannelData.getMemberArray().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell

        cell.selectionStyle = .none
        cell.update(mChannelData, indexPath.row)
        cell.role.tag = indexPath.row
        cell.role.addTarget(self, action: #selector(role(_:)), for: .touchUpInside)
        cell.btnMute.tag = indexPath.row
        cell.btnMute.addTarget(self, action: #selector(mute(_:)), for: .touchUpInside)

        return cell
    }

    @objc private func role(_ sender: UIButton) {
        let userId = mChannelData.getMemberArray()[sender.tag].userId
        if mChannelData.isUserOnline(userId) {
            ChatRoomManager.shared.toAudience(userId, nil)
        } else {
            ChatRoomManager.shared.toBroadcaster(userId, mChannelData.firstIndexOfEmptySeat())
        }
    }

    @objc private func mute(_ sender: UIButton) {
        let userId = mChannelData.getMemberArray()[sender.tag].userId
        ChatRoomManager.shared.muteMic(userId, !mChannelData.isUserMuted(userId))
    }
}
