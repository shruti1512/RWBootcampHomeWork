//
//  Extensions.swift
//  Birdie
//
//  Created by Shruti Sharma on 6/24/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  func roundWithCornerRadius(_ cornerRadius: CGFloat) {
    layer.masksToBounds = true
    layer.cornerRadius = cornerRadius
  }
  
}

extension Date {
  
  func toString(withFormat format: String = "d MMM, HH:mm") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let str = dateFormatter.string(from: self)
    return str
  }
}
