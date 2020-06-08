//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Shruti Sharma on 6/4/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol GameProtocol {
  static func random(in: ClosedRange<Int>) -> Self
  static func - (lhs: Self, rhs: Self) -> Int
}

extension Int: GameProtocol { }

extension RGB: GameProtocol {
  
  static func - (lhs: RGB, rhs: RGB) -> Int {
    let rDiff = Double(lhs.r - rhs.r)
    let gDiff = Double(lhs.g - rhs.g)
    let bDiff = Double(lhs.b - rhs.b)
    
    //Adding maxValue of the sqrt expression for scaling
    //255 doesn't scale the value correctly as that's the max for a single color component
    let max = (255.0 * 255.0 * 3.0).squareRoot()
    let dividend = (rDiff * rDiff + gDiff * gDiff + bDiff * bDiff).squareRoot()
    
    //Updating formual to use max for correct scaling
    return Int((dividend / max)*100)
  }
  
  static func random(in range: ClosedRange<Int>) -> RGB {
      return RGB( r:   Int.random(in: range),
                  g:   Int.random(in: range),
                  b:   Int.random(in: range)
                )
  }

}

struct BullsEyeGame<T: GameProtocol> {
    
    private(set) lazy var targetValue = T.random(in: targetRange)
    private(set) var gameScore = 0
    private(set) var roundScore = 0
    private(set) var round = 0
    var targetRange: ClosedRange<Int>!
  
    init(targetRange: ClosedRange<Int>) {
      self.targetRange = targetRange
    }
  
    mutating func startNewRound() {
      round += 1
      targetValue = T.random(in: targetRange)
    }
     
    mutating func startNewGame() {
        roundScore = 0
        gameScore = 0
        round = 0
        startNewRound()
    }
    
    mutating func calculateRoundScore(for guessValue: T) {
      let diff = abs(guessValue - targetValue)
      roundScore = 100 - diff
    }
    
    mutating func addBonus(points: Int) {
        roundScore += points
    }
    
    mutating func calculateGameScore() {
        gameScore +=  roundScore
    }

}
