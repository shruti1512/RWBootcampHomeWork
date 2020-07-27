//
//  String+Extension.swift
//  jQuiz
//
//  Created by Shruti Sharma on 7/24/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation


extension String {
  
  func capitalizingFirstLetter() -> String {
      return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
  }


  func removeSpecialCharacters() -> String {

    return self.replacingOccurrences(of: "<[^>]+>|\"|\\\\", with: "",
                                     options: .regularExpression,
                                     range: nil)
  }

  var isValidString: Bool {
    let success = self.range(of: "[a-zA-Z0-9]+", options: .regularExpression, range: nil, locale: nil) != nil
    return success
  }
}
