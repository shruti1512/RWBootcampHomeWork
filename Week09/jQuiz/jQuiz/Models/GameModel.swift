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
  private let networkMgr = Networking.shared
  
  public var score = 0
  public var category: Category?
  public var clues = [Clue]()
  public var correctAnswerClue: Clue?
  public var correctAnsClueIndex = 0
  
  public func loadCategoryAndClues(onCompletion: CompletionHandler? = nil) {
    
    if onCompletion != nil {
      cluesCompletionHandler = onCompletion
    }
    
    networkMgr.getCategoryID { [weak self] result in
      
      switch result {
        
      case .success(let category):
        guard let self = self else { return }
        self.category = category
        print("categoryID: \(category.id)")
        
        let categoryID = String(category.id)
        let cluesCount = category.cluesCount ?? 0
        let offset = cluesCount <= self.maxClueCount ? "0" : String(cluesCount - self.maxClueCount)
        
        self.networkMgr.getCluesForQuestion(withCategoryID: categoryID,
                                            offset: offset) { [weak self] result in
                                              
                                              switch result {
                                              case .success(let clues):
                                                self?.checkForValidClues(inArray: clues)
                                              case .failure(let error):
                                                print("Network error: \(error)")
                                              }
        }
      case .failure(let error):
        print("Network error: \(error)")
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
      setupQuestionAndAnswer()
    }
    
  }
  
  private func setupQuestionAndAnswer() {
    let randomID = Int.random(in: 0..<maxClueCount)
    correctAnsClueIndex = randomID
    correctAnswerClue = clues[randomID]
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
      let points = correctAnswerClue.points ?? 200
      score += points
      isCorrectAnswer.toggle()
    }
    onCompletion(isCorrectAnswer)
  }
  
}
