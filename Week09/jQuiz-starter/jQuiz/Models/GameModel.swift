//
//  GameModel.swift
//  jQuiz
//
//  Created by Shruti Sharma on 7/23/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

class GameModel {
  
  typealias CompletionHandler = () -> Void
  typealias ScoreCompletionHandler = (Bool) -> Void
  
  private let maxClueCount = 4
  private var cluesCompletionHandler: CompletionHandler?

  public var score = 0
  public var category: Category?
  public var clues = [Clue]()
  public var correctAnswerClue: Clue?
  public var correctAnsClueIndex = 0
  
  public func loadCategoryAndClues(onCompletion: CompletionHandler? = nil) {
    
    cluesCompletionHandler = onCompletion
    
    Networking.getCategoryID { (category, error) in
      guard let category = category else { return }
      self.category = category
      print("categoryID: \(category.id)")
      
      Networking.getCluesForQuestion(withCategoryID: self.category!.id) { (clues, error) in
        guard let clues = clues else { return }
        self.checkForValidClues(inArray: clues)
      }
    }
  }
  
  private func checkForValidClues(inArray dataArray: [Clue]) {
    
    clues.removeAll()

    var clueCount = 0
    var index = 0
    repeat {
      let clue = dataArray[index]
      if clue.isVaild {
        clues.append(clue)
        clueCount += 1
      }
      index += 1
    } while (clueCount != maxClueCount && index < dataArray.count)
    
    if clueCount != maxClueCount {
      loadCategoryAndClues()
    }
    else {
      self.setupQuestionAndAnswer()
    }
    
  }
  
  private func setupQuestionAndAnswer() {
    let randomID = Int.random(in: 0..<maxClueCount)
    correctAnsClueIndex = randomID
    self.correctAnswerClue = self.clues[randomID]
    guard let cluesCompletionHandler = cluesCompletionHandler else {
      return
    }
    cluesCompletionHandler()
  }
  
  public func calculateScore(forClue clue: Clue,
                      onCompletion: ScoreCompletionHandler) {
    
    var isCorrectAnswer = false
    guard let correctAnswerClue = correctAnswerClue else { return }
    if clue.answer == correctAnswerClue.answer {
      if let points = correctAnswerClue.points {
        score += points
        isCorrectAnswer.toggle()
      }
    }
    onCompletion(isCorrectAnswer)
  }
  
}
