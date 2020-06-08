//
//  Constants.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/7/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

struct BullsEyeConstants {
  private init() { } //preventing accidental initialization
  static let name = "Bull's Eye"
  static let promptText = "Put the Bulls's Eye as close as to:"
  static let sliderMinValue = 1
  static let sliderMaxValue = 100
  static let sliderDefaultValue = 50
  static let htmlFileName = "BullsEye"
  static let segueIdentifier = "BullsEyeSegue"
  
}

struct RGBullsEyeConstants {
  private init() { } //preventing accidental initialization
  static let name = "RGB Bull's Eye"
  static let promptText = "Match this color"
  static let sliderMinValue = 0
  static let sliderMaxValue = 255
  static let sliderDefaultValue = 127
  static let htmlFileName = "RGBullsEye"
  static let segueIdentifier = "RGBullsEyeSegue"
}

struct RevBullsEyeConstants {
  private init() { } //preventing accidental initialization
  static let name = "Reverse Bull's Eye"
  static let promptText = "Guess where the slider is:"
  static let sliderMinValue = 1
  static let sliderMaxValue = 100
  static let sliderDefaultValue = 1
  static let htmlFileName = "RevBullsEye"
  static let segueIdentifier = "RevBullsEyeSegue"
}

struct UserHelpViewConstants {
  private init() { } //preventing accidental initialization
  static let warmerText = "Warmer"
  static let warmerMax = 10
  static let warmText = "Warm"
  static let warmMax = 20
  static let coldText = "Cold"
  static let coldMax = 30
  static let colderText = "Colder"
  static let cornerRadius = 5.0
}

struct ScoreConstants {
  private init() { } //preventing accidental initialization
  static let perfectMatch = "Perfect!"
  static let closeMatch = "You almost had it!"
  static let goodMatch = "Pretty good!"
  static let noMatch = "Not even close..."
  static let messagePart1 = "You scored "
  static let messagePart2 = " points."
  static let ok = "OK"
  static let perfectMatchBonus = 100
  static let closeMatchBonus = 50
}

struct LabelConstants {
  private init() { } //preventing accidental initialization
  static let scoreText = "Score: "
  static let roundText = "Round: "
}
