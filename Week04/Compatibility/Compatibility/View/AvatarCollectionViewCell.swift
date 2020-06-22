//
//  AvatarCollectionViewCell.swift
//  Compatibility
//
//  Created by Shruti Sharma on 6/19/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var checkMarkImgView: UIImageView!

  override var bounds: CGRect {
      didSet {
//        Use this method to force the view to update its layout immediately. When using Auto Layout, the layout engine updates the position of views as needed to satisfy changes in constraints. Using the view that receives the message as the root view, this method lays out the view subtree starting at the root.
          self.layoutIfNeeded()
      }
  }

//  When an object receives an awakeFromNib message, it is guaranteed to have all its outlet and action connections already established.
  override func awakeFromNib() {
      super.awakeFromNib()
      imgView.layer.masksToBounds = true
  }

//  The default implementation uses any constraints you have set to determine the size and position of any subviews.
//  Subclasses can override this method as needed to perform more precise layout of their subviews. You should override this method only if the autoresizing and constraint-based behaviors of the subviews do not offer the behavior you want. You can use your implementation to set the frame rectangles of your subviews directly.
  override func layoutSubviews() {
      super.layoutSubviews()
      setCircularImageView()
  }

  func setCircularImageView() {
    imgView.round()
  }

}
