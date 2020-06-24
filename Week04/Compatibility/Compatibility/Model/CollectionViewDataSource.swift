//
//  CollectionViewDataSource.swift
//  Compatibility
//
//  Created by Shruti Sharma on 6/19/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource
{
  var models = [String]()
  private var reuseIdentifier: String!

  init(models: [String], reuseIdentifier: String) {
    self.models = models
    self.reuseIdentifier = reuseIdentifier
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return models.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                        for: indexPath) as? AvatarCollectionViewCell else {
        fatalError("can't dequeue CustomCell")
    }
    configureCell(cell, for: indexPath)
    return cell
  }
  
  func configureCell(_ cell: AvatarCollectionViewCell, for indexPath: IndexPath) {
    cell.imgView.image = UIImage(named: models[indexPath.row])
    cell.checkMarkImgView.isHidden = true
    cell.alpha = 1.0
    cell.isUserInteractionEnabled = true
  }
  
}
