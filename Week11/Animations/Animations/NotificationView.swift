//
//  NotificationView.swift
//  Animations
//
//  Created by Shruti Sharma on 8/10/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class NotificationView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    backgroundColor = .systemGray6
    layer.cornerRadius = 5
    addNotificationLabel()
    addCheckmarkImageView()
  }
  
  private func addNotificationLabel() {
    addSubview(notificationLabel)
    notificationLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      notificationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      notificationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }
  
  private func addCheckmarkImageView() {
    addSubview(checkMarkImageView)
    checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkMarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      checkMarkImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
    ])
  }
  
  private lazy var notificationLabel: UILabel = {
    let label = UILabel()
    label.text = "Animation added successfully."
    label.textColor = .darkGray
    label.backgroundColor = .clear
    return label
  }()
  
  private lazy var checkMarkImageView: UIImageView = {
    let checkMark = UIImageView()
    checkMark.image = UIImage(systemName: "checkmark.circle.fill")
    checkMark.tintColor = .green
    return checkMark
  }()


}
