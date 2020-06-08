/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var targetTextLabel: UILabel!
  @IBOutlet weak var guessLabel: UILabel!
  
  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  var game = BullsEyeGame<RGB>(targetRange: 0...255)
  var currentValue = RGB(r: 127, g: 127, b: 127) {
    didSet {
        guessLabel.backgroundColor = UIColor(rgbStruct: currentValue)
        redLabel.text = String(currentValue.r)
        greenLabel.text = String(currentValue.g)
        blueLabel.text = String(currentValue.b)
        redSlider.value = Float(currentValue.r)
        greenSlider.value = Float(currentValue.g)
        blueSlider.value = Float(currentValue.b)
    }
  }

  override func viewDidLoad() {
    
    super.viewDidLoad()
    game.startNewGame()
    updateView()
  }

  @IBAction func hitMeBtnPressed() {
        
    game.calculateRoundScore(for: currentValue)
    showAlertForScore()
  }
      
func showAlertForScore() {
    
    var points = 0
    var alertTitle = ""
    switch abs(game.targetValue - currentValue) {
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
    targetLabel.backgroundColor = UIColor(rgbStruct: game.targetValue)
    scoreLabel.text = "Score: " + String(game.gameScore)
    roundLabel.text = "Round: " + String(game.round)
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
  }
  
  @IBAction func startOver(sender: AnyObject) {
    game.startNewGame()
    updateView()
  }
    
}


