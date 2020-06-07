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
    var gameModel: GameModel!
    let game = BullsEyeGameLogic()
    var currentValue = 0
    var quickDiff: Int {
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

    func setupNvaigationItemView() {
        self.navigationItem.title = gameModel.name
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false);
    }
    
    func setupView() {
        
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
    
    func setupViewForGameType(type: GameType) {
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

    func updateView() {
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
      scoreLabel.text = "Score: " + String(game.gameScore)
      roundLabel.text = "Round: " + String(game.round)
      updateSliderContainerColor(to: UIColor.white)
      updateUserHelpView(color: UIColor.clear, text: "")
    }

    func updateUserHelpView(color: UIColor, text: String) {
        userHelpView.backgroundColor = color
        userHelpLabel.text = text
    }

    func updateSliderContainerColor(to color: UIColor) {
        sliderContainerView.backgroundColor = color
    }
    
    //MARK: - showAlertForScore Method

    func showAlertForScore() {
        
        let difference = gameModel.maxValue - game.roundScore
        var points = 0, alertTitle = ""
        switch difference {
        case 0:
             alertTitle = "Perfect!"
             points = 100
            break
        case 1:
            alertTitle = "You almost had it!"
            points = 50
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
//            print("targetValue: \(game.targetValue)")
//            print("quickDiff: \(quickDiff)")
            let val = CGFloat(Double(quickDiff)/50.0)
            let helpColor = UIColor(red: 1.0-val, green: 0.0, blue: val, alpha: 1.0)
            var helpText = ""
            switch currentValue {
            case game.targetValue-10...game.targetValue+10:
                helpText = "Warmer"
                break
            case game.targetValue-20...game.targetValue+20:
                helpText = "Warm"
                break
            case game.targetValue-30...game.targetValue+30:
                helpText = "Colder"
                 break
            default:
                helpText = "Colder"
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
    
}

