//
//  GameModel.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/5/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

enum GameType: Int {
    case bullsEye = 0
    case rgbBullsEye = 1
    case revBullsEye = 2
}

struct GameModel {
    var name: String
    var type: GameType
    var promptText: String
    var minValue: Int
    var maxValue: Int
}
