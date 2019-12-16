//
//  RtcManager.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

import AgoraAudioKit

protocol RtcDelegate: class {
    func onJoinChannelSuccess(channelId: String)

    func onUserOnlineStateChanged(uid: UInt, isOnline: Bool)

    func onUserMuteAudio(uid: UInt, muted: Bool)

    func onAudioMixingStateChanged(isPlaying: Bool)

    func onAudioVolumeIndication(uid: UInt, volume: UInt)
}

class RtcManager: NSObject {
    static let shared = RtcManager()

    weak var delegate: RtcDelegate?
    private var mRtcEngine: AgoraRtcEngineKit?
    private var mUserId: UInt = 0

    private override init() {
        super.init()
    }

    func initialize() {
        if mRtcEngine == nil {
            mRtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: Constant.sAppId, delegate: self)
        }
        if let `mRtcEngine` = mRtcEngine {
            mRtcEngine.setChannelProfile(.liveBroadcasting)
            mRtcEngine.setAudioProfile(.musicHighQuality, scenario: .chatRoomEntertainment)
            mRtcEngine.enableAudioVolumeIndication(500, smooth: 3, report_vad: false)
        }
    }

    func joinChannel(_ channelId: String, _ userId: UInt) {
        mRtcEngine?.joinChannel(byToken: nil, channelId: channelId, info: nil, uid: userId, joinSuccess: { [weak self] (channel, uid, elapsed) in
            print("rtc join success \(channel) \(uid)")

            guard let `self` = self else {
                return
            }
            self.mUserId = uid
            self.delegate?.onJoinChannelSuccess(channelId: channelId)
        })
    }

    func setClientRole(_ role: AgoraClientRole) {
        mRtcEngine?.setClientRole(role)
    }

    func muteAllRemoteAudioStreams(_ muted: Bool) {
        mRtcEngine?.muteAllRemoteAudioStreams(muted)
    }

    func muteLocalAudioStream(_ muted: Bool) {
        mRtcEngine?.muteLocalAudioStream(muted)
        delegate?.onUserMuteAudio(uid: mUserId, muted: muted)
    }

    func startAudioMixing(_ filePath: String?) {
        if let `mRtcEngine` = mRtcEngine, let `filePath` = filePath {
            mRtcEngine.startAudioMixing(filePath, loopback: false, replace: false, cycle: 1)
            mRtcEngine.adjustAudioMixingVolume(15)
        }
    }

    func stopAudioMixing() {
        mRtcEngine?.stopAudioMixing()
    }

    func setVoiceChanger(_ type: Int) {
        mRtcEngine?.setParameters("{\"che.audio.morph.voice_changer\": \(type)}")
    }

    func setReverbPreset(_ type: Int) {
        mRtcEngine?.setParameters("{\"che.audio.morph.reverb_preset\": \(type)}")
    }

    func leaveChannel() {
        mRtcEngine?.leaveChannel(nil)
        setClientRole(.audience)
    }
}

extension RtcManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole) {
        print("didClientRoleChanged \(oldRole.rawValue) \(newRole.rawValue)")

        if newRole == .broadcaster {
            delegate?.onUserOnlineStateChanged(uid: mUserId, isOnline: true)
        } else if newRole == .audience {
            delegate?.onUserOnlineStateChanged(uid: mUserId, isOnline: false)
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("didJoinedOfUid \(uid)")

        delegate?.onUserOnlineStateChanged(uid: uid, isOnline: true)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("didOfflineOfUid \(uid)")

        delegate?.onUserOnlineStateChanged(uid: uid, isOnline: false)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        print("didAudioMuted \(uid) \(muted)")

        delegate?.onUserMuteAudio(uid: uid, muted: muted)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        for info in speakers {
            if info.volume > 0 {
                let uid = info.uid == 0 ? mUserId : info.uid
                delegate?.onAudioVolumeIndication(uid: uid, volume: info.volume)
            }
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, localAudioMixingStateDidChanged state: AgoraAudioMixingStateCode, errorCode: AgoraAudioMixingErrorCode) {
        delegate?.onAudioMixingStateChanged(isPlaying: state == .playing)
    }
}
