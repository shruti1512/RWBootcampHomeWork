//
//  SoundManager.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import AVFoundation

class SoundManager: NSObject {
  
  public static let shared = SoundManager()
  
  private let jeopardyAudioFileName = "Jeopardy-theme-song.mp3"
  private let wrongAnswerAudioFileName = "Wrong-answer-sound-effect.mp3"
  private let correctAnswerAudioFileName = "correct_answer.mp3"

  private lazy var themeAudioPlayer: AVAudioPlayer? = {
    
    if let soundUrl = Bundle.main.url(forAuxiliaryExecutable: jeopardyAudioFileName)  {
      do {
        let audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1
        return audioPlayer
      } catch {
        print(error)
      }
    }
    return nil
  }()
  
  private lazy var wrongAnsAudioPlayer: AVAudioPlayer? = {
    
    if let soundUrl = Bundle.main.url(forAuxiliaryExecutable: wrongAnswerAudioFileName)  {
      do {
        let audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
        audioPlayer.prepareToPlay()
        audioPlayer.enableRate = true
        audioPlayer.rate = 2.0
        audioPlayer.volume = 0.2
        return audioPlayer
      } catch {
        print(error)
      }
    }
    return nil
  }()

  private lazy var correctAnsAudioPlayer: AVAudioPlayer? = {
    
    if let soundUrl = Bundle.main.url(forAuxiliaryExecutable: correctAnswerAudioFileName)  {
      do {
        let audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
        audioPlayer.prepareToPlay()
        audioPlayer.enableRate = true
        audioPlayer.rate = 2.0
        return audioPlayer
      } catch {
        print(error)
      }
    }
    return nil
  }()

  public var isSoundEnabled: Bool? {
    get {
      // Since UserDefaults.standard.bool(forKey: "sound") will default to "false" if it has not been set
      // You might want to use `object`, because if an object has not been set yet it will be nil
      // Then if it's nil you know it's the user's first time launching the app
      UserDefaults.standard.object(forKey: "sound") as? Bool
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "sound")
    }
  }
  
  public func playThemeSound() {
    themeAudioPlayer?.play()
  }
  
  public func stopThemeSound() {
    themeAudioPlayer?.stop()
  }

  public func playWrongAnswerAudio() {
    wrongAnsAudioPlayer?.play()
  }
  
  public func playCorrectAnswerAudio() {
    correctAnsAudioPlayer?.play()
  }

  public func toggleThemeSoundPreference() {
    
    if let _ = isSoundEnabled {
      self.isSoundEnabled?.toggle()
    }
    else {
      isSoundEnabled = false
    }
  }
  
}
