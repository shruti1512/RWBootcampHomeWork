//
//  ClueTableViewCell.swift
//  jQuiz
//
//  Created by Shruti Sharma on 7/23/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

//MARK: - ClueTableViewCellDelegate

protocol ClueTableViewCellDelegate: class {
  func clueButtonTapped(_ : ClueTableViewCell)
}

class ClueTableViewCell: UITableViewCell {
  
  //MARK: - Properties

  static let reuseIdentifier = String(describing: ClueTableViewCell.self)
  static let nib = String(describing: ClueTableViewCell.self)
  weak var delegate: ClueTableViewCellDelegate?
  
  //MARK: - IBOutlets

  @IBOutlet weak var clueTitleButton: UIButton! {
    didSet {
      clueTitleButton.titleLabel?.adjustsFontSizeToFitWidth = true
      clueTitleButton.titleLabel?.numberOfLines = 0
    }
  }
  
  //MARK: - IBAction

  @IBAction private func buttonTapped(_ sender: Any) {
    delegate?.clueButtonTapped(self)
  }
  
  //MARK: - Public Methods

  public func updateForWrongAnswer() {
    clueTitleButton.backgroundColor = UIColor.red.withAlphaComponent(0.8)
  }
  
  public func animateForCorrectAnswer() {
    clueTitleButton.flash()
    clueTitleButton.backgroundColor = UIColor(red: 28/255, green: 179/255, blue: 82/255, alpha: 0.8)
  }
  
  public func refresh() {
    clueTitleButton.backgroundColor = UIColor(red: 173/255, green: 69/255, blue: 185/255, alpha: 0.8)
  }

}
