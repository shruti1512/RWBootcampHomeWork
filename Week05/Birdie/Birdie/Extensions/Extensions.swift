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
  
  func roundWithCornerRadius(_ cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
    layer.masksToBounds = true
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor.cgColor
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
