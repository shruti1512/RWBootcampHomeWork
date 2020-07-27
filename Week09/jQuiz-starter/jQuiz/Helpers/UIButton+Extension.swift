//
//  UIButton+Extension.swift
//  jQuiz
//
//  Created by Shruti Sharma on 7/25/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
  
  func flash() {
    
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.5
    flash.fromValue = 1.0
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 4
    
    layer.add(flash, forKey: nil)
  }
}
