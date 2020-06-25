//
//  TableViewDataSource.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

enum TableViewCellType: String {
  case textPostCell = "TextPostCell"
  case imagePostCell = "ImagePostCell"
}

class TableViewDataSource: NSObject, UITableViewDataSource {
  
  var models: [MediaPost]

  init(models: [MediaPost]) {
      self.models = models
  }

  func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
      return models.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let mediaPost = models[indexPath.row]
    
      if let textPost = mediaPost as? TextPost {
         let mediaPostViewModel = MediaPostViewModel(textPost: textPost)
         let cell = mediaPostViewModel.configureTableViewCell(.textPostCell, in: tableView)
         return cell
      }
      else if let imagePost = mediaPost as? ImagePost {
         let mediaPostViewModel = MediaPostViewModel(imagePost: imagePost)
         let cell = mediaPostViewModel.configureTableViewCell(.imagePostCell, in: tableView)
         return cell
      }
      return UITableViewCell()
  }
  
    //Implement this method to show swipe to delete feature in table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        models.remove(at: indexPath.row)
        MediaPostsHandler.shared.deletePost(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

    }

}
