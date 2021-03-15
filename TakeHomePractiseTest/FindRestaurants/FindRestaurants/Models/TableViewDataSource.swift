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
  
  //MARK: - Properties
  
  var places: [Restaurant]
  private let reuseIdentifier: String

  //MARK: - Intializer

  init(places: [Restaurant], reuseIdentifier: String) {
      self.places = places
      self.reuseIdentifier = reuseIdentifier
  }

  //MARK: - UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
      return places.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let restaurant = places[indexPath.row]
      let restaurantViewModel = RestaurantViewModel(restaurant: restaurant)
      guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? RestaurantTableViewCell else {
        fatalError("Could not create cell")
      }
      cell.restaurantViewModel = restaurantViewModel
      return cell
  }
  
}
