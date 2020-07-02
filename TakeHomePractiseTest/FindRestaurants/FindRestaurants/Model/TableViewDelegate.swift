//
//  TableViewDelegate.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate {
  
  typealias SelectionHandler = (Int) -> Void

  var places: [Restaurant]
  let onSelection: SelectionHandler

  init(places: [Restaurant], onSelection: @escaping SelectionHandler) {
    self.places = places
    self.onSelection = onSelection
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    onSelection(indexPath.row)
  }

}
