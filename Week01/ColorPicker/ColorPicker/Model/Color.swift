//
//  ColorModel.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/29/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import CoreGraphics

enum ColorModelType {
  case rgb
  case hsb
}

struct ColorModel {
  var name: String
  var type: ColorModelType
  var colorValues: [ColorValue]
  var wikiUrlString: String
}

struct ColorValue {
  var name: String
  var minRange: CGFloat
  var maxRange: CGFloat
}

struct UserColor {
  var name: String
  var model: ColorModelType
  var color1: CGFloat
  var color2: CGFloat
  var color3: CGFloat
}
