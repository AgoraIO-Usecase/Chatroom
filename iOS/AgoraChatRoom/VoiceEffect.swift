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
enum EffectCharacters: Int {
    case OldMan = 0
    case BabyBoy
    case ZhuBaJie
    case Ethereal
    case Hulk
    case BabyGirl
    
    static func list() -> [EffectCharacters] {
        return [.OldMan,
                .BabyBoy,
                .ZhuBaJie,
                .Ethereal,
                .Hulk,
                .BabyGirl]
    }
}

extension EffectCharacters: CSDescriptable {
    func description() -> String {
        switch self {
        case .OldMan:   return "大叔"
        case .BabyBoy:  return "正太"
        case .ZhuBaJie: return "猪八戒"
        case .Ethereal: return "空灵"
        case .Hulk:     return "浩克"
        case .BabyGirl: return "萝莉"
        }
    }
}

// Values
//extension EffectCharacters {
//    func effectValues() -> [String : Double] {
//        var chaDic = [String : Double]()
//
//        switch self {
//        case .OldMan:
//            chaDic["Pitch"] = 0.8
//
//            chaDic["Band31"] = -15
//            chaDic["Band62"] = 0
//            chaDic["Band125"] = 6
//            chaDic["Band250"] = 1
//            chaDic["Band500"] = -4
//            chaDic["Band1k"] = 1
//            chaDic["Band2k"] = -10
//            chaDic["Band4k"] = -5
//            chaDic["Band8k"] = 3
//            chaDic["Band16k"] = 3
//
//            chaDic["DryLevel"] = -12
//            chaDic["WetLevel"] = -12
//            chaDic["RoomSize"] = 0
//            chaDic["WetDelay"] = 90
//            chaDic["Strength"] = 43
//        case .BabyBoy:
//            chaDic["Pitch"] = 1.23
//
//            chaDic["Band31"] = 15
//            chaDic["Band62"] = 11
//            chaDic["Band125"] = -3
//            chaDic["Band250"] = -5
//            chaDic["Band500"] = -7
//            chaDic["Band1k"] = -7
//            chaDic["Band2k"] = -9
//            chaDic["Band4k"] = -15
//            chaDic["Band8k"] = -15
//            chaDic["Band16k"] = -15
//
//            chaDic["DryLevel"] = 4
//            chaDic["WetLevel"] = 2
//            chaDic["RoomSize"] = 0
//            chaDic["WetDelay"] = 91
//            chaDic["Strength"] = 44
//        case .ZhuBaJie:
//            chaDic["Pitch"] = 0.6
//
//            chaDic["Band31"] = 12
//            chaDic["Band62"] = -9
//            chaDic["Band125"] = -9
//            chaDic["Band250"] = 3
//            chaDic["Band500"] = -3
//            chaDic["Band1k"] = 11
//            chaDic["Band2k"] = 1
//            chaDic["Band4k"] = -8
//            chaDic["Band8k"] = -8
//            chaDic["Band16k"] = -9
//
//            chaDic["DryLevel"] = -14
//            chaDic["WetLevel"] = -8
//            chaDic["RoomSize"] = 34
//            chaDic["WetDelay"] = 0
//            chaDic["Strength"] = 39
//        case .Ethereal:
//            chaDic["Pitch"] = 1
//
//            chaDic["Band31"] = -8
//            chaDic["Band62"] = -8
//            chaDic["Band125"] = 5
//            chaDic["Band250"] = 13
//            chaDic["Band500"] = 2
//            chaDic["Band1k"] = 12
//            chaDic["Band2k"] = -3
//            chaDic["Band4k"] = 7
//            chaDic["Band8k"] = -2
//            chaDic["Band16k"] = -10
//
//            chaDic["DryLevel"] = -17
//            chaDic["WetLevel"] = -13
//            chaDic["RoomSize"] = 72
//            chaDic["WetDelay"] = 9
//            chaDic["Strength"] = 69
//        case .Hulk:
//            chaDic["Pitch"] = 0.5
//
//            chaDic["Band31"] = -15
//            chaDic["Band62"] = 3
//            chaDic["Band125"] = -9
//            chaDic["Band250"] = -8
//            chaDic["Band500"] = -6
//            chaDic["Band1k"] = -4
//            chaDic["Band2k"] = -3
//            chaDic["Band4k"] = -2
//            chaDic["Band8k"] = -1
//            chaDic["Band16k"] = 1
//
//            chaDic["DryLevel"] = 10
//            chaDic["WetLevel"] = -9
//            chaDic["RoomSize"] = 76
//            chaDic["WetDelay"] = 124
//            chaDic["Strength"] = 78
//        case .BabyGirl:
//            chaDic["Pitch"] = 1.45
//
//            chaDic["Band31"] = 10
//            chaDic["Band62"] = 6
//            chaDic["Band125"] = 1
//            chaDic["Band250"] = 1
//            chaDic["Band500"] = -6
//            chaDic["Band1k"] = 13
//            chaDic["Band2k"] = 7
//            chaDic["Band4k"] = -14
//            chaDic["Band8k"] = 13
//            chaDic["Band16k"] = -13
//
//            chaDic["DryLevel"] = -11
//            chaDic["WetLevel"] = -7
//            chaDic["RoomSize"] = 0
//            chaDic["WetDelay"] = 31
//            chaDic["Strength"] = 44
//        }
//        return chaDic
//    }
//}

// MARK: EffectType
//struct EffectType {
//    static func equalizationBandFrequencysList() -> [AgoraAudioEqualizationBandFrequency] {
//        return  [.band31,
//                 .band62,
//                 .band125,
//                 .band250,
//                 .band500,
//                 .band1K,
//                 .band2K,
//                 .band4K,
//                 .band8K,
//                 .band16K]
//    }
//
//    static func reverbsList() -> [AgoraAudioReverbType] {
//        return [.dryLevel,
//                .wetLevel,
//                .roomSize,
//                .wetDelay,
//                .strength]
//    }
//}
//
//extension AgoraAudioEqualizationBandFrequency: CSDescriptable, CSValueRange {
//    func description() -> String {
//        switch self {
//        case .band31:  return "Band31"
//        case .band62:  return "Band62"
//        case .band125: return "Band125"
//        case .band250: return "Band250"
//        case .band500: return "Band500"
//        case .band1K:  return "Band1k"
//        case .band2K:  return "Band2k"
//        case .band4K:  return "Band4k"
//        case .band8K:  return "Band8k"
//        case .band16K: return "Band16k"
//        }
//    }
//
//    func valueRange() -> CSRange {
//        return CSRange(minValue: -15, maxValue: 15)
//    }
//}
//
//extension AgoraAudioReverbType: CSDescriptable, CSValueRange {
//    func description() -> String {
//        switch self {
//        case .dryLevel: return "DryLevel"
//        case .wetLevel: return "WetLevel"
//        case .roomSize: return "RoomSize"
//        case .wetDelay: return "WetDelay"
//        case .strength: return "Strength"
//        }
//    }
//
//    func valueRange() -> CSRange {
//        switch self {
//        case .dryLevel: return CSRange(minValue: -20, maxValue: 10)
//        case .wetLevel: return CSRange(minValue: -20, maxValue: 10)
//        case .roomSize: return CSRange(minValue: 0, maxValue: 100)
//        case .wetDelay: return CSRange(minValue: 0, maxValue: 200)
//        case .strength: return CSRange(minValue: 0, maxValue: 100)
//        }
//    }
//}

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
            agoraKit.setLocalVoicePitch(0.8)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: -15)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 0)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 6)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 1)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: -4)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 1)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: -10)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: -5)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 3)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 3)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -12)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -12)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 90)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 43)
            
        case .BabyBoy:
            agoraKit.setLocalVoicePitch(1.23)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 15)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 11)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: -3)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: -5)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: -7)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: -7)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: -9)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: -15)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: -15)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: -15)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 4)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: 2)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 91)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 44)
            
        case .ZhuBaJie:
            agoraKit.setLocalVoicePitch(0.6)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 12)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: -9)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: -9)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 3)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: -3)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 11)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 1)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: -8)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: -8)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: -9)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -14)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -8)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 34)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 39)
            
        case .Ethereal:
            agoraKit.setLocalVoicePitch(1)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: -8)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: -8)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 5)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 13)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: 2)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 12)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: -3)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: 7)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: -2)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: -10)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -17)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -13)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 72)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 9)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 69)
            
        case .Hulk:
            agoraKit.setLocalVoicePitch(0.5)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: -15)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 3)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: -9)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: -8)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: -6)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: -4)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: -3)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: -2)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: -1)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: 1)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: 10)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -9)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 76)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 124)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 78)
            
        case .BabyGirl:
            agoraKit.setLocalVoicePitch(1.45)
            
            agoraKit.setLocalVoiceEqualizationOf(.band31, withGain: 10)
            agoraKit.setLocalVoiceEqualizationOf(.band62, withGain: 6)
            agoraKit.setLocalVoiceEqualizationOf(.band125, withGain: 1)
            agoraKit.setLocalVoiceEqualizationOf(.band250, withGain: 1)
            agoraKit.setLocalVoiceEqualizationOf(.band500, withGain: -6)
            agoraKit.setLocalVoiceEqualizationOf(.band1K, withGain: 13)
            agoraKit.setLocalVoiceEqualizationOf(.band2K, withGain: 7)
            agoraKit.setLocalVoiceEqualizationOf(.band4K, withGain: -14)
            agoraKit.setLocalVoiceEqualizationOf(.band8K, withGain: 13)
            agoraKit.setLocalVoiceEqualizationOf(.band16K, withGain: -13)
            
            agoraKit.setLocalVoiceReverbOf(.dryLevel, withValue: -11)
            agoraKit.setLocalVoiceReverbOf(.wetLevel, withValue: -7)
            agoraKit.setLocalVoiceReverbOf(.roomSize, withValue: 0)
            agoraKit.setLocalVoiceReverbOf(.wetDelay, withValue: 31)
            agoraKit.setLocalVoiceReverbOf(.strength, withValue: 44)
        }
    }
}

// MARK: protocol and Other structs
protocol CSDescriptable {
    func description() -> String
}

protocol CSValueRange {
    func valueRange() -> CSRange
}

protocol CSRoleCharacter {
    func character() -> [String : Double]
}

protocol CSGetType {
    static func getEnumType(description: String) -> CSEnumType?
}

struct CSEnumType {
    var enumType: AnyObject
    var subType:  AnyObject
}

struct CSRange {
    var minValue : Int!
    var maxValue : Int!
}
