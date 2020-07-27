//
//  SelfSizedTableView.swift
//  jQuiz
//
//  Created by Shruti Sharma on 7/24/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
  
  var maxHeight: CGFloat = UIScreen.main.bounds.size.height
  
  override var contentSize: CGSize {
    didSet {
      invalidateIntrinsicContentSize()
      setNeedsLayout()
    }
  }
  
//  override func reloadData() {
//    super.reloadData()
//    self.invalidateIntrinsicContentSize()
//    self.layoutIfNeeded()
//  }
  
  override var intrinsicContentSize: CGSize {
    let height = min(contentSize.height, maxHeight)
    return CGSize(width: contentSize.width, height: height)
  }
  
}
