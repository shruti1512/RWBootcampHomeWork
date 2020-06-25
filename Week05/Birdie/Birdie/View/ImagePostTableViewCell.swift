//
//  ImagePostTableViewCell.swift
//  Birdie
//
//  Created by Shruti Sharma on 6/23/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ImagePostTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var userProfileImgView: UIImageView!

  override func awakeFromNib() {
      super.awakeFromNib()
      postImageView.roundWithCornerRadius(8.0)
  }

}
