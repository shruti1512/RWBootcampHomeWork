//
//  TableViewDataSource.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/17/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

typealias CellSelection = (SandwichCell) -> Void

class TableViewDataSourceDelegate: NSObject, UITableViewDataSource {
  
  var models: [Sandwich]
  var filteredModels = [Sandwich]()
  var isFiltering: Bool
  let dataManager = DataManager.shared
  let cellSelectionHandler: CellSelection
  
  init(models: [Sandwich], isFiltering: Bool, cellSelectionHandler: @escaping CellSelection) {
    self.models = models
    self.isFiltering = isFiltering
    self.cellSelectionHandler = cellSelectionHandler
  }
  
  // MARK: - Table View
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? filteredModels.count : models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "sandwichCell", for: indexPath) as? SandwichCell
      else { return UITableViewCell() }
    
    let sandwich = isFiltering ? filteredModels[indexPath.row] : models[indexPath.row]
    cell.sandwich = sandwich
    cell.setupCell()
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let sandwich = isFiltering ? filteredModels[indexPath.row] : models[indexPath.row]
      dataManager.deleteSandwich(sandwich)
      models.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
}

extension TableViewDataSourceDelegate: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? SandwichCell {
      cellSelectionHandler(cell)
    }
  }

}
