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
  var isScaled = false
  var scaleFactor: CGFloat = 4.0
  var rotateFactor: CGFloat = .pi
  var transform = CGAffineTransform.identity
  let centerXConstraintID = "Menu Button Center X Constraint "
  let menuButtonBottomConstraintID = "Menu Button Bottom Constraint "
  let hedaerTopConstraintID = "Header Top Constraint"

  private lazy var animator: UIViewPropertyAnimator = {
    UIViewPropertyAnimator(duration: 2.0, curve: .easeInOut)
  }()
    
  private lazy var notificationView: NotificationView = {
    let notification = NotificationView(frame: .zero)
    notification.translatesAutoresizingMaskIntoConstraints = false
    return notification
  }()
  
  //TODO: - Make a reusable component for menu view for future projects

  private lazy var menuView: UIView = {
    let menu = UIView()
    menu.translatesAutoresizingMaskIntoConstraints = false
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
    setupViews()
  }
  
  //MARK: - View Setup

  func setupViews() {
    addBackground()
    addMenuView()
    addAnimationObject()
    addNotificationView()
    addMenuViewButtons()
  }
  
  func addMenuView() {
    view.addSubview(menuView)
    let safeArea = self.view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      menuView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      menuView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      menuView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      menuView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4)
    ])
  }
  
  func addNotificationView() {
    
    view.addSubview(notificationView)
    let notifcationHeight: CGFloat = 40
    let topAnchor = notificationView.topAnchor.constraint(equalTo: view.topAnchor,
                                                            constant: -notifcationHeight)
    topAnchor.identifier = hedaerTopConstraintID
    NSLayoutConstraint.activate([
      topAnchor,
      notificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      notificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      notificationView.heightAnchor.constraint(equalToConstant: notifcationHeight)
    ])
  }
  
  func addBackground() {
    view.addSubview(background)
    NSLayoutConstraint.activate([
      background.topAnchor.constraint(equalTo: view.topAnchor),
      background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      background.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
    ])
  }
  
  func addAnimationObject() {
        
    view.addSubview(animationObject)
    NSLayoutConstraint.activate([
      animationObject.centerXAnchor.constraint(equalTo: background.centerXAnchor),
      animationObject.centerYAnchor.constraint(equalTo: background.centerYAnchor),
      animationObject.widthAnchor.constraint(equalToConstant: 100),
      animationObject.heightAnchor.constraint(equalToConstant: 100)
    ])
  }
  
  //MARK: - Setup Menu Buttons

  func addMenuViewButtons() {
    
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

    let bottomAnchor = button.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: -20)
    bottomAnchor.identifier = menuButtonBottomConstraintID + (button.customButtonType?.rawValue)! 

    let widthAnchor: NSLayoutConstraint
    let heightAnchor: NSLayoutConstraint
    
    if button.customButtonType == .play {
      widthAnchor = button.widthAnchor.constraint(equalToConstant: 56)
    }
    else {
      widthAnchor = button.widthAnchor.constraint(equalToConstant: 50)
    }
    heightAnchor = button.heightAnchor.constraint(equalTo: button.widthAnchor)

    switch position {
      case .center:
        centerXAnchor.constant = 0
        NSLayoutConstraint.activate([ centerXAnchor, bottomAnchor, widthAnchor, heightAnchor ])
      case .left:
        centerXAnchor.constant = -100
        NSLayoutConstraint.activate([ centerXAnchor, bottomAnchor, widthAnchor, heightAnchor ])
      case .right:
        centerXAnchor.constant = 100
        NSLayoutConstraint.activate([ centerXAnchor, bottomAnchor, widthAnchor, heightAnchor])
      case .top:
        centerXAnchor.constant = 0
        bottomAnchor.constant = -100
        NSLayoutConstraint.activate([ centerXAnchor, bottomAnchor, widthAnchor, heightAnchor ])
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

  func showNotificationView() {

    guard let topConstraint = notificationView.superview!.constraints.first(where:
      { $0.identifier == hedaerTopConstraintID }) else {
      return
    }
    topConstraint.constant = notificationView.frame.height*2
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut,  animations: {
      self.view.layoutIfNeeded()
    }) { _ in
      self.hideNotificationView()
    }
  }
  
  //MARK: - Hide Notification Header

  func hideNotificationView() {

    guard let topConstraint = notificationView.superview!.constraints.first(where:
      { $0.identifier == hedaerTopConstraintID }) else {
      return
    }
    topConstraint.constant = -notificationView.frame.height*2
    UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  //MARK: - Scale Animation View

  @objc func scaleObject() {
    
    isScaled = true
    showNotificationView()
    transform = transform.scaledBy(x: scaleFactor, y: scaleFactor)
    self.scaleFactor = 1.0

    animator.addAnimations { [weak self] in
    guard let self = self else { return }
      self.animationObject.transform = self.transform
    }
  }
  
  //MARK: - Rotate Animation View

  @objc func rotateObject() {
    
    showNotificationView()
    transform = transform.rotated(by: rotateFactor)
    self.rotateFactor = 0

    animator.addAnimations {  [weak self] in
      guard let self = self else { return }
      self.animationObject.transform = self.transform
    }
  }
  
  //MARK: - Translate Animation View

  @objc func translateObject() {

    showNotificationView()
    transform = transform.translatedBy(x: 0.0, y: isScaled ? 50.0 : 200.0)
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
        self.isScaled = false
      })
    }
    
    menuIsOpen.toggle()
        
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
      
      self.menuButtons.forEach {
        let centerXConstraintId = self.centerXConstraintID + ($0.customButtonType?.rawValue)!
        let centerYConstraintId = self.menuButtonBottomConstraintID + ($0.customButtonType?.rawValue)!
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
