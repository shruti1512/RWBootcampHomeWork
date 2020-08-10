//
//  ViewController.swift
//  Animations
//
//  Created by Shruti Sharma on 8/8/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  //MARK: - Properties
  
  var menuIsOpen = false
  var menuButtons: [CustomButton] = [CustomButton]()
  var scaleFactor: CGFloat = 4.0
  var rotateFactor: CGFloat = .pi
  var transform = CGAffineTransform.identity
  let centerXConstraintID = "Center X Constraint "
  let centerYConstraintID = "Center Y Constraint "
  let hedaerTopConstraintID = "Header Top Constraint"

  private lazy var animator: UIViewPropertyAnimator = {
    UIViewPropertyAnimator(duration: 2.0, curve: .easeInOut)
  }()
    
  private lazy var notificationHeader: UIView = {
    let header = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    header.backgroundColor = .lightGray
    header.layer.cornerRadius = 5
    header.translatesAutoresizingMaskIntoConstraints = false
    return header
  }()
  
  private lazy var notificationLabel: UILabel = {
    let label = UILabel()
    label.text = "Animation added successfully."
    label.textColor = .white
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  //TODO: - Make a reusable component for menu view 

  private lazy var menuView: UIView = {
    let menu = UIView()
    menu.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(menu)
    let safeArea = self.view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      menu.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      menu.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      menu.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      menu.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4)
    ])
    return menu
  }()
  
  private lazy var animationObject: UIImageView = {
    let spider = UIImageView(image: UIImage(named: "spider"))
    spider.translatesAutoresizingMaskIntoConstraints = false
    spider.contentMode = .scaleAspectFit
    return spider
  }()
  
  private lazy var background: UIImageView = {
    let spiderWeb = UIImageView(image: UIImage(named: "spider-web"))
    spiderWeb.translatesAutoresizingMaskIntoConstraints = false
    spiderWeb.contentMode = .scaleAspectFill
    return spiderWeb
  }()
  
  //MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBackground()
    setupAnimationObject()
    setupNotificationHeader()
    setupMenuViewButtons()
  }
  
  //MARK: - View Setup

    
  func setupNotificationHeader() {
    
    view.addSubview(notificationHeader)
    let topAnchor = notificationHeader.topAnchor.constraint(equalTo: view.topAnchor,
                                                            constant: -notificationHeader.frame.height)
    topAnchor.identifier = hedaerTopConstraintID
    NSLayoutConstraint.activate([
      topAnchor,
      notificationHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      notificationHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      notificationHeader.heightAnchor.constraint(equalToConstant: notificationHeader.frame.height)
    ])
    
    notificationHeader.addSubview(notificationLabel)
    NSLayoutConstraint.activate([
      notificationLabel.centerYAnchor.constraint(equalTo: notificationHeader.centerYAnchor),
      notificationLabel.centerXAnchor.constraint(equalTo: notificationHeader.centerXAnchor)
    ])
  }
  
  func setupBackground() {
    view.addSubview(background)
    NSLayoutConstraint.activate([
      background.topAnchor.constraint(equalTo: view.topAnchor),
      background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      background.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
    ])
  }
  
  func setupAnimationObject() {
        
    view.addSubview(animationObject)
    NSLayoutConstraint.activate([
      animationObject.centerXAnchor.constraint(equalTo: background.centerXAnchor),
      animationObject.centerYAnchor.constraint(equalTo: background.centerYAnchor),
      animationObject.widthAnchor.constraint(equalToConstant: 100),
      animationObject.heightAnchor.constraint(equalToConstant: 100)
    ])
  }
  
  //MARK: - Setup Menu Buttons

  func setupMenuViewButtons() {
    
    menuButtons = CustomButtonType.allCases.map {
      let button = getButton(forType :$0)
      addConstraintsToButton(button, forPosition: .center)
      return button
    }
  }
  
  func getButton(forType buttonType: CustomButtonType) -> CustomButton {
    
    let button = CustomButton(customButtonType: buttonType, withInitialPosition:
                              buttonType.initialPosition, withFinalPosition: buttonType.finalPosition)
    button.setBackgroundImage(buttonType.image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    menuView.addSubview(button)
    return button
  }
  
  func addConstraintsToButton(_ button: CustomButton, forPosition position: ButtonPosition)  {
        
    let centerXAnchor = button.centerXAnchor.constraint(equalTo: menuView.centerXAnchor)
    centerXAnchor.identifier = centerXConstraintID + (button.customButtonType?.rawValue)!

    let centerYAnchor = button.centerYAnchor.constraint(equalTo: menuView.centerYAnchor)
    centerYAnchor.identifier = centerYConstraintID + (button.customButtonType?.rawValue)!

    let widthAnchor: NSLayoutConstraint
    let heightAnchor: NSLayoutConstraint
    
    if button.customButtonType == .play {
      widthAnchor = button.widthAnchor.constraint(equalToConstant: 68)
    }
    else {
      widthAnchor = button.widthAnchor.constraint(equalToConstant: 50)
    }
    heightAnchor = button.heightAnchor.constraint(equalTo: button.widthAnchor)

    switch position {
      case .center:
        centerXAnchor.constant = 0
        centerYAnchor.constant = 0
        NSLayoutConstraint.activate([ centerXAnchor, centerYAnchor, widthAnchor, heightAnchor ])
      case .left:
        centerXAnchor.constant = -100
        centerYAnchor.constant = 0
        NSLayoutConstraint.activate([ centerXAnchor, centerYAnchor, widthAnchor, heightAnchor ])
      case .right:
        centerXAnchor.constant = 100
        centerYAnchor.constant = 0
        NSLayoutConstraint.activate([ centerXAnchor, centerYAnchor, widthAnchor, heightAnchor])
      case .top:
        centerXAnchor.constant = 0
        centerYAnchor.constant = -100
        NSLayoutConstraint.activate([ centerXAnchor, centerYAnchor, widthAnchor, heightAnchor ])
    }

  }
  
  //MARK: - Button Action Event

  @objc func buttonTapped(_ sender: CustomButton) {
    
    switch sender.customButtonType {
      case .play:
        animateMenu()
      case .scale:
        scaleObject()
      case .rotate:
        rotateObject()
      case .translate:
        translateObject()
      case .none:
        break
    }
  }
  
  //MARK: - Show Notification Header

  func showNotificationHeader() {

    guard let topConstraint = notificationHeader.superview!.constraints.first(where:
      { $0.identifier == hedaerTopConstraintID }) else {
      return
    }
    topConstraint.constant = notificationHeader.frame.height*2
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut,  animations: {
      self.view.layoutIfNeeded()
    }) { _ in
      self.hideNotificationHeader()
    }
  }
  
  //MARK: - Hide Notification Header

  func hideNotificationHeader() {

    guard let topConstraint = notificationHeader.superview!.constraints.first(where:
      { $0.identifier == hedaerTopConstraintID }) else {
      return
    }
    topConstraint.constant = -notificationHeader.frame.height*2
    UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  //MARK: - Scale Animation View

  @objc func scaleObject() {
    
    showNotificationHeader()
    transform = transform.scaledBy(x: scaleFactor, y: scaleFactor)
    self.scaleFactor = 1.0

    animator.addAnimations { [weak self] in
    guard let self = self else { return }
      self.animationObject.transform = self.transform
    }
  }
  
  //MARK: - Rotate Animation View

  @objc func rotateObject() {
    
    showNotificationHeader()
    transform = transform.rotated(by: rotateFactor)
    self.rotateFactor = 0

    animator.addAnimations {  [weak self] in
      guard let self = self else { return }
      self.animationObject.transform = self.transform
    }
  }
  
  //MARK: - Translate Animation View

  @objc func translateObject() {

    showNotificationHeader()
    transform = transform.translatedBy(x: 50.0, y: 50.0)
    animator.addAnimations { [weak self] in
      guard let self = self else { return }
      self.animationObject.transform = self.transform
    }
  }
  //MARK: - Animate Menu View Buttons
  
  @objc func animateMenu() {
          
    animator.addCompletion {  [weak self] _ in
      UIView.animate(withDuration: 2.0, animations: {
        guard let self = self else { return }
        self.scaleFactor = 4.0
        self.rotateFactor = .pi
        self.transform = .identity
        self.animationObject.transform = self.transform
      })
    }
    
    menuIsOpen.toggle()
        
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
      
      self.menuButtons.forEach {
        let centerXConstraintId = self.centerXConstraintID + ($0.customButtonType?.rawValue)!
        let centerYConstraintId = self.centerYConstraintID + ($0.customButtonType?.rawValue)!
        let centerXConstraint = $0.superview!.constraints.first { $0.identifier == centerXConstraintId }!
        let centerYConstraint = $0.superview!.constraints.first { $0.identifier == centerYConstraintId }!
        centerXConstraint.isActive = false
        centerYConstraint.isActive = false
        self.addConstraintsToButton($0, forPosition: self.menuIsOpen ? $0.finalPosition! : $0.initialPosition!)
      }
      self.view.layoutIfNeeded()
    }) { _ in
      self.menuIsOpen ? self.animator.stopAnimation(true) : self.animator.startAnimation()
    }
    
  }
  
}
