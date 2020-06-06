//
//  GameLogic.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/6/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

class GameLogic {
    
    private(set) var round = 0
    private(set) var gameScore = 0
    var roundScore = 0

    func startNewRound() {
        round += 1
    }
     
    func startNewGame() {
        roundScore = 0
        gameScore = 0
        round = 0
        startNewRound()
    }
    
    func addBonus(points: Int) {
        roundScore += points
    }
    
    func calculateGameScore() {
        gameScore +=  roundScore
    }

}
