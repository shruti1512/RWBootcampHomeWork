//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Shruti Sharma on 6/4/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

struct BullsEyeGame {
    
    private static func getRandomNumber(in range: CountableClosedRange<Int>) -> Int {
        Int.random(in: range)
    }

    static func getRandomRGB() -> RGB {
        let red =  Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue =  Int.random(in: 0...255)
        return RGB(r: red, g: green, b: blue)
    }

    private(set) var targetValue = RGB()
    private(set) var gameScore = 0
    private(set) var roundScore = 0
    private(set) var round = 0
                
    mutating func startNewRound() {
        
        round += 1
        targetValue = BullsEyeGame.getRandomRGB()
    }
     
    mutating func startNewGame() {
        roundScore = 0
        gameScore = 0
        round = 0
        startNewRound()
    }
    
    mutating func calculateRoundScore(for guessValue: RGB) {
        let difference = Int(abs(guessValue.difference(target: targetValue)))
        roundScore = 100 - difference
    }
    
    mutating func addBonus(points: Int) {
        roundScore += points
    }
    
    mutating func calculateGameScore() {
        gameScore +=  roundScore
    }

}
