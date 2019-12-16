//
//  AlertUtils.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/26.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class AlertUtils: NSObject {
    static func showAlert(_ root: UIViewController, _ text: String) {
        let vc = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        root.present(vc, animated: true, completion: nil)
    }
    
    static func showMenu(_ root: UIView, _ selectors: [Selector]) {
        root.becomeFirstResponder()
        let menu = UIMenuController.shared
        menu.menuItems = [
            UIMenuItem(title: "上麦", action: selectors[0]),
            UIMenuItem(title: "下麦", action: selectors[1]),
            UIMenuItem(title: "禁麦", action: selectors[2]),
            UIMenuItem(title: "解麦", action: selectors[3]),
            UIMenuItem(title: "封麦", action: selectors[4]),
            UIMenuItem(title: "解封", action: selectors[5])
        ]
        menu.arrowDirection = .up
        menu.setTargetRect(root.frame, in: root.superview!)
        menu.setMenuVisible(true, animated: true)
    }
}
