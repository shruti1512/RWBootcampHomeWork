//
//  RestaurantTableViewCell.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/12/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit
import Cosmos

class RestaurantTableViewCell: UITableViewCell {

  //MARK: - Properties

  static let reuseIdentifier = String(describing: RestaurantTableViewCell.self)
  
  //MARK: - IBOutlets

  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var addressLbl: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var ratingLbl: UILabel!
  @IBOutlet weak var captionLbl: UILabel!

  //MARK: - Intializer

  override func awakeFromNib() {
    super.awakeFromNib()
    ratingView.settings.updateOnTouch = false
    ratingView.settings.fillMode = .precise
  }
  
}
