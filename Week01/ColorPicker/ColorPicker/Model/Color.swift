//
//  ColorModel.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/29/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import CoreGraphics

struct ColorComponent {
  var name: String
  var range: ClosedRange<CGFloat>
}

enum ColorModelType: String {
  
  case rgb = "rgb"
  case hsb = "hsb"
  
  func getColorComponents() -> [ColorComponent] {
    switch self {
    case .rgb:
      let red   = ColorComponent(name: ColorStrings.red,   range: (ColorDefaults.min...ColorDefaults.rgbMax))
      let green   = ColorComponent(name: ColorStrings.green,   range: (ColorDefaults.min...ColorDefaults.rgbMax))
      let blue   = ColorComponent(name: ColorStrings.blue,   range: (ColorDefaults.min...ColorDefaults.rgbMax))
      return [red, green, blue]
    
    case .hsb:
      let hue   = ColorComponent(name: ColorStrings.hue,   range: (ColorDefaults.min...ColorDefaults.hueMax))
      let saturation = ColorComponent(name: ColorStrings.saturation, range: (ColorDefaults.min...ColorDefaults.satbrightMax))
      let brightness  = ColorComponent(name: ColorStrings.brightness,  range: (ColorDefaults.min...ColorDefaults.satbrightMax))
      return [hue, saturation, brightness]
    }
  }
  
  func getWikiUrlString() -> String {
    switch self {
    case .rgb:
      return WikiURLStrings.rgbURL
    case .hsb:
      return WikiURLStrings.hsbURL
    }
  }
}

struct ColorModel {
  
  var name: String
  var type: ColorModelType
  var colorComponents: [ColorComponent]
  var wikiUrlString: String
    
  public static func getColorModel(for type: ColorModelType) -> ColorModel {
    return ColorModel(name: type.rawValue.capitalized,
                      type: type,
                      colorComponents: type.getColorComponents(),
                      wikiUrlString: type.getWikiUrlString())
  }
}

struct UserColor {
  var name:   String
  var model:  ColorModelType
  var color1: CGFloat
  var color2: CGFloat
  var color3: CGFloat
}
