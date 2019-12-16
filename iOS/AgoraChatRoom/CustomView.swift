//
//  CustomView.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/16.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }

        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue > 0 ? newValue : 0
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}

extension UITextField {
    @IBInspectable var placeholderColor: UIColor {
        get {
            value(forKeyPath: "_placeholderLabel.textColor") as! UIColor
        }
        set {
            setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
    }
}
