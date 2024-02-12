//
//  AudioRecordState.swift
//  IADE_bot
//
//  Created by Ezequiel dos Santos on 11/02/2024.
//

import Foundation

enum AudioRecordState {
    case idle
    case recordingSpeech
    case processingSpeech
    case error(Error)
}
