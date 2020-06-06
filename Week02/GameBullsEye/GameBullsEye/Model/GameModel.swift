//
//  GameModel.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/5/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

enum GameType {
    case bullsEye
    case rgbBullsEye
    case revBullsEye
}

struct GameModel {
    var name: String
    var type: GameType
    var displayText: String
    var minValue: Int
    var maxValue: Int
}
