//
//  User.swift
//  AgoraChatRoom
//
//  Created by CavanSu on 2018/8/15.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class Users: NSObject {
    var list = [UserInfo]()
    
    func addCurrentUser(uid: UInt) {
        let user = UserInfo()
        user.uid = uid
        user.headImage = #imageLiteral(resourceName: "current")
        list.insert(user, at: 0)
    }
    
    func addUser(uid: UInt) {
        let user = UserInfo()
        user.uid = uid
        user.headImage = #imageLiteral(resourceName: "other")
        list.append(user)
    }
    
    func removeUser(uid: UInt) {
        guard let index = getIndexOfUserList(uid: uid) else {
            return
        }
        list.remove(at: index)
    }
    
    func updateUserVolume(uid: UInt, volume: UInt) {
        guard let index = getIndexOfUserList(uid: uid) else {
            return
        }
        let user = list[index]
        user.volume = volume
    }
    
    func updateUserIsMuted(uid: UInt, muted: Bool) {
        guard let index = getIndexOfUserList(uid: uid) else {
            return
        }
        let user = list[index]
        user.muted = muted
    }
    
    func removeAllUser() {
        list.removeAll()
    }
}

private extension Users {
    func getIndexOfUserList(uid: UInt) -> Int? {
        for (index, user) in list.enumerated() {
            if user.uid == uid {
                return index
            }
        }
        return nil
    }
}

class UserInfo: NSObject {
    var uid: UInt!
    var volume: UInt = 0
    var muted: Bool = false
    var headImage: UIImage!
}
