//
//  RestaurantTableViewCell.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/12/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit
import Cosmos

class RestaurantTableViewCell: UITableViewCell {

  //MARK: - Properties

  static let reuseIdentifier = String(describing: RestaurantTableViewCell.self)
  
  lazy var nameLbl: UILabel = {
    let label = UILabel(frame: .zero)
    label.textColor = Colors.themeColor
    label.font = UIFont(name: "Arial Rounded MT Bold", size: 22.0)
    return label
  }()
  
  lazy var addressLbl: UILabel = {
    let label = UILabel(frame: .zero)
    label.textColor = UIColor(red: 93/255, green: 98/255, blue: 98/255, alpha: 1.0)
    label.font = UIFont(name: "Arial", size: 18.0)
    return label
  }()

  lazy var ratingLbl: UILabel = {
    let label = UILabel(frame: .zero)
    label.textColor = UIColor(red: 93/255, green: 98/255, blue: 98/255, alpha: 1.0)
    label.font = UIFont(name: "Arial", size: 18.0)
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    return label
  }()
  
  lazy var captionLbl: UILabel = {
    let label = UILabel(frame: .zero)
    label.textColor = UIColor(red: 93/255, green: 98/255, blue: 98/255, alpha: 1.0)
    label.font = UIFont(name: "Arial", size: 18.0)
    return label
  }()

  lazy var ratingView: CosmosView = {
    let cosmosView = CosmosView(frame: .zero)
    cosmosView.settings.starSize = 30
    cosmosView.contentMode = .scaleToFill
    cosmosView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return cosmosView
  }()
  
  lazy var cardView: CardView = {
    let view = CardView(frame: .zero)
    view.clipsToBounds = false
    return view
  }()

  //MARK: - Intializer
  
  private lazy var ratingStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [self.ratingLbl, self.ratingView])
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 8
    return stackView
  }()
  
  private lazy var parentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [self.nameLbl, self.addressLbl, self.ratingStackView, self.captionLbl])
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 10
    return stackView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupViews()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    
    addSubview(cardView)
    cardView.addSubview(parentStackView)
  }
  
  private func setupLayout() {
        
    cardView.anchor(top: layoutMarginsGuide.topAnchor,
                    leading: layoutMarginsGuide.leadingAnchor,
                    bottom: layoutMarginsGuide.bottomAnchor,
                    trailing: layoutMarginsGuide.trailingAnchor)
    
    parentStackView.anchor(top: cardView.topAnchor,
                           leading: cardView.leadingAnchor,
                           bottom: cardView.bottomAnchor,
                           trailing: cardView.trailingAnchor,
                           padding: cardView.layoutMargins)
  }
  
}
