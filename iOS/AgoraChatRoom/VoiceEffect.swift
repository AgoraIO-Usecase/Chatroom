//
//  VoiceEffect.swift
//  AgoraChatRoom
//
//  Created by CavanSu on 14/03/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import AgoraAudioKit

// MARK: EffectCharacters
enum EffectCharacters: Int, CaseIterable {
    case OldMan = 0
    case BabyBoy
    case ZhuBaJie
    case Ethereal
    case Hulk
    case BabyGirl
    case RecordingRoom
    case VocalConcert
    case Fashion
    case HipHop
    case Rock
    case RB
    case Ethereal2
}

extension EffectCharacters: CSDescriptable {
    func description() -> String {
        switch self {
        case .OldMan:           return "大叔"
        case .BabyBoy:          return "正太"
        case .ZhuBaJie:         return "猪八戒"
        case .Ethereal:         return "空灵"
        case .Hulk:             return "浩克"
        case .BabyGirl:         return "萝莉"
        case .RecordingRoom:    return "录音棚"
        case .VocalConcert:     return "演唱会"
        case .Fashion:          return "流行"
        case .HipHop:           return "嘻哈"
        case .Rock:             return "摇滚"
        case .RB:               return "R&B"
        case .Ethereal2:        return "空灵2"
        }
    }
}

// MARK: EffectDefault
struct VoiceEffect {
    static func common(agoraKit: AgoraRtcEngineKit) {
        agoraKit.setLocalVoicePitch(1)
        
        agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
        
        agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 0)
        agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 0)
        agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 0)
        agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
        agoraKit.setLocalVoiceReverbOf(.strength, withValue: 0)
    }
    
    static func fm(agoraKit: AgoraRtcEngineKit) {
        agoraKit.setLocalVoicePitch(1)
        
        agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
        agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
        
        agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -1)
        agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -7)
        agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 57)
        agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 135)
        agoraKit.setLocalVoiceReverbOf(.strength, withValue: 45)
    }
    
    static func character(agoraKit: AgoraRtcEngineKit, character: EffectCharacters) {
        switch character {
        case .OldMan:
            agoraKit.setLocalVoiceChanger(.oldMan)
        case .BabyBoy:
            agoraKit.setLocalVoiceChanger(.babyBoy)
        case .ZhuBaJie:
            agoraKit.setLocalVoiceChanger(.zhuBaJie)
        case .Ethereal:
            agoraKit.setLocalVoiceChanger(.ethereal)
        case .Hulk:
            agoraKit.setLocalVoiceChanger(.hulk)
        case .BabyGirl:
            agoraKit.setLocalVoiceChanger(.babyGirl)
        case .RecordingRoom:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 10)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 10)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 50)
            
        case .VocalConcert:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 10)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 50)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 45)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 100)

        case .Fashion:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 1)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 1)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 5)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 20)
            
        case .HipHop:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -4)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 5)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 66)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 100)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 0)
            
        case .Rock:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -7)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -7)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 95)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 170)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 58)
            
        case .RB:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -12)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -1)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 20)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 59)
            
        case .Ethereal2:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 0)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -1)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 3)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 100)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 26)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 82)
        }
    }
}

// MARK: protocol and Other structs
protocol CSDescriptable {
    func description() -> String
}
