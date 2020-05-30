//
//  ViewController.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/29/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var colorNameLabel: UILabel!
  @IBOutlet weak var firstColorComponentSlider: UISlider!
  @IBOutlet weak var firstColorComponentLabel: UILabel!
  @IBOutlet weak var firstColorNumberLabel: UILabel!
  @IBOutlet weak var secondColorComponentLabel: UILabel!
  @IBOutlet weak var secondColorComponentSlider: UISlider!
  @IBOutlet weak var secondColorNumberLabel: UILabel!
  @IBOutlet weak var thirdColorComponentLabel: UILabel!
  @IBOutlet weak var thirdColorComponentSlider: UISlider!
  @IBOutlet weak var thirdColorNumberLabel: UILabel!

  var rgbColorModel: ColorModel!
  var hsbColorModel: ColorModel!
  var currentColorModel: ColorModel!

  //known values
  let min = 0
  let rgbMax = 255
  let hueMax = 366
  let saturationMax = 100
  let brightnessMax = 100
  let red = "Red"
  let green = "Green"
  let blue = "Blue"
  let hue = "Hue"
  let saturation = "Saturation"
  let brightness = "Brightness"
  let rgb = "RGB"
  let hsb = "HSB"
  let defaultAlpha: CGFloat = 1.0

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let redColor = ColorValue.init(name: red, minRange: min, maxRange: rgbMax)
    let greenColor = ColorValue.init(name: green, minRange: min, maxRange: rgbMax)
    let blueColor = ColorValue.init(name: blue, minRange: min, maxRange: rgbMax)
    rgbColorModel = ColorModel.init(name: rgb, type: .rgb, colorValues: [redColor, greenColor, blueColor])
    
    let hueVal = ColorValue.init(name: hsb, minRange: min, maxRange: hueMax)
    let saturationVal = ColorValue.init(name: saturation, minRange: min, maxRange: saturationMax)
    let brightnessVal = ColorValue.init(name: brightness, minRange: min, maxRange: brightnessMax)
    hsbColorModel = ColorModel.init(name: hsb, type: .rgb, colorValues: [hueVal, saturationVal, brightnessVal])
    
    //default selected color model is 'RGB'
    currentColorModel = rgbColorModel
    setBackgroundColor(firstValue: 0.0, secondValue: 0.0, thirdValue: 0.0)
  }
  
  @IBAction func firstColorSliderValueChanged(_ slider: UISlider) {
    firstColorNumberLabel.text = String(Int(slider.value.rounded()))
  }
  
  @IBAction func secondColorSliderValueChanged(_ slider: UISlider) {
    secondColorNumberLabel.text = String(Int(slider.value.rounded()))
  }

  @IBAction func thirdColorSliderValueChanged(_ slider: UISlider) {
    thirdColorNumberLabel.text = String(Int(slider.value.rounded()))
  }

  @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    
    if sender.selectedSegmentIndex == 0 {
      currentColorModel = rgbColorModel
    }
    else {
      currentColorModel = hsbColorModel
    }
    resetValues()
  }
  
  @IBAction func setColorBtnPressed(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "Enter a color name",
                                  message: "Please enter a color name of your choice.",
                                  preferredStyle: .alert)
    alert.addTextField { textField in
      textField.placeholder = "Color Name"
    }
    let action = UIAlertAction(title: "OK", style: .default) { action in
      self.processChosenColorValues()
      self.colorNameLabel.text = alert.textFields![0].text
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  func processChosenColorValues() {
    
    //change background color of the view
    let firstSelectedColorInt = Int(firstColorNumberLabel.text!)
    let firstSelectedColorFloat = CGFloat(firstSelectedColorInt!)
    
    let secondSelectedColorInt = Int(secondColorNumberLabel.text!)
    let secondSelectedColorFloat = CGFloat(secondSelectedColorInt!)
    
    let thirdSelectedColorInt = Int(thirdColorNumberLabel.text!)
    let thirdSelectedColorFloat = CGFloat(thirdSelectedColorInt!)
    
    let colorValues = currentColorModel.colorValues
    let firstColorVal = firstSelectedColorFloat/CGFloat(colorValues[0].maxRange)
    let secondColorVal = secondSelectedColorFloat/CGFloat(colorValues[1].maxRange)
    let thirdColorVal = thirdSelectedColorFloat/CGFloat(colorValues[2].maxRange)

    setBackgroundColor(firstValue: firstColorVal, secondValue: secondColorVal, thirdValue: thirdColorVal)
  }
  
  @IBAction func resetBtnPressed(_ sender: UIButton) {
    resetValues()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationVC = segue.destination as? InfoViewController {
      destinationVC.colorModelStr = currentColorModel.name
    }
  }
  
  func resetValues() {
    
    firstColorComponentSlider.value = 0
    secondColorComponentSlider.value = 0
    thirdColorComponentSlider.value = 0
    
    firstColorNumberLabel.text = String(0)
    secondColorNumberLabel.text = String(0)
    thirdColorNumberLabel.text = String(0)
    
    colorNameLabel.text = "Color Name"
    
    setBackgroundColor(firstValue: 0.0, secondValue: 0.0, thirdValue: 0.0)
  }
  
  func setBackgroundColor(firstValue: CGFloat, secondValue: CGFloat, thirdValue: CGFloat) {
    
    if currentColorModel.type == .hsb {
      view.backgroundColor = UIColor(hue: firstValue, saturation: secondValue, brightness: thirdValue, alpha: defaultAlpha)
    }
    else {
      view.backgroundColor = UIColor(red: firstValue, green: secondValue, blue: thirdValue, alpha: defaultAlpha)
    }
  }
}

