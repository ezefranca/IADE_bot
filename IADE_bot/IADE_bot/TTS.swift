//
//  TTS.swift
//  IADE_bot
//
//  Created by Ezequiel dos Santos on 11/02/2024.
//

import Foundation
import AVFoundation

@available(macOS 14, *)
@available(iOS 17, *)
@Observable
public class TTS: NSObject, AVSpeechSynthesizerDelegate {

  private var synth: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    override init() {
        print(AVSpeechSynthesisVoice.speechVoices())
    }
    
  public func reset() {
    stop()
  }

  public func say(
    _ words: String,
    delegate: AVSpeechSynthesizerDelegate? = nil,
    language: String = "pt-PT",
    rate: Float = 0.3,
    volume: Float = 1.0
  ) throws {
    // https://stackoverflow.com/questions/53619027/avspeechsynthesizer-volume-too-low
    #if os(iOS)
      let audioSession = AVAudioSession() // 2) handle audio session first, before trying to read the text
       do {
           try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
           try audioSession.setActive(false)
//           try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
//           try audioSession.setMode(AVAudioSession.Mode.default)
//           try audioSession.setActive(true)
//           try AVAudioSession.sharedInstance().overrideOutputAudioPort(
//             AVAudioSession.PortOverride.speaker)
       } catch let error {
           print("❓", error.localizedDescription)
       }
    #endif
    if synth == nil {
      synth = AVSpeechSynthesizer()
    }

    let utterance = AVSpeechUtterance(string: words)
    // should we precreate voices?
      guard let voice = AVSpeechSynthesisVoice(language: language) else {
          return
    }
    utterance.voice = voice
    utterance.rate = rate
    utterance.volume = volume
    utterance.prefersAssistiveTechnologySettings = false
    synth.delegate = delegate
    synth.speak(utterance)
  }

  public func stop() {
//    guard let synth = synth else {
//      // nothing to do here
//      return
//    }
    if synth.isSpeaking {
      synth.stopSpeaking(at: AVSpeechBoundary.word)
    }
  }

  // delegate, observable

  public var speaking = false
  public var range = NSRange()
  public var speechRate = 0.3
  public var utter = ""

  public func speechSynthesizer(
    _: AVSpeechSynthesizer,
    didStart utterance: AVSpeechUtterance
  ) {
    speaking = true
    utter = utterance.speechString
  }

  public func speechSynthesizer(
    _: AVSpeechSynthesizer,
    didPause _: AVSpeechUtterance
  ) {
    speaking = false
  }

  public func speechSynthesizer(
    _: AVSpeechSynthesizer,
    didCancel _: AVSpeechUtterance
  ) {
    speaking = false
  }

  public func speechSynthesizer(
    _: AVSpeechSynthesizer,
    didContinue _: AVSpeechUtterance
  ) {
    speaking = true
  }

  public func speechSynthesizer(
    _: AVSpeechSynthesizer,
    willSpeakRangeOfSpeechString characterRange: NSRange,
    utterance _: AVSpeechUtterance
  ) {
    range = characterRange
  }

  public func speechSynthesizer(
    _: AVSpeechSynthesizer,
    didFinish _: AVSpeechUtterance
  ) {
    speaking = false
  }

}
