//
//  CardView.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {

  @IBInspectable var cornerRadius: CGFloat = 10.0
  @IBInspectable var shadowOpacity: Float = 0.2
  @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
  @IBInspectable var shadowRadius: CGFloat = 8.0
  @IBInspectable var borderColor: UIColor = UIColor.white
  @IBInspectable var borderWidth: CGFloat = 1.0

  override func layoutSubviews() {
    layer.cornerRadius = cornerRadius
    layer.shadowOpacity = shadowOpacity
    layer.shadowOffset = shadowOffset
    layer.shadowRadius = shadowRadius
    layer.borderColor = borderColor.cgColor
    layer.borderWidth = borderWidth
  }

}
