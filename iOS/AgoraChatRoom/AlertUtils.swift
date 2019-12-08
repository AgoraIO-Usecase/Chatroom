//
//  AlertUtils.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/26.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class AlertUtils: NSObject {
    static func showAlert(root: UIViewController, text: String) {
        let vc = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        root.present(vc, animated: true, completion: nil)
    }
    
    static func showMenu(root: UIViewController, position: Int) {
        let vc = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "下麦", style: .default, handler: { (action) in
            BussinessManager.sharedInstance.toAudience(position)
        }))
        vc.addAction(UIAlertAction(title: "禁麦", style: .default, handler: { (action) in
            BussinessManager.sharedInstance.switchMute(position)
        }))
        vc.addAction(UIAlertAction(title: "封麦", style: .default, handler: { (action) in
            BussinessManager.sharedInstance.closeSeat(position)
        }))
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        root.present(vc, animated: true, completion: nil)
    }
}
