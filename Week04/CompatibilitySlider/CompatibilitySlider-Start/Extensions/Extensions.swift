//
//  ClosedRange+Extension.swift
//  CompatibilitySlider-Start
//
//  Created by Shruti Sharma on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

extension ClosedRange {
  
  func clamp(value : Bound) -> Bound {
    return self.lowerBound > value ? self.lowerBound
        : self.upperBound < value ? self.upperBound
        : value
  }
}

extension NumberFormatter {
  
  func cleanNumberString(from number: NSNumber) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    formatter.numberStyle = .decimal
    let cleanString = (formatter.string(from: number) ?? "n/a") + "%"
    return cleanString
  }
}
