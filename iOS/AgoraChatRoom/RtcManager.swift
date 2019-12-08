//
//  RtcManager.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/11/25.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

import AgoraAudioKit

protocol RtcDelegate {
    func onAudioMuteUpdated(userId: String, mute: Bool?)
    
    func onAudioVolumeUpdated(userId: String, volume: Int?)
}

class RtcManager: NSObject {
    static let sharedInstance = RtcManager()
    
    private var mRtcEngine: AgoraRtcEngineKit? = nil
    private var delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    private var mUserId: UInt = 0;
    
    var mAudioStatusMap = [String: AudioStatus]()
    
    private override init() {}
    
    func addDelegate(_ delegate: RtcDelegate) {
        delegates.add(delegate as AnyObject)
    }
    
    func removeDelegate(_ delegate: RtcDelegate) {
        delegates.remove(delegate as AnyObject)
    }
    
    func initialize() {
        if mRtcEngine == nil {
            mRtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: Constant.sAppId, delegate: self)
        }
        mRtcEngine?.setChannelProfile(.liveBroadcasting)
        mRtcEngine?.setAudioProfile(.musicHighQuality, scenario: .chatRoomEntertainment)
        mRtcEngine?.enableAudioVolumeIndication(600, smooth: 3, report_vad: false)
    }
    
    func joinChannel(_ channelId: String, _ userId: UInt) {
        mRtcEngine?.joinChannel(byToken: nil, channelId: channelId, info: nil, uid: userId, joinSuccess: { (channel, uid, elapsed) in
            print("rtc join success \(channel) \(uid)")
            self.mUserId = uid;
        })
    }
    
    func setClientRole(_ role: AgoraClientRole) {
        mRtcEngine?.setClientRole(role)
    }
    
    func setEnableSpeakerphone(_ enabled: Bool) {
        mRtcEngine?.setEnableSpeakerphone(enabled)
    }
    
    func muteAllRemoteAudioStreams(_ muted: Bool) {
        mRtcEngine?.muteAllRemoteAudioStreams(muted)
    }

    func muteLocalAudioStream(_ muted: Bool) {
        mRtcEngine?.muteLocalAudioStream(muted)
        updateAudioStatus(mUserId, nil, muted)
    }
    
    private func updateAudioStatus(_ uid: UInt, _ volume: Int?, _ muted: Bool?) {
        let key = String(uid)
        var audioStatus = mAudioStatusMap[key]
        if volume != nil {
            if audioStatus != nil {
                audioStatus!.volume = volume!
            } else {
                audioStatus = AudioStatus(volume: volume!)
                mAudioStatusMap[key] = audioStatus
            }
            
            for delegate in delegates.allObjects {
                (delegate as! RtcDelegate).onAudioVolumeUpdated(userId: key, volume: volume)
            }
        } else if muted != nil {
            if audioStatus != nil {
                if muted != nil {
                    audioStatus!.mute = muted!
                }
            } else {
                audioStatus = AudioStatus(mute: muted!)
                mAudioStatusMap[key] = audioStatus
            }
            
            for delegate in delegates.allObjects {
                (delegate as! RtcDelegate).onAudioMuteUpdated(userId: key, mute: muted)
            }
        } else {
            mAudioStatusMap.removeValue(forKey: key)
            
            for delegate in delegates.allObjects {
                (delegate as! RtcDelegate).onAudioMuteUpdated(userId: key, mute: nil)
            }
        }
    }
    
    func startAudioMixing() {
        let musicPath = Bundle.main.path(forResource: "Sound Horizon - 記憶の水底", ofType: ".mp3")
        mRtcEngine?.startAudioMixing(musicPath!, loopback: false, replace: false, cycle: 1)
        mRtcEngine?.adjustAudioMixingVolume(15)
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
    
    func leave() {
        mAudioStatusMap.removeAll()
        mRtcEngine?.leaveChannel(nil)
    }
}

extension RtcManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole) {
        print("didClientRoleChanged \(oldRole) \(newRole)")
        
        if newRole == .broadcaster {
            updateAudioStatus(mUserId, nil, false)
        } else if newRole == .audience {
            updateAudioStatus(mUserId, nil, nil)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("didJoinedOfUid \(uid)")
        
        updateAudioStatus(uid, nil, false)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("didOfflineOfUid \(uid)")
        
        updateAudioStatus(uid, nil, nil)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        print("didAudioMuted \(uid) \(muted)")
        updateAudioStatus(uid, nil, muted)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        for info in speakers {
            print("reportAudioVolumeIndicationOfSpeakers \(info)")
            updateAudioStatus(info.uid, Int(info.volume), nil)
        }
    }
}
