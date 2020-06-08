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
    
    func addCornerRadius(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
}
