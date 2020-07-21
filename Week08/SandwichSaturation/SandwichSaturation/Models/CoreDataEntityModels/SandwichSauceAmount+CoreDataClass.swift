//
//  SandwichSauceAmount+CoreDataClass.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/16/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


public class SandwichSauceAmount: NSManagedObject {

}

extension SandwichSauceAmount {
  
  var sauceAmount: SauceAmount {
    get {
      guard let sauceAmount = SauceAmount(rawValue: self.amount) else {
          return .none
      }
      return sauceAmount
    }
    
    set {
      self.amount = newValue.rawValue
    }
  }
}
