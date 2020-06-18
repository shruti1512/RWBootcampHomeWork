//
//  TableViewDelegate.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewDelegateProtocol: class {
  func performOperationForSelectedPlace(place: Restaurant)
}

class TableViewDelegate: NSObject, UITableViewDelegate {
  
  weak var tableDelegate: TableViewDelegateProtocol?
  var places: [Restaurant]

  init(places: [Restaurant]) {
    self.places = places
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let restaurant = places[indexPath.row]
    if let tableDelegate = tableDelegate {
      tableDelegate.performOperationForSelectedPlace(place: restaurant)
    }
  }

}
