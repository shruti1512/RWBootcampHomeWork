//
//  ViewController.swift
//  Compatibility
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

  //MARK: - IBOutlets
  
  @IBOutlet private weak var compatibilityItemLabel: UILabel!
  @IBOutlet private weak var slider: UISlider!
  @IBOutlet private weak var questionLabel: UILabel!
  @IBOutlet private var emojiBtns: [UIButton]!
  @IBOutlet private var profileImgView: UIImageView!
  var compatibility: ComptibilityLogic!

//MARK: - Properties
  var compatibilityItems = ["Cats", "Dogs", "Nature", "Travel"]
  var currentItemIndex = 0 {
    didSet {
      compatibilityItemLabel.text = compatibilityItems[currentItemIndex]
    }
  }
  
  var person1Image: String!
  var person2Image: String!

  var sliderSlice: Float = 0
  var person1: Person!
  var person2: Person!
  var currentPerson: Person? {
    didSet {
      profileImgView.image = UIImage(named: currentPerson!.profileImage)
    }
  }

  //MARK: - ViewController Lifecycle Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupModels()
 }
  
  func setupView() {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    profileImgView.round()
  }
  
  func setupModels() {
    sliderSlice = slider.maximumValue / Float(emojiBtns.count)
    person1 = Person(id: 1, profileImage: person1Image, items: [:])
    person2 = Person(id: 2, profileImage: person2Image, items: [:])
    compatibility = ComptibilityLogic(person1: person1, person2: person2, compatibilityItems: compatibilityItems)
    startGameForPerson(person: person1)
  }
  
  //MARK: - IBActions

    @IBAction func sliderValueChanged(_ sender: UISlider) {
      let index = Int((slider.value/sliderSlice).rounded()) - 1
      let indexClamped = (0 ... emojiBtns.count-1).clamp(value: index)
      let emojiBtn = emojiBtns[indexClamped]
      scaleEmojiBtn(emojiBtn)
    }
  
    @IBAction func emojiTapped(_ sender: UIButton) {
      if let index = emojiBtns.firstIndex(of: sender) {
        slider.value = Float(index+1) * sliderSlice
        scaleEmojiBtn(sender)
      }
    }
  
    @IBAction func didPressNextItemButton(_ sender: Any) {
            
      if currentItemIndex < compatibilityItems.count {
        let score = slider.value
        let item = compatibilityItems[currentItemIndex]
        currentPerson!.items.updateValue(score, forKey: item)
      }

      if currentItemIndex == compatibilityItems.count-1 {
         if currentPerson == person2 {
            showAlertForCompatibilityResults()
         }
         else {
          showAlertForPerson2Turn()
        }
      }
      else {
        currentItemIndex += 1
      }
    }

  //MARK: - Game Logic Methods

    func scaleEmojiBtn(_ emoji: UIButton) {
      emojiBtns.forEach{ $0.transform = CGAffineTransform.identity }
      emoji.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }

    func startGameForPerson(person: Person) {
      self.currentPerson = person
      self.slider.value = 0.5
      sliderValueChanged(slider)
      self.currentItemIndex = 0
    }
  
    
  //MARK: - Show Compatibilty Result Alert Method

    func showAlertForCompatibilityResults() {
      
      guard let score = compatibility.calculateCompatibilityScore() else { return }

      let alertService = AlertService()
      let alertVC = alertService.alert(title: "Compatibility",
                                       body: "\(score)",
                                       imageLeft: person1Image,
                                       imageRight: person2Image,
                                       actionButtonTitle: "Start new match",
                                       dismissButtonTitle: "Cancel") { [weak self] in
                                          if let self = self {
                                            self.navigationController?.popToRootViewController(animated: true)
                                          }
                                      }
      present(alertVC, animated: true)
    }
  
    func showAlertForPerson2Turn() {

      let alertService = AlertService()
      let alertVC = alertService.alert(title: "Thanks!",
                                       body: "Now its your friend's turn.",
                                       imageLeft: person2Image,
                                       imageRight: nil,
                                       actionButtonTitle: "Continue",
                                       dismissButtonTitle: nil) { [weak self] in
          if let self = self {
            self.startGameForPerson(person: self.person2)
          }
      }
      present(alertVC, animated: true)
    }

  
}


