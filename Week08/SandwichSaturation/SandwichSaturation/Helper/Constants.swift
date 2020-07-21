//
//  Constants.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/20/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import Foundation

enum Constants {
  
  static let userDefaultsKeyFilterIndex = "selectedFilterIndex"
  static let userDefaultsKeyIsDataPreloaded = "isDataPreloaded"
  static let addSegueIdentifier = "AddSandwichSegue"
  static let editSegueIdentifier = "EditSandwichSegue"
  static let listCellReuseIdentifier = SandwichListCell.reuseIdentifier
  static let gridCellReuseIdentifier = SandwichCollectionCell.reuseIdentifier
  static let gridIcon = "square.grid.2x2"
  static let listIcon = "list.bullet"
  static let ascendingIcon = "icons8-ascending-sort"
  static let descendingIcon = "icons8-descending-sort"
  static let searchPlaceholder = "Filter Sandwiches"
}
