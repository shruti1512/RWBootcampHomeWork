//
//  ColorModel.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/29/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation


struct ColorModel {
  
  enum ModelType: Int {
    case rgb = 0
    case hsb = 1
  }
  
  var name: String
  var type: ModelType
  var colorValues: [ColorValue]
}
