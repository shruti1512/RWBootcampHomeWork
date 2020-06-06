//
//  BullsGameLogic.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/5/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

class BullsEyeGame {
    
    //only the setter is private!
    private(set) var targetValue = 0
    private(set) var round = 0
    private(set) var gameScore = 0
    var roundScore = 0
    
    func startNewRound() {
        round += 1
        targetValue = Int.random(in: 1...100)
    }
     
    func startNewGame() {
        roundScore = 0
        gameScore = 0
        round = 0
        startNewRound()
    }
    
    func calculateRoundScore(for guessValue: Int) {
        let difference = abs(guessValue.difference(target: targetValue))
        roundScore = 100 - difference
    }
    
    func addBonus(points: Int) {
        roundScore += points
    }
    
    func calculateGameScore() {
        gameScore +=  roundScore
    }
}
