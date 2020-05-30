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
  let min: CGFloat = 0.0
  let rgbMax: CGFloat = 255.0
  let hueMax: CGFloat = 366.0
  let saturationMax: CGFloat = 100.0
  let brightnessMax: CGFloat = 100.0
  let red = "Red"
  let green = "Green"
  let blue = "Blue"
  let hue = "Hue"
  let saturation = "Saturation"
  let brightness = "Brightness"
  let rgb = "RGB"
  let hsb = "HSB"
  let defaultAlpha: CGFloat = 1.0
  let colorPlaceholder = "Color Name"
  let alertTitle = "Enter a color name"
  let alertMessage = "Please enter a color name of your choice."
  let alertOkBtnText = "OK"
  let alertCancelBtnText = "Cancel"
  let defaultColorVal: CGFloat = 0.0

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //create 'RGB' color model
    let redColor = ColorValue.init(name: red, minRange: min, maxRange: rgbMax)
    let greenColor = ColorValue.init(name: green, minRange: min, maxRange: rgbMax)
    let blueColor = ColorValue.init(name: blue, minRange: min, maxRange: rgbMax)
    rgbColorModel = ColorModel.init(name: rgb, type: .rgb, colorValues: [redColor, greenColor, blueColor])
    
    //create 'HSB' color model
    let hueVal = ColorValue.init(name: hue, minRange: min, maxRange: hueMax)
    let saturationVal = ColorValue.init(name: saturation, minRange: min, maxRange: saturationMax)
    let brightnessVal = ColorValue.init(name: brightness, minRange: min, maxRange: brightnessMax)
    hsbColorModel = ColorModel.init(name: hsb, type: .hsb, colorValues: [hueVal, saturationVal, brightnessVal])
    
    //default selected color model is 'RGB'
    currentColorModel = rgbColorModel
    resetValues()
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
    
    let alert = UIAlertController(title: alertTitle,
                                  message: alertTitle,
                                  preferredStyle: .alert)
    alert.addTextField { textField in
        textField.placeholder = self.colorPlaceholder
    }
    let okAction = UIAlertAction(title: alertOkBtnText, style: .default) { action in
      self.processChosenColorValues()
      self.colorNameLabel.text = alert.textFields![0].text
    }
    alert.addAction(okAction)
    let cancelAction = UIAlertAction(title: alertCancelBtnText, style: .default) { action in
    }
    alert.addAction(cancelAction)
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
        destinationVC.colorModelType = currentColorModel.type
    }
  }
  
  func resetValues() {
    
    setupSliderMinMaxValues()
    
    firstColorComponentSlider.value = Float(defaultColorVal)
    secondColorComponentSlider.value = Float(defaultColorVal)
    thirdColorComponentSlider.value = Float(defaultColorVal)
    
    firstColorNumberLabel.text = String(firstColorComponentSlider.value)
    secondColorNumberLabel.text = String(secondColorComponentSlider.value)
    thirdColorNumberLabel.text = String(thirdColorComponentSlider.value)
    
    colorNameLabel.text = colorPlaceholder
    
    setBackgroundColor(firstValue: defaultColorVal, secondValue: defaultColorVal, thirdValue: defaultColorVal)
  }
  
  func setupSliderMinMaxValues() {
      
    let colorValues = currentColorModel.colorValues
      
    let firstColor = colorValues[0]
    firstColorComponentSlider.minimumValue = Float(firstColor.minRange)
    firstColorComponentSlider.maximumValue = Float(firstColor.maxRange)
      
    let secondColor = colorValues[1]
    secondColorComponentSlider.minimumValue = Float(secondColor.minRange)
    secondColorComponentSlider.maximumValue = Float(secondColor.maxRange)

    let thirdColor = colorValues[2]
    thirdColorComponentSlider.minimumValue = Float(thirdColor.minRange)
    thirdColorComponentSlider.maximumValue = Float(thirdColor.maxRange)
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


