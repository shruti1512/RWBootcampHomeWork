//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Shruti Sharma on 6/4/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

struct BullsEyeGame {
    
    private static func randomNumberGenerator(in range: CountableClosedRange<Int>) -> Int {
        Int.random(in: range)
    }

    //only the setter is private!
    private(set) var targetValue = 0
    private(set) var round = 0
    private(set) var gameScore = 0
    private(set) var roundScore = 0 

    mutating func startNewRound() {
        round += 1
        targetValue = BullsEyeGame.randomNumberGenerator(in: 1...100)
    }
     
    mutating func startNewGame() {
        roundScore = 0
        gameScore = 0
        round = 0
        startNewRound()
    }
    
    mutating func calculateRoundScore(for guessValue: Int) {
        let difference = abs(guessValue.difference(target: targetValue))
        roundScore = 100 - difference
    }
    
    mutating func addBonus(points: Int) {
        roundScore += points
    }
    
    mutating func calculateGameScore() {
        gameScore +=  roundScore
    }
}
