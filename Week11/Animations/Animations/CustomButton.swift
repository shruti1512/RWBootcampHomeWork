//
//  CustomButton.swift
//  Animations
//
//  Created by Shruti Sharma on 8/8/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

enum ButtonPosition {
  case left
  case center
  case right
  case top
}

enum CustomButtonType: String, CaseIterable {
  case translate
  case scale
  case rotate
  case play
  
  var initialPosition: ButtonPosition {
    .center
  }
  
  var finalPosition: ButtonPosition {
    switch self {
    case .scale:  return .left
    case .translate:  return .top
    case .rotate:  return .right
    case .play:  return .center
    }
  }

  var image: UIImage {
    switch self {
    case .scale: return UIImage(named: "icons8-scale") ?? UIImage(systemName:"pencil.circle.fill")!
    case .translate:  return UIImage(named: "icons8-translate") ??  UIImage(systemName:"pencil.circle.fill")!
    case .rotate:  return UIImage(named: "icons8-rotate") ??  UIImage(systemName:"pencil.circle.fill")!
    case .play:  return UIImage(named: "icons8-play") ??  UIImage(systemName:"pencil.circle.fill")!
    }
  }
}

class CustomButton : UIButton {
  
  var customButtonType: CustomButtonType?
  var initialPosition: ButtonPosition?
  var finalPosition: ButtonPosition?

  convenience init(customButtonType: CustomButtonType,
                   withInitialPosition initialPosition: ButtonPosition,
                   withFinalPosition finalPosition: ButtonPosition) {
    self.init(type: .custom)
    self.customButtonType = customButtonType
    self.initialPosition = initialPosition
    self.finalPosition = finalPosition
  }
}


