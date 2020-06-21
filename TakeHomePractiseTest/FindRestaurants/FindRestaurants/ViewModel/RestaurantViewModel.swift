//
//  RestaurantViewModel.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
//import UIKit
//import Cosmos

/*
@objc public protocol RestaurantViewModelView {
  @objc optional var restaurantNameLbl: UILabel { get }
  @objc optional var restaurantAddressLbl: UILabel { get }
  @objc optional var restaurantRatingView: CosmosView { get }
  @objc optional var restauarantRatingLbl: UILabel { get }
  @objc optional var restaurantCaptionLbl: UILabel { get }
}
*/

class RestaurantViewModel {
  
  // MARK: - Instance Properties
  let restaurant: Restaurant
  let nameText: String
  let addressText: String
  let ratingText: String
  let ratingDouble: Double?
  let captionText: String?

  // MARK: - Object Lifecycle
  public init(restaurant: Restaurant) {
    
    self.restaurant = restaurant
    
    nameText = restaurant.name
    addressText = restaurant.address
    if let rating = restaurant.rating {
      ratingDouble = Double(rating)
      ratingText = "\(rating)"
    }
    else {
      ratingDouble = nil
      ratingText = "No rating avaialable"
    }

    var priceText = ""
    if let priceLevel = restaurant.priceLevel {
      switch priceLevel {
        case .Free:
          priceText = "Free"
        case .Inexpensive:
          priceText = "$"
        case .Moderate:
          priceText = "$$"
        case .Expensive:
          priceText = "$$$"
        case .VeryExpensive:
          priceText = "$$$$"
        }
    }

    var distanceText = ""
    if let distance = restaurant.distanceFromCurrentLocation {
       distanceText = " \u{2022} " + String(distance) + " mi"
    }
    captionText = priceText + distanceText
  }

}

/*
extension RestaurantViewModel {

  public func configure(_ view: RestaurantViewModelView) {
    view.restaurantNameLbl?.text = nameText
    view.restaurantAddressLbl?.text = addressText
    view.restauarantRatingLbl?.text = ratingText
    if let ratingDouble =  ratingDouble {
      view.restaurantRatingView?.rating = ratingDouble
    }
    else {
      view.restaurantRatingView?.isHidden = true
    }
    view.restaurantCaptionLbl?.text = captionText
  }
}
*/
