//
//  Cardswift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class CardView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    layer.cornerRadius = 10.0
    layer.shadowRadius = 8.0
    layer.shadowOpacity = 0.2
    layer.borderWidth = 0
    layer.borderColor = UIColor.clear.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    backgroundColor = .systemBackground
  }
  
}
