//
//  ViewController.swift
//  CompatibilitySlider-Start
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  //MARK: - IBOutlets
  
    @IBOutlet private weak var compatibilityItemLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var emojiBtns: [UIButton]!
      
  //MARK: - Instance Properties

    var compatibilityItems = ["Cats", "Dogs", "Nature", "Travel"] // Add more!
    var currentItemIndex = 0 {
      didSet {
        compatibilityItemLabel.text = compatibilityItems[currentItemIndex]
      }
    }
    
    var sliderSlice: Float = 0
    var person1 = Person(id: 1, items: [:])
    var person2 = Person(id: 2, items: [:])
    var currentPerson: Person? {
      didSet {
        let personName = "Person" + String(currentPerson!.id)
        let quesText = ", what do you think about..."
        questionLabel.text = personName + quesText
      }
    }

  //MARK: - ViewController Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()
      sliderSlice = slider.maximumValue / Float(emojiBtns.count)
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
            showAlertForCompatibility()
         }
         else {
          startGameForPerson(person: person2)
        }
      }
      else {
        currentItemIndex += 1
      }
    }

  //MARK: - Game Logic

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
  
    func calculateCompatibility() -> String {
        var percentagesForAllItems: [Double] = []
        for (key, person1Rating) in person1.items {
            let person2Rating = person2.items[key] ?? 0
            let difference = abs(person1Rating - person2Rating)/5.0
            percentagesForAllItems.append(Double(difference))
        }

        let sumOfAllPercentages = percentagesForAllItems.reduce(0, +)
        let matchPercentage = sumOfAllPercentages/Double(compatibilityItems.count)
//        print("matchPercentage: \(matchPercentage)")
        let matchDouble = 100 - (matchPercentage * 100).rounded()
//        print("matchDouble: \(matchDouble)")
        let formatter = NumberFormatter()
        let matchString = formatter.cleanNumberString(from: matchDouble as NSNumber) + "%"
//        print("matchString: \(matchString)")
        return matchString
    }

    
  //MARK: - Show Alert For Score

    func showAlertForCompatibility() {
      let score = calculateCompatibility()
      let alert = UIAlertController(title: "Results", message: "You two are \(score) compatible.", preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default) { [weak self] action in
        guard let self = self else {
          return
        }
        self.startGameForPerson(person: self.person1)
      }
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
  
}


