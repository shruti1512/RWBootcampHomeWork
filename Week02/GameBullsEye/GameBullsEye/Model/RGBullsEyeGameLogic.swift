//
//  RGBullsEyeGameLogic.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/6/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

class RGBullsEyeGameLogic: GameLogic {
    
    //only the setter is private!
    private(set) var targetValue = RGB()
    
    override func startNewRound() {
        super.startNewRound()
        let red =  GameLogic.getRandomNumber(in: 0...255)
        let green = GameLogic.getRandomNumber(in: 0...255)
        let blue =  GameLogic.getRandomNumber(in: 0...255)
        targetValue = RGB(r: red, g: green, b: blue)
    }

    func calculateRoundScore(for guessValue: RGB) {
        let difference = Int(abs(guessValue.difference(target: targetValue)))
        roundScore = 100 - difference
    }

}
