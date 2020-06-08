//
//  BullsEyeGameLogic.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/6/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

class BullsEyeGameLogic: GameLogic {
    
    //only the setter is private!
    private(set) var targetValue = 0
    
    override func startNewRound() {
        super.startNewRound()
        targetValue = GameLogic.getRandomNumber(in: 0...100)
    }

    func calculateRoundScore(for guessValue: Int) {
        let difference = abs(guessValue.difference(target: targetValue))
        roundScore = 100 - difference
    }

}
