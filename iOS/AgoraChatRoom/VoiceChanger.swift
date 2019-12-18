//
//  VoiceChanger.swift
//  AgoraChatRoom
//
//  Created by LXH on 2019/12/18.
//  Copyright © 2019 CavanSu. All rights reserved.
//

import Foundation

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
            return NSLocalizedString("Default", comment: "")
        case .KTV:
            return NSLocalizedString("KTV", comment: "")
        case .LIVE:
            return NSLocalizedString("Live", comment: "")
        case .UNCLE:
            return NSLocalizedString("Uncle", comment: "")
        case .GIRL:
            return NSLocalizedString("Girl", comment: "")
        case .STUDIO:
            return NSLocalizedString("Studio", comment: "")
        case .POP:
            return NSLocalizedString("Pop", comment: "")
        case .RNB:
            return NSLocalizedString("R&B", comment: "")
        case .PHONOGRAPH:
            return NSLocalizedString("Phonograph", comment: "")
        }
    }
}

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
    case OPENAIR

    func description() -> String {
        switch self {
        case .DEFAULT:
            return NSLocalizedString("Default", comment: "")
        case .THICK:
            return NSLocalizedString("Thick", comment: "")
        case .LOW:
            return NSLocalizedString("Low", comment: "")
        case .ROUND:
            return NSLocalizedString("Round", comment: "")
        case .FALSETTO:
            return NSLocalizedString("Falsetto", comment: "")
        case .FULL:
            return NSLocalizedString("Full", comment: "")
        case .CLEAR:
            return NSLocalizedString("Clear", comment: "")
        case .RESOUNDING:
            return NSLocalizedString("Resounding", comment: "")
        case .LOUD:
            return NSLocalizedString("Loud", comment: "")
        case .OPENAIR:
            return NSLocalizedString("OpenAir", comment: "")
        }
    }
}
