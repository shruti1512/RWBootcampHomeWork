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

  // MARK: - Initializer 
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

//MARK: - Configure TableViewCell Based on ReuseIdentifier

extension MediaPostViewModel {

  public func configureTableViewCellWithReuseIdentifier(_ identfier: TableViewCellReuseIdentier,  in tableView: UITableView) -> UITableViewCell {
        
    switch identfier {
    case .textPostCell:
      let textCell = tableView.dequeueReusableCell(withIdentifier: identfier.rawValue) as! TextPostTableViewCell
        textCell.titleLabel?.text = userNameText
        textCell.bodyLabel?.text = bodyText
        textCell.timestampLabel?.text = timestampText.toString()
        return textCell
    case .imagePostCell:
      let imageCell = tableView.dequeueReusableCell(withIdentifier: identfier.rawValue) as! ImagePostTableViewCell
        imageCell.titleLabel?.text = userNameText
        imageCell.bodyLabel?.text = bodyText
        imageCell.postImageView.image = postImage
        imageCell.timestampLabel.text = timestampText.toString()
        return imageCell
    }
  }
  
}
