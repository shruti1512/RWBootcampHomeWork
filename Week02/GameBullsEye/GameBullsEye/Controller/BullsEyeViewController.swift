//
//  BullsEyeViewController.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/5/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class BullsEyeViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet private weak var userHelpView: UIView!
    @IBOutlet private weak var userHelpLabel: UILabel!
    @IBOutlet private weak var hitMeBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var promptLabel: UILabel!
    @IBOutlet private weak var targetLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var sliderMinLabel: UILabel!
    @IBOutlet weak var sliderMaxLabel: UILabel!
    @IBOutlet weak var sliderContainerView: UIView!

    //MARK: - Properties
    var gameModel: GameModel! {
      didSet {
        game = BullsEyeGame<Int>(targetRange: gameModel.minValue...gameModel.maxValue)
      }
    }
    private var game: BullsEyeGame<Int>!
    private var currentValue = 0
    private var quickDiff: Int {
        return abs(game.targetValue - currentValue)
    }

    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNvaigationItemView()
        setupView()
        game.startNewGame()
        updateView()
    }
    
    //MARK: - Setup View Methods

    private func setupNvaigationItemView() {
        self.navigationItem.title = gameModel.name
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false);
    }
    
    private func setupView() {
        
        sliderContainerView.addCornerRadius(cornerRadius: 5.0)
        
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
        
        promptLabel.text = gameModel.promptText
        sliderMinLabel.text = String(gameModel.minValue)
        sliderMaxLabel.text = String(gameModel.maxValue)

        setupViewForGameType(type: gameModel.type)
    }
    
    private func setupViewForGameType(type: GameType) {
        if type == .bullsEye {
            textField.isHidden = true
            targetLabel.isHidden = false
            slider.isUserInteractionEnabled = true
            userHelpView.isHidden = true
        }
        else if type == .revBullsEye {
            textField.isHidden = false
            targetLabel.isHidden = true
            slider.isUserInteractionEnabled = false
            userHelpView.isHidden = false
        }
    }
    
    //MARK: - updateView Method

    private func updateView() {
        currentValue = gameModel.defaultValue
        if gameModel.type == .bullsEye {
            slider.value = Float(currentValue)
        }
        else {
            slider.value = Float(game.targetValue)
            textField.text = ""
            hitMeBtn.isEnabled = false
        }
      targetLabel.text = String(game.targetValue)
      scoreLabel.text = LabelConstants.scoreText + String(game.gameScore)
      roundLabel.text = LabelConstants.roundText + String(game.round)
      updateSliderContainerColor(to: UIColor.clear)
      updateUserHelpView(color: UIColor.clear, text: "")
    }

    private func updateUserHelpView(color: UIColor, text: String) {
        userHelpView.backgroundColor = color
        userHelpLabel.text = text
    }

    private func updateSliderContainerColor(to color: UIColor) {
        sliderContainerView.backgroundColor = color
    }
    
    //MARK: - showAlertForScore Method

    private func showAlertForScore() {
        
        var points = 0, alertTitle = ""
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


    //MARK: - Slider Moved Method

    @IBAction func sliderMoved(_ slider: UISlider) {
      currentValue = Int(slider.value.rounded())
      let val = CGFloat(Double(quickDiff)/50.0)
      updateSliderContainerColor(to: UIColor(red: 1.0-val, green: 0.0, blue: val, alpha: 1.0))
    }
          
    //MARK: - ResetBtnPressed Method

    @IBAction func resetBtnPressed() {
      game.startNewGame()
      updateView()
    }

    //MARK: - Go Back To Main View Method

    @IBAction func goBackBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - HitMeBtnPressed Method

    @IBAction func hitMeBtnPressed() {
      game.calculateRoundScore(for: currentValue)
      showAlertForScore()
    }

    @IBAction func textFieldEditingChanged() {
        
        guard let text = textField.text else { return }
        
        let passRange = gameModel.minValue...gameModel.maxValue
        if let textInputInt = Int(text), passRange.contains(textInputInt) {
            currentValue = textInputInt
            let val = CGFloat(Double(quickDiff)/50.0)
            let helpColor = UIColor(red: 1.0-val, green: 0.0, blue: val, alpha: 1.0)
            var helpText = ""
            switch quickDiff {
            case ...10:
               helpText = UserHelpViewConstants.warmerText
                break
            case ...20:
                helpText = UserHelpViewConstants.warmText
                break
            case ...30:
              helpText = UserHelpViewConstants.coldText
                 break
            default:
                helpText = UserHelpViewConstants.colderText
            }
            updateUserHelpView(color: helpColor, text: helpText)
            hitMeBtn.isEnabled = true
        }
        else {
            textField.text = String(text.dropLast())
            if text.isEmpty {
                updateUserHelpView(color: UIColor.clear, text: "")
                hitMeBtn.isEnabled = false
            }
        }
    }
  
  @IBAction func tapGestureEventSent(_ sender: Any) {
    textField.resignFirstResponder()
  }
  
}

