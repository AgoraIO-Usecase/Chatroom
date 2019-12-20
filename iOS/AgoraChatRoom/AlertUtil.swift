//
//  AlertUtil.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/26.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

struct AlertUtil {
    static func showAlert(_ root: UIViewController, _ text: String) {
        let vc = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        root.present(vc, animated: true, completion: nil)
    }

    static func showMenu(_ root: UIView, _ selectors: [Selector]) {
        root.becomeFirstResponder()
        let menu = UIMenuController.shared
        menu.menuItems = [
            UIMenuItem(title: NSLocalizedString("to_broadcast", comment: ""), action: selectors[0]),
            UIMenuItem(title: NSLocalizedString("to_audience", comment: ""), action: selectors[1]),
            UIMenuItem(title: NSLocalizedString("turn_off_mic", comment: ""), action: selectors[2]),
            UIMenuItem(title: NSLocalizedString("turn_on_mic", comment: ""), action: selectors[3]),
            UIMenuItem(title: NSLocalizedString("close_seat", comment: ""), action: selectors[4]),
            UIMenuItem(title: NSLocalizedString("open_seat", comment: ""), action: selectors[5])
        ]
        menu.arrowDirection = .up
        menu.setTargetRect(root.frame, in: root.superview!)
        menu.setMenuVisible(true, animated: true)
    }
}
