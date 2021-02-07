//
//  AppDelegate.swift
//  AgoraChatRoom
//
//  Created by CavanSu on 2018/8/15.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RtcManager.shared.initialize()
        RtmManager.shared.initialize()
        do {
            try LCApplication.default.set(
                id: KeyCenter.LeanCloudAppId,
                key: KeyCenter.LeanCloudAppKey,
                serverURL: KeyCenter.LeanCloudServerUrl)
        } catch {
            print(error)
        }
        return true
    }
}
