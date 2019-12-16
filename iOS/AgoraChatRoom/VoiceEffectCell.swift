//
//  VoiceEffectCell.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/27.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

class VoiceEffectCell: UICollectionViewCell {
    @IBOutlet weak var effect: UIButton!
    
    func update(_ isEffect: Bool, _ effectSelectedIndex: Int, _ beautifySelectedIndex: Int, _ position: Int) {
        var name: String
        var selectedIndex: Int
        if isEffect {
            name = VoiceEffect.allCases[position].description()
            selectedIndex = effectSelectedIndex
        } else {
            name = VoiceBeautify.allCases[position].description()
            selectedIndex = beautifySelectedIndex
        }
        effect.setTitle(name, for: .normal)
        effect.borderColor = position == selectedIndex ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
    }
}
