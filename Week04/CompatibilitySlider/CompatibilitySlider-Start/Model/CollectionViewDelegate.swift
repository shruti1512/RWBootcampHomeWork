//
//  CollectionViewDelegate.swift
//  CompatibilitySlider-Start
//
//  Created by Shruti Sharma on 6/19/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDelegate: NSObject, UICollectionViewDelegate {
  
  typealias Completion = (String, String) -> Void
  
  private var completion: Completion!
  private var dataSourceArray: [String]!
  private var interCellSpacing: CGFloat!
  private var person1Image, person2Image: String!
  private let sectionInsets: UIEdgeInsets!
  private let itemsPerRow: Int!

  //MARK: - Initial Setup

  init(dataSourceArray: [String], sectionInsets: UIEdgeInsets, itemsPerRow: Int, completion: @escaping Completion) {
    self.dataSourceArray = dataSourceArray
    self.itemsPerRow = itemsPerRow
    self.sectionInsets = sectionInsets
    self.completion = completion
  }

  func refresh() {
    person1Image = nil
    person2Image = nil
  }

  //MARK: - UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let _ = person1Image {
      person2Image = dataSourceArray[indexPath.row]
      completion(person1Image, person2Image)
    }
    else {
      person1Image = dataSourceArray[indexPath.row]
    }
    if let cell = collectionView.cellForItem(at: indexPath) as? AvatarCollectionViewCell {
      cell.checkMarkImgView.isHidden = false
      cell.isUserInteractionEnabled = false
    }
  }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewDelegate: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
      let paddingSpace = sectionInsets.left * (CGFloat(itemsPerRow) + 1)
      let availableWidth = collectionView.bounds.width - paddingSpace
      let widthPerItem = availableWidth / CGFloat(itemsPerRow)
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }


}
