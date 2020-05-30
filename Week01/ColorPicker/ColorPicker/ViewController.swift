//
//  ViewController.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/29/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

enum ColorModel: Int {
  case rgb = 0
  case hsb = 1
}

class ViewController: UIViewController {

  var currentColorModel: ColorModel!
  let defaultAlpha: CGFloat = 1.0
  
  let colorModelRGBComponents = ["Red", "Green", "Blue"]
  let colorModelHSBComponents = ["Hue", "Saturation", "Brightness"]
  
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

  override func viewDidLoad() {
    
    super.viewDidLoad()
    //default selected color model is 'RGB'
    currentColorModel = .rgb
    setUpView()
  }
  
  func setUpView() {
    firstColorComponentSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Normal"), for: .normal)
    firstColorComponentSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Highlighted"), for: .highlighted)
    secondColorComponentSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Normal"), for: .normal)
    secondColorComponentSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Highlighted"), for: .highlighted)
    thirdColorComponentSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Normal"), for: .normal)
    thirdColorComponentSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Highlighted"), for: .highlighted)

    let edgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    let trackeLeftResizableImage = #imageLiteral(resourceName: "SliderTrackLeft").resizableImage(withCapInsets: edgeInsets)
    firstColorComponentSlider.setMinimumTrackImage(trackeLeftResizableImage, for: .normal)
    secondColorComponentSlider.setMinimumTrackImage(trackeLeftResizableImage, for: .normal)
    thirdColorComponentSlider.setMinimumTrackImage(trackeLeftResizableImage, for: .normal)

    let trackeRightResizableImage = #imageLiteral(resourceName: "SliderTrackRight").resizableImage(withCapInsets: edgeInsets)
    firstColorComponentSlider.setMaximumTrackImage(trackeRightResizableImage, for: .normal)
    secondColorComponentSlider.setMaximumTrackImage(trackeRightResizableImage, for: .normal)
    thirdColorComponentSlider.setMaximumTrackImage(trackeRightResizableImage, for: .normal)

    setColorForBackground()
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
    
    currentColorModel = ColorModel(rawValue: sender.selectedSegmentIndex)
    
    resetValues()
    
    //User selected 'RGB' Color Model
    if currentColorModel == .rgb {
      firstColorComponentLabel.text = colorModelRGBComponents[0]
      secondColorComponentLabel.text = colorModelRGBComponents[1]
      thirdColorComponentLabel.text = colorModelRGBComponents[2]
      
      firstColorComponentSlider.minimumValue = 0
      firstColorComponentSlider.maximumValue = 255
      
      secondColorComponentSlider.minimumValue = 0
      secondColorComponentSlider.maximumValue = 255

      thirdColorComponentSlider.minimumValue = 0
      thirdColorComponentSlider.maximumValue = 255
    }
    //User selected 'HSB' Color Model
    else {
      firstColorComponentLabel.text = colorModelHSBComponents[0]
      secondColorComponentLabel.text = colorModelHSBComponents[1]
      thirdColorComponentLabel.text = colorModelHSBComponents[2]
      
      firstColorComponentSlider.minimumValue = 0
      firstColorComponentSlider.maximumValue = 360
      
      secondColorComponentSlider.minimumValue = 0
      secondColorComponentSlider.maximumValue = 100
      
      thirdColorComponentSlider.minimumValue = 0
      thirdColorComponentSlider.maximumValue = 100

    }
  }
  
  @IBAction func setColorBtnPressed(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "Enter a color name", message: "Please enter a color name for your selection.", preferredStyle: .alert)
    alert.addTextField { textField in
      textField.placeholder = "Color Name"
    }
    let action = UIAlertAction(title: "OK", style: .default) { action in
      self.setColorForBackground()
      self.colorNameLabel.text = alert.textFields![0].text
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  func setColorForBackground() {
    
    //change background color of the view
    let firstSelectedColorInt = Int(firstColorNumberLabel.text!)
    let firstSelectedColorFloat = CGFloat(firstSelectedColorInt!)
    
    let secondSelectedColorInt = Int(secondColorNumberLabel.text!)
    let secondSelectedColorFloat = CGFloat(secondSelectedColorInt!)
    
    let thirdSelectedColorInt = Int(thirdColorNumberLabel.text!)
    let thirdSelectedColorFloat = CGFloat(thirdSelectedColorInt!)
    
    let selectedColor: UIColor!
    if currentColorModel == .rgb {
      let redColor = firstSelectedColorFloat/255
      let greenColor = secondSelectedColorFloat/255
      let blueColor = thirdSelectedColorFloat/255
      
      selectedColor = UIColor(red: redColor,
                              green: greenColor,
                              blue: blueColor,
                              alpha: defaultAlpha)
    }
    else {
      let hue = firstSelectedColorFloat/360
      let saturation = secondSelectedColorFloat/100
      let brightness = thirdSelectedColorFloat/100
      
      selectedColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: defaultAlpha)
    }
    view.backgroundColor = selectedColor
  }
  
  @IBAction func resetBtnPressed(_ sender: UIButton) {
    firstColorComponentSlider.value = 0
    secondColorComponentSlider.value = 0
    thirdColorComponentSlider.value = 0
    
    firstColorNumberLabel.text = String(0)
    secondColorNumberLabel.text = String(0)
    thirdColorNumberLabel.text = String(0)
  }
  
  func resetValues() {
    
    firstColorComponentSlider.value = 0
    secondColorComponentSlider.value = 0
    thirdColorComponentSlider.value = 0
    
    firstColorNumberLabel.text = String(0)
    secondColorNumberLabel.text = String(0)
    thirdColorNumberLabel.text = String(0)
    
    if currentColorModel == .hsb {
      view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: defaultAlpha)
    }
    else {
      view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: defaultAlpha)
    }
  }
}

