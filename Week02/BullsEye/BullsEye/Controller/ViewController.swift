//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var game = BullsEyeGame()
  var currentValue = 50
  var quickDiff: Int {
      return abs(game.targetValue - currentValue)
  }
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUIControls()
    game.startNewGame()
    updateView()
  }

func setupUIControls() {
    
    let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
    slider.setThumbImage(thumbImageNormal, for: .normal)
    
    let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
    slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
    
    let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    
    let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
    let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
    slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
    
    let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
    let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
    slider.setMaximumTrackImage(trackRightResizable, for: .normal)
}
    
  @IBAction func hitMeBtnPressed() {
    
    game.calculateRoundScore(for: currentValue)
    showAlertForScore()
  }
  
func showAlertForScore() {
    
    var points = 0
    var alertTitle = ""
    switch quickDiff {
    case 0:
         alertTitle = "Perfect!"
         points = 100
        break
    case 1:
        points = 50
      alertTitle = "You almost had it!"
      break
    case ..<5:
         alertTitle = "You almost had it!"
        break
    case ..<10:
         alertTitle = "Pretty good!"
        break
    default:
        alertTitle = "Not even close..."
    }
    
    game.addBonus(points: points)

    let message = "You scored \(game.roundScore) points"
    let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
        self.game.calculateGameScore()
        self.game.startNewRound()
        self.updateView()
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
}
       
  @IBAction func sliderMoved(_ slider: UISlider) {
    currentValue = Int(slider.value.rounded())
    slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
  }
    
  func updateView() {
    currentValue = 50
    slider.value = Float(currentValue)
    targetLabel.text = String(game.targetValue)
    scoreLabel.text = String(game.gameScore)
    roundLabel.text = String(game.round)
    slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
  }
  
  @IBAction func resetBtnPressed() {
    game.startNewGame()
    updateView()
  }
      
}



