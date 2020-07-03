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
  let FREE_TEXT = "Free"
  let INEXPENSIVE_TEXT = "$"
  let MODERATE_TEXT = "$$"
  let EXPENSIVE_TEXT = "$$$"
  let VERY_EXPENSIVE_TEXT = "$$$$"


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

    var priceText = ""
    if let priceLevel = restaurant.priceLevel {
      switch priceLevel {
        case .Free:
          priceText = FREE_TEXT
        case .Inexpensive:
          priceText = INEXPENSIVE_TEXT
        case .Moderate:
          priceText = MODERATE_TEXT
        case .Expensive:
          priceText = EXPENSIVE_TEXT
        case .VeryExpensive:
          priceText = VERY_EXPENSIVE_TEXT
        }
    }

    var distanceText = ""
    if let distance = restaurant.distanceFromCurrentLocation {
       distanceText = " \u{2022} " + String(distance) + " mi"
    }
    captionText = priceText + distanceText
  }

}


// MARK: - Configure Table View Cell

extension RestaurantViewModel {

  public func configureTableViewCell(withIdentifier identifier: String,  in tableView: UITableView) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RestaurantTableViewCell else {
      fatalError("Could not create cell")
    }
    cell.nameLbl?.text = nameText
    cell.addressLbl?.text = addressText
    cell.ratingLbl?.text = ratingText
    if let ratingDouble =  ratingDouble {
      cell.ratingView?.rating = ratingDouble
    }
    else {
      cell.ratingView?.isHidden = true
    }
    cell.captionLbl?.text = captionText
    return cell
  }
}
