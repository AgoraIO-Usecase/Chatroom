//
// Created by LXH on 2019/12/11.
// Copyright (c) 2019 CavanSu. All rights reserved.
//

import Foundation

import AgoraRtmKit

protocol MessageManager {
    func sendOrder(userId: String, orderType: String, content: String?, callback: AgoraRtmSendPeerMessageBlock?)

    func sendMessage(text: String)

    func processMessage(rtmMessage: AgoraRtmMessage)

    func addMessage(message: Message)
}
