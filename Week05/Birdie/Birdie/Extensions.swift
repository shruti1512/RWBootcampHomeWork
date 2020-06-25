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
  
  func makeCircular() {
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(roundf(Float(self.frame.size.width / 2.0)))
  }

}
