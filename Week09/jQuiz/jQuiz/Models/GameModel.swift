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
  typealias CategoryResult = Result<[CategoryWrapper], NetworkError>
  typealias CluesResult = Result<[Clue], NetworkError>

  private let maxClueCount = 4
  private var cluesCompletionHandler: CompletionHandler?
  
  public var score = 0
  public var category: Category?
  public var clues = [Clue]()
  public var correctAnswerClue: Clue?
  public var correctAnsClueIndex = 0
  
  private struct JQuizAPI {
    static let baseUrl = "http://www.jservice.io/api/"
    static let categoryEndPoint = "random"
    static let cluesEndPoint = "clues"
    static let cluesURLQueryItemCategory = "category"
    static let cluesURLQueryItemOffset = "offset"
  }
  

  public func fetchCategory(onCompletion: CompletionHandler? = nil) {
    
    if onCompletion != nil {
      cluesCompletionHandler = onCompletion
    }
    
    Networking.fetchData(for: URL(string: JQuizAPI.baseUrl + JQuizAPI.categoryEndPoint)) { [weak self]
      (result: CategoryResult) in
      
      switch result {
      case .success(let categoryWrapper):
        guard let self = self, let firstObj = categoryWrapper.first else {
          return
        }
        let categoryObj = firstObj.category
        self.category = categoryObj
        print("categoryID: \(categoryObj.id)")
        self.fetchClues(for: self.category!)
      case .failure(let error):
        print("Network error: \(error)")
      }
    }
  }
  
  private func fetchClues(for category: Category) {
    
    let categoryID = "\(category.id)"
    let cluesCount = category.cluesCount ?? 0
    let offset = cluesCount <= self.maxClueCount ? "0" : String(cluesCount - self.maxClueCount)
    
    let parameters = [
      JQuizAPI.cluesURLQueryItemCategory: categoryID,
      JQuizAPI.cluesURLQueryItemOffset: offset
    ]
    var cluesURLComponents = URLComponents(string: JQuizAPI.baseUrl + JQuizAPI.cluesEndPoint)!
    cluesURLComponents.queryItems = parameters.map({ (key, value) -> URLQueryItem in
      URLQueryItem(name: key, value: String(value))
    })
    print(cluesURLComponents.url!) //http://www.jservice.io/api/clues/?category=2645&offset=11
    
    Networking.fetchData(for: cluesURLComponents.url) {
      [weak self] (result: CluesResult) in
      guard let self = self else { return }
      switch result {
      case .success(let clues):
        self.checkForValidClues(inArray: clues)
      case .failure(let error):
        print("Network error: \(error)")
      }
    }
  }

  
  //  public func loadCategoryAndClues(onCompletion: CompletionHandler? = nil) {
  //
  //    if onCompletion != nil {
  //      cluesCompletionHandler = onCompletion
  //    }
  //
  //    Networking.getCategoryID { [weak self] result in
  //
  //      switch result {
  //
  //      case .success(let category):
  //        guard let self = self else { return }
  //        self.category = category
  //        print("categoryID: \(category.id)")
  //
  //        let categoryID = String(category.id)
  //        let cluesCount = category.cluesCount ?? 0
  //        let offset = cluesCount <= self.maxClueCount ? "0" : String(cluesCount - self.maxClueCount)
  //
  //        Networking.getCluesForQuestion(withCategoryID: categoryID,
  //                                       offset: offset) { [weak self] result in
  //
  //          switch result {
  //          case .success(let clues):
  //            self?.checkForValidClues(inArray: clues)
  //          case .failure(let error):
  //            print("Network error: \(error)")
  //          }
  //        }
  //      case .failure(let error):
  //        print("Network error: \(error)")
  //      }
  //    }
  //  }
    
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
    
    clueCount != maxClueCount ? fetchCategory() : setupQuestionAndAnswer()
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
