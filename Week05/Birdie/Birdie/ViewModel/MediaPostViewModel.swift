//
//  RestaurantViewModel.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

class MediaPostViewModel {
  
  // MARK: - Instance Properties
  let mediaPost: MediaPost
  let userNameText: String
  let timestampText: Date
  let bodyText: String?
  var postImage: UIImage?
  let dateFormat = "E, d MMM h:mm a"

  // MARK: - Object Lifecycle
  public convenience init(textPost: TextPost) {
    self.init(mediaPost: textPost)
  }
  
  public convenience init(imagePost: ImagePost) {
    self.init(mediaPost: imagePost)
    self.postImage = imagePost.image
  }
  
  private init(mediaPost: MediaPost) {
    self.mediaPost = mediaPost
    self.userNameText = mediaPost.userName
    self.timestampText = mediaPost.timestamp
    self.bodyText = mediaPost.textBody
  }

}


extension MediaPostViewModel {

  public func configureTableViewCell(_ cellType: TableViewCellType,  in tableView: UITableView) -> UITableViewCell {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let dateToString = dateFormatter.string(from: timestampText)
    
    switch cellType {
    case .textPostCell:
      let textCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue) as! TextPostTableViewCell
      textCell.titleLabel?.text = userNameText
      textCell.bodyLabel?.text = bodyText
      textCell.timestampLabel?.text = dateToString
      return textCell
    case .imagePostCell:
      let imageCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue) as! ImagePostTableViewCell
      imageCell.titleLabel?.text = userNameText
      imageCell.bodyLabel?.text = bodyText
      imageCell.postImageView.image = postImage
      imageCell.timestampLabel.text = dateToString
      return imageCell
    }
    
  }
}
