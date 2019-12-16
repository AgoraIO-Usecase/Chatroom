//
//  VoiceEffectViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/27.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

import AgoraAudioKit

enum VoiceBeautify: Int, CaseIterable {
    case DEFAULT = 0
    case THICK = 7
    case LOW
    case ROUND
    case FALSETTO
    case FULL
    case CLEAR
    case RESOUNDING
    case LOUD
    case OPEN_AIR

    func description() -> String {
        switch self {
        case .DEFAULT:
            return "原声"
        case .THICK:
            return "浑厚"
        case .LOW:
            return "低沉"
        case .ROUND:
            return "圆润"
        case .FALSETTO:
            return "假音"
        case .FULL:
            return "饱满"
        case .CLEAR:
            return "清澈"
        case .RESOUNDING:
            return "高亢"
        case .LOUD:
            return "嘹亮"
        case .OPEN_AIR:
            return "空旷"
        }
    }
}

enum VoiceEffect: Int, CaseIterable {
    case DEFAULT = 0
    case KTV
    case LIVE
    case UNCLE
    case GIRL
    case STUDIO
    case POP = 7
    case RNB
    case PHONOGRAPH

    func description() -> String {
        switch self {
        case .DEFAULT:
            return "原声"
        case .KTV:
            return "KTV"
        case .LIVE:
            return "演唱会"
        case .UNCLE:
            return "大叔"
        case .GIRL:
            return "小姐姐"
        case .STUDIO:
            return "录音棚"
        case .POP:
            return "流行"
        case .RNB:
            return "R&B"
        case .PHONOGRAPH:
            return "留声机"
        }
    }
}

class VoiceEffectViewController: UIViewController {
    @IBOutlet weak var gridVoiceEffect: UICollectionView!
    @IBOutlet weak var effect: UIButton!
    @IBOutlet weak var lineEffect: UIView!
    @IBOutlet weak var beautify: UIButton!
    @IBOutlet weak var lineBeautify: UIView!

    private var isEffect = true
    private var mEffectSelectedIndex = 0
    private var mBeautifySelectedIndex = 0

    func showEffect(_ selectedIndex: Int) {
        isEffect = true
        mEffectSelectedIndex = selectedIndex
        gridVoiceEffect.reloadData()
    }

    func showBeautify(_ selectedIndex: Int) {
        isEffect = false
        mBeautifySelectedIndex = selectedIndex
        gridVoiceEffect.reloadData()
    }

    private func resetViews() {
        effect.isSelected = isEffect
        lineEffect.isHidden = !isEffect
        beautify.isSelected = !isEffect
        lineBeautify.isHidden = isEffect
    }

    @IBAction func onEffectClick(_ sender: UIButton) {
        showEffect(mEffectSelectedIndex)
        resetViews()
    }

    @IBAction func onBeautifyClick(_ sender: UIButton) {
        showBeautify(mBeautifySelectedIndex)
        resetViews()
    }
}

extension VoiceEffectViewController: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let position = indexPath.item
        if isEffect {
            let oldPosition = mEffectSelectedIndex
            mEffectSelectedIndex = position
            gridVoiceEffect.reloadItems(at: [IndexPath(item: oldPosition, section: 0), indexPath])

            let type = VoiceEffect.allCases[position].rawValue
            ChatRoomManager.shared.getRtcManager().setReverbPreset(type)
        } else {
            let oldPosition = mBeautifySelectedIndex
            mBeautifySelectedIndex = position
            gridVoiceEffect.reloadItems(at: [IndexPath(item: oldPosition, section: 0), indexPath])

            let type = VoiceBeautify.allCases[position].rawValue
            ChatRoomManager.shared.getRtcManager().setVoiceChanger(type)
        }
    }
}

extension VoiceEffectViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isEffect ? VoiceEffect.allCases.count : VoiceBeautify.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoiceChangerCell", for: indexPath) as! VoiceEffectCell

        cell.update(isEffect, mEffectSelectedIndex, mBeautifySelectedIndex, indexPath.item)

        return cell
    }
}

extension VoiceEffectViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIApplication.shared.windows[0].bounds.size.width
        return CGSize.init(width: Int((width - 19 * 4) / 3), height: 44)
    }
}
