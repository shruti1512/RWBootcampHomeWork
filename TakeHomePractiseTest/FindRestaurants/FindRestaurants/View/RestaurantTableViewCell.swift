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

  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var addressLbl: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var ratingLbl: UILabel!
  @IBOutlet weak var captionLbl: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    ratingView.settings.updateOnTouch = false
    ratingView.settings.fillMode = .precise
  }
  
}

/*
// MARK: - RestaurantViewModelView
extension RestaurantTableViewCell: RestaurantViewModelView {
  
  public var restaurantNameLbl: UILabel {
    return nameLbl
  }
  
  public var restaurantAddressLbl: UILabel {
    return addressLbl
  }
  
  public var restaurantRatingView: CosmosView {
    return ratingView
  }

  public var restaurantRatingLabel: UILabel {
    return ratingLbl
  }

  public var restaurantCaptionLabel: UILabel {
    return captionLbl
  }

}
 */
