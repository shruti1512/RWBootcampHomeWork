//
//  GameViewController.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/6/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var alertTitle: String!
    typealias CompletionHandler = () -> ()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupNavigationItemView(with title: String) {
        self.navigationItem.title = title
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false);
    }
    
    func setupSliders(sliders: [UISlider]) {
        
        sliders.forEach { slider in
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
    }
    
    //TO DO: Set min and max labels for all sliders
    func setupSliderLabels(sliderLabels: [UILabel], numbers:[Int]) {
      for (index, sliderLbl) in sliderLabels.enumerated() {
        sliderLbl.text = String(numbers[index])
      }
    }
    
    func calculateBonusPoints(for maxValue:Int, roundScore: Int) -> Int {
        
        let difference = maxValue - roundScore
        var points = 0
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
        return points
    }
    
      func showAlertScore(for score:Int, completionHandler: @escaping CompletionHandler) {
        
        let message = ScoreAlertConstants.messagePart1  + String(score) +  ScoreAlertConstants.messagePart2

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: ScoreAlertConstants.ok, style: .default, handler: {
          action in
            completionHandler()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
   func updateLabels(targetLbl: UILabel, targetText: String,
                            scoreLbl: UILabel, scoreText: String,
                            roundLbl: UILabel, roundText: String) {
    targetLbl.text = targetText
    scoreLbl.text = scoreText
    roundLbl.text = roundText
  }

  
  //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? InfoViewController {
            destinationVC.htmFile = gameModel.htmlFileName
        }
    }

}
