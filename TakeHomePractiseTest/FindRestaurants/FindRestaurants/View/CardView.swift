//
//  CardView.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {

  @IBInspectable var cornerRadius: CGFloat = 10.0 {
    didSet {
        layer.cornerRadius = self.cornerRadius
    }
  }

  @IBInspectable var shadowOpacity: Float = 0.2 {
    didSet {
      layer.shadowOpacity = shadowOpacity
    }
  }

  @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
    didSet {
      layer.shadowOffset = shadowOffset
    }
  }

  @IBInspectable var shadowRadius: CGFloat = 8.0 {
    didSet {
      layer.shadowRadius = shadowRadius
    }
  }

  @IBInspectable var borderColor: UIColor = UIColor.white {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }

  @IBInspectable var borderWidth: CGFloat = 1.0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
//  override func layoutSubviews() {
//    layer.cornerRadius = cornerRadius
//    layer.shadowOpacity = shadowOpacity
//    layer.shadowOffset = shadowOffset
//    layer.shadowRadius = shadowRadius
//    layer.borderColor = borderColor.cgColor
//    layer.borderWidth = borderWidth
//  }

}
