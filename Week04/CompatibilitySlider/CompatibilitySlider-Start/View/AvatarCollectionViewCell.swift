//
//  AvatarCollectionViewCell.swift
//  CompatibilitySlider-Start
//
//  Created by Shruti Sharma on 6/19/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var checkMarkImgView: UIImageView!

  override var bounds: CGRect {
      didSet {
          self.layoutIfNeeded()
      }
  }

  override func awakeFromNib() {
      super.awakeFromNib()
      self.imgView.layer.masksToBounds = true
  }

  override func layoutSubviews() {
      super.layoutSubviews()
      setCircularImageView()
  }

  func setCircularImageView() {
    imgView.round()
  }

}
