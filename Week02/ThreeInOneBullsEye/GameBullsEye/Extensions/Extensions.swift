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

extension UIColor {
  
  convenience init(rgbStruct rgb: RGB) {
    let r = CGFloat(rgb.r) / 255.0
    let g = CGFloat(rgb.g) / 255.0
    let b = CGFloat(rgb.b) / 255.0
    self.init(red: r, green: g, blue: b, alpha:1.0)
  }
}

//extension UIViewController {
//  
//  typealias CompletionHandler = () -> ()
//  
//  func showAlertController(with title: String, message: String, completionHandler: @escaping CompletionHandler) {
//      
//      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//      let action = UIAlertAction(title: ScoreAlertConstants.ok, style: .default, handler: {
//        action in
//          completionHandler()
//      })
//      alert.addAction(action)
//      present(alert, animated: true, completion: nil)
//  }
//
//}
