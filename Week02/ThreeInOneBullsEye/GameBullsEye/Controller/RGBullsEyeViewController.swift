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
    
  //MARK: - IBOutlets

  @IBOutlet private weak var targetLabel: UILabel!
  @IBOutlet private weak var targetTextLabel: UILabel!
  @IBOutlet private weak var guessLabel: UILabel!
  
  @IBOutlet private weak var redSliderMinValueLbl: UILabel!
  @IBOutlet private weak var redSliderMaxValueLbl: UILabel!
  @IBOutlet private weak var greenSliderMinValueLbl: UILabel!
  @IBOutlet private weak var greenSliderMaxValueLbl: UILabel!
  @IBOutlet private weak var blueSliderMinValueLbl: UILabel!
  @IBOutlet private weak var blueSliderMaxValueLbl: UILabel!

  @IBOutlet private weak var redLabel: UILabel!
  @IBOutlet private weak var greenLabel: UILabel!
  @IBOutlet private weak var blueLabel: UILabel!
  
  @IBOutlet private weak var redSlider: UISlider!
  @IBOutlet private weak var greenSlider: UISlider!
  @IBOutlet private weak var blueSlider: UISlider!
  
  @IBOutlet private weak var roundLabel: UILabel!
  @IBOutlet private weak var scoreLabel: UILabel!
  
  //MARK: - Properties

  private var game: BullsEyeGame<RGB>!
  private var currentValue = RGB()
  var gameModel: GameModel! {
    didSet {
      game = BullsEyeGame<RGB>(targetRange: gameModel.minValue...gameModel.maxValue)
    }
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setupNvaigationItemView()
    setupView()

    game.startNewGame()
    updateView()
 }

  // MARK: - Intial Setup

  private func setupNvaigationItemView() {
       self.navigationItem.title = gameModel.name
       self.navigationController?.setNavigationBarHidden(false, animated: false)
       self.navigationItem.setHidesBackButton(true, animated: false);
  }
   
  private func setupView() {
      
      targetTextLabel.text = gameModel.promptText
      redSliderMinValueLbl.text = String(gameModel.minValue)
      redSliderMaxValueLbl.text = String(gameModel.maxValue)
      greenSliderMinValueLbl.text = String(gameModel.minValue)
      greenSliderMaxValueLbl.text = String(gameModel.maxValue)
      blueSliderMinValueLbl.text = String(gameModel.minValue)
      blueSliderMaxValueLbl.text = String(gameModel.maxValue)
  }

  //MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destinationVC = segue.destination as? InfoViewController {
          destinationVC.htmFile = gameModel.htmlFileName
      }
  }
    
  // MARK: - Show Alert Controller

  private func showAlertForScore() {
      
      var points = 0, alertTitle = ""
      let quickDiff = abs(game.targetValue - currentValue)
      switch quickDiff {
        case 0:
          alertTitle = ScoreConstants.perfectMatch
          points = ScoreConstants.perfectMatchBonus
            break
        case 1:
          points = ScoreConstants.closeMatchBonus
        case ..<5:
          alertTitle = ScoreConstants.closeMatch
            break
        case ..<10:
             alertTitle = ScoreConstants.goodMatch
            break
        default:
            alertTitle = ScoreConstants.noMatch
      }
      game.addBonus(points: points)

      let message = ScoreConstants.messagePart1  + String(game.roundScore) +  ScoreConstants.messagePart2
      let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: ScoreConstants.ok, style: .default, handler: {
        action in
          self.game.calculateGameScore()
          self.game.startNewRound()
          self.updateView()
      })
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
  }

  // MARK: - Update View

  private func updateView() {
    currentValue = RGB(r: gameModel.defaultValue, g: gameModel.defaultValue, b: gameModel.defaultValue)
    redSlider.value = Float(currentValue.r)
    greenSlider.value = Float(currentValue.g)
    blueSlider.value = Float(currentValue.b)
    targetLabel.backgroundColor = UIColor(rgbStruct: game.targetValue)
    scoreLabel.text = LabelConstants.scoreText + String(game.gameScore)
    roundLabel.text = LabelConstants.roundText + String(game.round)
    updateGuessView()
  }

  private func updateGuessView() {
    guessLabel.backgroundColor = UIColor(rgbStruct: currentValue)
    redLabel.text = String(currentValue.r)
    greenLabel.text = String(currentValue.g)
    blueLabel.text = String(currentValue.b)
  }
    
  // MARK: - IBActions
  
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
    
  @IBAction func backToMainBtnPressed(sender: AnyObject) {
      self.navigationController?.popViewController(animated: true)
  }
    
  @IBAction func hitMeBtnPressed() {
    game.calculateRoundScore(for: currentValue)
    showAlertForScore()
  }

}


