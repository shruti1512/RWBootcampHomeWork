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
  let alpha = 1.0
  
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
  }


  @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    currentColorModel = ColorModel(rawValue: sender.selectedSegmentIndex)
    
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
    
  }
  
  @IBAction func resetBtnPressed(_ sender: UIButton) {
    firstColorComponentSlider.value = 0
    secondColorComponentSlider.value = 0
    thirdColorComponentSlider.value = 0
    
    firstColorNumberLabel.text = String(0)
    secondColorNumberLabel.text = String(0)
    thirdColorNumberLabel.text = String(0)
  }
  
  func updateLabels() {
    
  }
  
}

