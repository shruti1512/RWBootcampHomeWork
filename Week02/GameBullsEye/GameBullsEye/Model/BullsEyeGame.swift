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
