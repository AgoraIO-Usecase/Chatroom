//
//  RoomViewController.swift
//  AgoraChatRoom
//
//  Created by CavanSu on 2018/8/15.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import AgoraAudioKit

class RoomViewController: UIViewController {
    @IBOutlet weak var roomTitleLabel: UILabel!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var muteLocalButton: UIButton!
    @IBOutlet weak var audioMixingButton: UIButton!
    @IBOutlet weak var voiceChangerButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    // uid 在 didJoinChannel 回调中进行赋值，值来自服务器生成的唯一随机数。这个随机数用 uid 记录
    var uid: UInt!
   
    // 记录选中的变声角色
    var selectedCharater: EffectCharacters?
    
    var roomType: RoomType!
    var agoraKit: AgoraRtcEngineKit!
    var role: AgoraClientRole! {
        didSet {
            // oldValue !=nil, 当是第一次在 MainVC 设置 role时，还未加入频道，所以往下的不执行
            // 应该是不会出现oldRole 与 newRole 相同，这里只是做一个预防。
            // 相同时，也要保证 uid 有值，确定已经 joinChannel 成功，否则直接return不执行
            guard oldValue != nil, oldValue != role, let _ = uid else {
                return
            }
            
            // 从观众变为主播
            if oldValue == .audience, role == .broadcaster {
                // 需要将自己添加到用户列表
                users.addCurrentUser(uid: uid)
            }
            
            // 从主播变为观众
            if oldValue == .broadcaster, role == .audience {
                // 如果在播放伴奏，伴奏需要停止（在 audioMixingIsPlaying 中的 didSet 判断是否在播放伴奏）
                audioMixingIsPlaying = false
                
                // 如果有设置变声角色，需要将变声置回默认
                setDefaultVoiceEffect()
                
                // 将自己从用户列表中删除
                users.removeUser(uid: uid)
            }
            
            usersTableView.reloadData()
        }
    }
    var users = Users()
    
    var audioMixingIsPlaying: Bool = false {
        didSet {
            // 如果当前值与原来值相同, 直接 return 不执行往下的方法
            guard audioMixingIsPlaying != oldValue else {
                return
            }
            
            if audioMixingIsPlaying {
                let musicPath = Bundle.main.path(forResource: "Sound Horizon - 記憶の水底", ofType: ".mp3")
                // 开始播放伴奏
                agoraKit.startAudioMixing(musicPath!, loopback: false, replace: false, cycle: 1)
                // 调整伴奏的音量，防止伴奏声音过大，影响人声
                agoraKit.adjustAudioMixingVolume(15)
            } else {
                // 停止播放伴奏
                agoraKit.stopAudioMixing()
            }
            
            // 判断 audioMixingButton 的 selected 状态是否与 audioMixingIsPlaying 一直，不一致则设为一致
            if audioMixingIsPlaying != audioMixingButton.isSelected {
                audioMixingButton.isSelected = audioMixingIsPlaying
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        loadAgoraKit()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, identifier.count != 0 else {
            return
        }
        
        let charactersVC = segue.destination as! CharactersViewController
        charactersVC.selectedCharacter = selectedCharater
        charactersVC.delegate = self
        setPopoverDelegate(of: charactersVC, sender: voiceChangerButton)
    }
    
    func loadAgoraKit() {
        // 初始化AgoraRtcEngineKit
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppId.appId(), delegate: self)
        // 设置频道属性为直播模式
        agoraKit.setChannelProfile(.liveBroadcasting)
        // 设置频道角色
        agoraKit.setClientRole(role)
        // 启动音量监听
        agoraKit.enableAudioVolumeIndication(1000, smooth: 3)
        
        // 根据房间类型设置 audioProfile
        switch roomType {
        case .gamingStandard:
            // 开黑聊天室
            agoraKit.setAudioProfile(.speechStandard, scenario: .chatRoomGaming)
        case .entertainmentStandard:
            // 娱乐聊天室
            agoraKit.setAudioProfile(.musicStandard, scenario: .chatRoomEntertainment)
        case .entertainmentHighQuality:
            // K 歌房
            agoraKit.setAudioProfile(.musicHighQuality, scenario: .chatRoomEntertainment)
        case .gamingHighQuality:
            // FM 超高音质
            agoraKit.setAudioProfile(.musicHighQuality, scenario: .gameStreaming)
            
            // 特殊情况：如果是 FM 超高音质房间，默认会有特定的声音效果
            setDefaultVoiceEffect()
        default:
            break
        }
        
        // 加入房间对应的频道
        let channelId = Room.channelId(roomType: roomType)
        // 当 joinChannel api 中填入 0 时，agora 服务器会生成一个唯一的随机数，并在 didJoinChannel 回调中返回
        agoraKit.joinChannel(byToken: nil, channelId: channelId, info: nil, uid: 0, joinSuccess: nil)
    }
    
    @IBAction func doLinkPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let clientRole: AgoraClientRole = sender.isSelected == true ? .broadcaster : .audience
        // 通过role值的改变，来实现上下麦
        agoraKit.setClientRole(clientRole)
    }
    
    @IBAction func doSpeakerPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let isSpeaker = sender.isSelected
        // 扬声器或听筒的切换
        agoraKit.setEnableSpeakerphone(isSpeaker)
    }
    
    @IBAction func doMuteLocalPressed(_ sender: UIButton) {
        // 通过 uid 是否有值来判断，加入频道是否成功
        guard let _ = uid else {
            return
        }
        
        sender.isSelected = !sender.isSelected
        let mute = sender.isSelected
        users.updateUserIsMuted(uid: uid, muted: mute)
        usersTableView.reloadData()
        // 开始或者停止发送音频流
        agoraKit.muteLocalAudioStream(mute)
    }
    
    @IBAction func doMuteAllRemotePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let mute = sender.isSelected
        // 开始或者停止播放音频流
        agoraKit.muteAllRemoteAudioStreams(mute)
    }
    
    @IBAction func doStartAudioMixingPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // 在 audioMixingIsPlaying 中的 didSet 执行开始或者停止播放伴奏
        audioMixingIsPlaying = sender.isSelected
    }
    
    @IBAction func doExitPressed(_ sender: UIButton) {
        // 退出当前频道
        agoraKit.leaveChannel(nil)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: AgoraRtcEngineKit voice effect
private extension RoomViewController {
    // 根据选中的角色进行声音效果的改变 或者取消声音效果的改变, 设回默认的声音效果

    // 设为选中角色的声音效果
    func setCharactorVoiceEffect(withCharacter character: EffectCharacters) {
        selectedCharater = character
        voiceChangerButton.isSelected = true
        voiceChangerButton.setTitle(character.description(), for: .selected)
        
        VoiceEffect.character(agoraKit: agoraKit, character: character)
    }
    
    // 将声音效果设回默认
    func setDefaultVoiceEffect() {
        guard let _ = selectedCharater else {
            return
        }
        
        selectedCharater = nil
        voiceChangerButton.isSelected = false
        
        if roomType == .gamingHighQuality {
            // 特殊情况：如果是 FM 超高音质房间，默认会有特定的声音效果
            VoiceEffect.fm(agoraKit: agoraKit)
        } else {
            // 其他房间则为普通声音
            VoiceEffect.common(agoraKit: agoraKit)
        }
    }
}

extension RoomViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        // didJoinChannel 回调中，uid 不会为0
        // 当 joinChannel api 中填入 0 时，agora 服务器会生成一个唯一的随机数，并在 didJoinChannel 回调中返回
        self.uid = uid
        // 进入频道后，且当自己是主播时，将自己加入用户列表
        if role == .broadcaster {
            users.addCurrentUser(uid: uid)
            usersTableView.reloadData()
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // 当有用户加入频道时，将他加入到用户列表中
        users.addUser(uid: uid)
        usersTableView.reloadData()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        // 当有用户离开频道时，将他从用户列表中移除
        users.removeUser(uid: uid)
        usersTableView.reloadData()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        // 收到用户静音状态后，更新用户的静音状态
        users.updateUserIsMuted(uid: uid, muted: muted)
        usersTableView.reloadData()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        for speaker in speakers {
            var speakerUid: UInt!
            if speaker.uid == 0 {
                // 当 speaker.uid == 0 时，为当前用户
                // 判断为当前用户后，去用户列表中查找 uid(当前用户) 进行音量值的更新
                speakerUid = uid
            } else {
                // 否则更新频道内其他用户的音量值
                speakerUid = speaker.uid
            }
            users.updateUserVolume(uid: speakerUid, volume: speaker.volume)
        }
        usersTableView.reloadData()
    }
    
    func rtcEngineLocalAudioMixingDidFinish(_ engine: AgoraRtcEngineKit) {
        // 当伴奏播放结束时，将 audioMixingButton 置为未选中状态
        audioMixingButton.isSelected = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole) {
        // 当前用户发生角色变化时，需要进行用户列表，以及可能还有伴奏、变声的处理
        role = newRole
        
        // 当是主播的时候，一些功能按钮能够点击；当是观众时，一些功能按钮不能点击
        updateButtonsIsUserInteractionEnabled(withRole: newRole)
    }
}

private extension RoomViewController {
    func updateViews() {
        roomTitleLabel.text = Room.title(roomType: roomType)
        linkButton.isSelected = role == .broadcaster ? true : false
        speakerButton.isSelected = true
        updateButtonsIsUserInteractionEnabled(withRole: role)
    }
    
    func updateButtonsIsUserInteractionEnabled(withRole role: AgoraClientRole) {
        let isEnabled = role == .broadcaster ? true : false
        muteLocalButton.isEnabled = isEnabled
        audioMixingButton.isEnabled = isEnabled
        voiceChangerButton.isEnabled = isEnabled
    }
    
    func setPopoverDelegate(of vc: UIViewController, sender: UIButton) {
        vc.popoverPresentationController?.delegate = self
        vc.popoverPresentationController?.sourceRect = CGRect(x: sender.bounds.size.width * 0.5, y: 0, width: 0, height: 0)
    }
}

extension RoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users.list[indexPath.row]
        cell.mutedLabel.isHidden = !user.muted
        cell.uidLabel.text = "uid: \(user.uid!)"
        cell.volumeLabel.text = "volume: \(user.volume)"
        cell.headImageView.image = user.headImage
        return cell
    }
}

extension RoomViewController: CharactersVCDelegate {
    func charactersVC(vc: CharactersViewController, didSelectedCharacter character: EffectCharacters) {
        // 当 charatorsVC 选中的角色时，将声音效果设置为该角色
        setCharactorVoiceEffect(withCharacter: character)
    }
    
    func charactersVCDidCancelSelectedRole(vc: CharactersViewController) {
        // 当 charatorsVC 取消选中的角色时，将声音效果置回默认
        setDefaultVoiceEffect()
    }
}

extension RoomViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
