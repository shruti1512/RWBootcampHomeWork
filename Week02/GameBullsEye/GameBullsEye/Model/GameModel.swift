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
    private (set) var name: String
    private (set) var type: GameType
    private (set) var promptText: String
    private (set) var minValue: Int
    private (set) var maxValue: Int
    private (set) var defaultValue: Int
    private (set) var htmlFileName: String
}
