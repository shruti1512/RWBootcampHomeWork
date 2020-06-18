//
//  TableViewDataSource.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSouce: NSObject, UITableViewDataSource {
  
  var places: [Restaurant]
  private let reuseIdentifier: String

  init(places: [Restaurant], reuseIdentifier: String) {
    self.places = places
    self.reuseIdentifier = reuseIdentifier
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
      return places.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RestaurantTableViewCell

      let restaurant = places[indexPath.row]
      let restaurantViewModel = RestaurantViewModel(restaurant: restaurant)
      cell.nameLbl?.text = restaurantViewModel.nameText
      cell.addressLbl?.text = restaurantViewModel.addressText
      cell.ratingLbl?.text = restaurantViewModel.ratingText
      if let ratingDouble =  restaurantViewModel.ratingDouble {
        cell.ratingView?.rating = ratingDouble
      }
      else {
        cell.ratingView?.isHidden = true
      }
      cell.captionLbl?.text = restaurantViewModel.captionText

      return cell
  }

}
