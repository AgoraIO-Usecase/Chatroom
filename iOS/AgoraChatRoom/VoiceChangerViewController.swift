//
//  VoiceChangerViewController.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/27.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import UIKit

import AgoraRtcKit

class VoiceChangerViewController: UIViewController {
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        dismiss(animated: true)
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

extension VoiceChangerViewController: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let position = indexPath.item
        if isEffect {
            if position == mEffectSelectedIndex {
                return
            }
            let oldPosition = mEffectSelectedIndex
            mEffectSelectedIndex = position
            gridVoiceEffect.reloadItems(at: [IndexPath(item: oldPosition, section: 0), indexPath])

            let type = VoiceEffect.allCases[position].rawValue
            ChatRoomManager.shared.getRtcManager().setReverbPreset(type)
        } else {
            if position == mBeautifySelectedIndex {
                return
            }
            let oldPosition = mBeautifySelectedIndex
            mBeautifySelectedIndex = position
            gridVoiceEffect.reloadItems(at: [IndexPath(item: oldPosition, section: 0), indexPath])

            let type = VoiceBeautify.allCases[position].rawValue
            ChatRoomManager.shared.getRtcManager().setVoiceChanger(type)
        }
    }
}

extension VoiceChangerViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isEffect ? VoiceEffect.allCases.count : VoiceBeautify.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoiceChangerCell", for: indexPath) as! VoiceChangerCell

        cell.update(isEffect, mEffectSelectedIndex, mBeautifySelectedIndex, indexPath.item)

        return cell
    }
}

extension VoiceChangerViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIApplication.shared.windows[0].bounds.size.width
        return CGSize.init(width: Int((width - 19 * 4) / 3), height: 44)
    }
}
