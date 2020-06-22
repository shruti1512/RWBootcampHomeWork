//
//  ClosedRange+Extension.swift
//  Compatibility
//
//  Created by Shruti Sharma on 6/18/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

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
    let cleanString = (formatter.string(from: number) ?? "n/a")
    return cleanString
  }
}

extension UIView {
    func round() {
      layer.masksToBounds = true
      layer.cornerRadius = CGFloat(roundf(Float(self.frame.size.width / 2.0)))
  }
}

