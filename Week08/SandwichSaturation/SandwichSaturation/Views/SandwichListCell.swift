//
//  SandwichListCell.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/17/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

@IBDesignable class SandwichListCell: UICollectionViewCell, EditableCell {

  static let reuseIdentifier = String(describing: SandwichListCell.self)
  static let nib = String(describing: SandwichListCell.self)

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var sauceLabel: UILabel!
  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var checkboxImageView: UIImageView!
  var isEditing: Bool = false {
    didSet {
      checkboxImageView.isHidden = !isEditing
    }
  }
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        checkboxImageView.image = UIImage(systemName: "checkmark.circle.fill",
                                          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
      }
      else {
        checkboxImageView.image = UIImage(systemName: "checkmark.circle",
                                          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
      }
    }
  }
}
