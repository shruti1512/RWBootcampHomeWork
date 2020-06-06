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
    
    @IBOutlet private weak var hitMeBtn: UIButton!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var displayText: UILabel!
    @IBOutlet private weak var targetLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var sliderMinLabel: UILabel!
    @IBOutlet weak var sliderMaxLabel: UILabel!
    
    //MARK: - Properties
    var gameModel: GameModel!
    let game = BullsEyeGame()
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
        
        textField.addTarget(self, action: #selector(textFielddDidChange(_:)), for: .editingChanged)
        
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

        displayText.text = gameModel.displayText
        sliderMinLabel.text = String(gameModel.minValue)
        sliderMaxLabel.text = String(gameModel.maxValue)

        if gameModel.type == .revBullsEye {
            textField.isHidden = false
            targetLabel.isHidden = true
            slider.isUserInteractionEnabled = false
        }
        else {
            textField.isHidden = true
            targetLabel.isHidden = false
            slider.isUserInteractionEnabled = true
        }
    }

    //MARK: - textFielddDidChange Methods

    @objc func textFielddDidChange(_ textField: UITextField) {
        
        guard let textFieldText = textField.text else {
            return
        }
        let passRange = gameModel.minValue...gameModel.maxValue
        if let textInputInt = Int(textFieldText), passRange.contains(textInputInt) {
            currentValue = textInputInt
            textField.backgroundColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
            hitMeBtn.isEnabled = true
        }
        else {
            textField.text = String(textFieldText.dropLast())
            if textFieldText.isEmpty {
                textField.backgroundColor = UIColor.white
                hitMeBtn.isEnabled = false
            }
        }
    }
    
    //MARK: - updateView Method

    func updateView() {
        if gameModel.type == .bullsEye {
            currentValue = 50
            slider.value = Float(currentValue)
            slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
        }
        else {
            currentValue = 0
            slider.value = Float(game.targetValue)
            textField.text = ""
            hitMeBtn.isEnabled = false
            textField.backgroundColor = UIColor.white
        }
      targetLabel.text = String(game.targetValue)
      scoreLabel.text = String(game.gameScore)
      roundLabel.text = String(game.round)
    }

    //MARK: - showAlertForScore Method

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

    //MARK: - Slider Moved Method

    @IBAction func sliderMoved(_ slider: UISlider) {
      currentValue = Int(slider.value.rounded())
      slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
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

}

