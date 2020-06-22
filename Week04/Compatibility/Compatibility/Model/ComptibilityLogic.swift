//
//  GameLogic.swift
//  Compatibility
//
//  Created by Shruti Sharma on 6/20/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

class ComptibilityLogic {
  
  let person1: Person!
  let person2: Person!
  let compatibilityItems: [String]!
  
  init(person1: Person, person2: Person, compatibilityItems: [String]) {
    self.person1 = person1
    self.person2 = person2
    self.compatibilityItems = compatibilityItems
  }
  
  func calculateCompatibilityScore() -> String {
    
      var percentagesForAllItems: [Double] = []
      for (key, person1Rating) in person1.items {
          let person2Rating = person2.items[key] ?? 0
          let difference = abs(person1Rating - person2Rating)
          percentagesForAllItems.append(Double(difference))
      }

      let sumOfAllPercentages = percentagesForAllItems.reduce(0, +)
      let matchPercentage = sumOfAllPercentages/Double(compatibilityItems.count)
      let matchDouble = 100 - (matchPercentage * 100).rounded()
      let formatter = NumberFormatter()
      let score = formatter.cleanNumberString(from: matchDouble as NSNumber) + "%"
      return score
  }
  
}
