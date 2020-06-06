//
//  GameLogic.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/5/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

public class RGBGameLogic {
    
    static func getTargetValue() -> RGB {
        let red =  Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue =  Int.random(in: 0...255)
        return RGB(r: red, g: green, b: blue)
    }

    //only the setter is private!
    private(set) var targetValue = RGB()
    private(set) var round = 0
    private(set) var gameScore = 0
    private(set) var roundScore = 0

    func startNewRound() {
        round += 1
        targetValue = RGBGameLogic.getTargetValue()
    }
     
    func startNewGame() {
        roundScore = 0
        gameScore = 0
        round = 0
        startNewRound()
    }
    
    func calculateRoundScore(for currentValue: RGB) {
        let difference = Int(currentValue.difference(target: targetValue))
        roundScore = 100 - difference
    }
    
    func addBonus(points: Int) {
        roundScore += points
    }
    
    func calculateGameScore() {
        gameScore +=  roundScore
    }
    
}
