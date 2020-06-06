//
//  RGBullsEyeViewController.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/5/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

import UIKit

class RGBullsEyeViewController: UIViewController {
    
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var targetTextLabel: UILabel!
  @IBOutlet weak var guessLabel: UILabel!
  
@IBOutlet weak var redSliderMinValueLbl: UILabel!
@IBOutlet weak var redSliderMaxValueLbl: UILabel!
@IBOutlet weak var greenSliderMinValueLbl: UILabel!
@IBOutlet weak var greenSliderMaxValueLbl: UILabel!
@IBOutlet weak var blueSliderMinValueLbl: UILabel!
@IBOutlet weak var blueSliderMaxValueLbl: UILabel!

  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  let game = RGBGameLogic()
  var currentValue = RGB()
  var gameModel: GameModel!
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setupNvaigationItemView()
    setupView()

    game.startNewGame()
    updateView()
  }

  func setupNvaigationItemView() {
       self.navigationItem.title = gameModel.name
       self.navigationController?.setNavigationBarHidden(false, animated: false)
       self.navigationItem.setHidesBackButton(true, animated: false);
  }
    
func setupView() {
    
    targetTextLabel.text = gameModel.displayText
    redSliderMinValueLbl.text = String(gameModel.minValue)
    redSliderMaxValueLbl.text = String(gameModel.maxValue)
    greenSliderMinValueLbl.text = String(gameModel.minValue)
    greenSliderMaxValueLbl.text = String(gameModel.maxValue)
    blueSliderMinValueLbl.text = String(gameModel.minValue)
    blueSliderMaxValueLbl.text = String(gameModel.maxValue)
}

  @IBAction func hitMeBtnPressed() {
        
    game.calculateRoundScore(for: currentValue)
    showAlertForScore()
  }
      
func showAlertForScore() {
    
    let difference = 100 - game.roundScore
    var points = 0
    var alertTitle = ""
    switch difference {
    case 0:
         alertTitle = "Perfect!"
         points = 100
        break
    case 1:
        alertTitle = "You almost had it!"
        points = 50
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

  func updateView() {
    currentValue = RGB(r: 127, g: 127, b: 127)
    redSlider.value = Float(currentValue.r)
    greenSlider.value = Float(currentValue.g)
    blueSlider.value = Float(currentValue.b)
    targetLabel.backgroundColor = UIColor(rgbStruct: game.targetValue)
    scoreLabel.text = "Score: " + String(game.gameScore)
    roundLabel.text = "Round: " + String(game.round)
    updateGuessView()
  }

  func updateGuessView() {
    guessLabel.backgroundColor = UIColor(rgbStruct: currentValue)
    redLabel.text = String(currentValue.r)
    greenLabel.text = String(currentValue.g)
    blueLabel.text = String(currentValue.b)
  }
    
  @IBAction func aSliderMoved(sender: UISlider) {
    if sender == redSlider {
        currentValue.r = Int(redSlider.value.rounded())
    }
    else if sender == greenSlider {
        currentValue.g = Int(greenSlider.value.rounded())
    }
    else if sender == blueSlider {
        currentValue.b = Int(blueSlider.value.rounded())
    }
    updateGuessView()
  }
  
  @IBAction func hiteMeBtnPressed(sender: AnyObject) {
    game.calculateRoundScore(for: currentValue)
    showAlertForScore()
  }
  
  @IBAction func startOver(sender: AnyObject) {
    game.startNewGame()
    updateView()
  }
    
}


