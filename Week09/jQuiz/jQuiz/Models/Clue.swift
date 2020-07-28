//
//  QuestionCodable.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

struct CategoryWrapper: Decodable {
  let category: Category
}

struct Category: Codable {
  let id: Int
  let title: String
  let cluesCount: Int?
}

struct Clue: Codable {
  let answer: String
  let question: String
  let points: Int?
}

extension Clue {
  
  var isVaild: Bool {
    if answer.isValidString && question.isValidString {
      return true
    }
    return false
  }

  enum CodingKeys: String, CodingKey {
    case answer
    case question
    case points = "value"
  }
}
