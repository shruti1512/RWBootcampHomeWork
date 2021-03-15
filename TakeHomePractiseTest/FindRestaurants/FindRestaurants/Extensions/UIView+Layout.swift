//
//  UIView+Layout.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 8/23/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

extension UIView {
  
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
    
  func anchor(top: NSLayoutYAxisAnchor?,
              leading: NSLayoutXAxisAnchor?,
              bottom: NSLayoutYAxisAnchor?,
              trailing: NSLayoutXAxisAnchor?,
              padding: UIEdgeInsets = .zero,
              size: CGSize = .zero) {
        
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
    }
    
    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
    }
    
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
    }
  
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
  }
  
  func anchorSize(to view: UIView) {
    
    translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalTo: view.widthAnchor),
      heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
  }
  
  func fillSuperview() {
    
    translatesAutoresizingMaskIntoConstraints = false

    anchor(top: superview?.topAnchor,
           leading: superview?.leadingAnchor,
           bottom: superview?.bottomAnchor,
           trailing: superview?.trailingAnchor)
  }
  
  func center(in view: UIView, xAnchor: Bool = true, yAnchor: Bool = true) {
      translatesAutoresizingMaskIntoConstraints = false
      
      if xAnchor { centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true }
      if yAnchor { centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true }
  }

}
