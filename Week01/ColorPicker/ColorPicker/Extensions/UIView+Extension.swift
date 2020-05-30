//
//  UIView.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/30/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func createBorder(color: UIColor, width: CGFloat, cornerRadius: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
}
