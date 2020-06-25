//
//  TextPostModel.swift
//  Birdie
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

struct TextPost: MediaPost, Equatable {
    var textBody: String?
    var userName: String
    var timestamp: Date
}
