//
//  SandwichCell.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

class SandwichCell: UITableViewCell {
  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var sauceLabel: UILabel!
  var sandwich: Sandwich?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupCell() {
    guard let sandwich = sandwich else {
      thumbnail.image = nil
      nameLabel.text = ""
      sauceLabel.text = ""
      return
    }
    
    thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName)
    nameLabel.text = sandwich.name
    sauceLabel.text = sandwich.sauceAmount.amount
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
