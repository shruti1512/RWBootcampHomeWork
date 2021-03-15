//
//  RestaurantViewModel.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class RestaurantViewModel {
  
  // MARK: - Instance Properties
  
  let restaurant: Restaurant
  let nameText: String
  let addressText: String
  let ratingText: String
  let ratingDouble: Double?
  let captionText: String?

  // MARK: - Intializer
  
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

    var distanceText = ""
    if let distance = restaurant.distanceFromCurrentLocation {
       distanceText = " \u{2022} " + String(distance) + " mi"
    }
    captionText = (restaurant.priceLevel?.priceText ?? "") + distanceText
  }

}

