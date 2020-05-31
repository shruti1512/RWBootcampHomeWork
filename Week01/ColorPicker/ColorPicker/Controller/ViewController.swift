//
//  ViewController.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/29/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  //MARK: - IBOutlets
  @IBOutlet private weak var segmentedControl: UISegmentedControl!
  @IBOutlet private weak var colorNameLabel: UILabel!
  @IBOutlet private weak var firstColorComponentSlider: UISlider!
  @IBOutlet private weak var firstColorComponentLabel: UILabel!
  @IBOutlet private weak var firstColorNumberLabel: UILabel!
  @IBOutlet private weak var secondColorComponentLabel: UILabel!
  @IBOutlet private weak var secondColorComponentSlider: UISlider!
  @IBOutlet private weak var secondColorNumberLabel: UILabel!
  @IBOutlet private weak var thirdColorComponentLabel: UILabel!
  @IBOutlet private weak var thirdColorComponentSlider: UISlider!
  @IBOutlet private weak var thirdColorNumberLabel: UILabel!
  @IBOutlet private weak var previewView: UIView!
  @IBOutlet private weak var recentsStackView: UIStackView!
  @IBOutlet private var recentColorLabels: [UILabel]!
  @IBOutlet private var recentColorBtns: [UIButton]!

  //MARK: - Properties
  let defaultColorVal: CGFloat = 0.0
  let borderColorWhite = UIColor.white
  var rgbColorModel: ColorModel!
  var hsbColorModel: ColorModel!
  var currentColorModel: ColorModel!
  var recentUserColors = [UserColor]()
  var userColorName: String!
  var alertTextField: UITextField!
  var currentUserColor: UserColor! {
     didSet{
        guard let currentUserColor = currentUserColor else {
            return
        }
        colorNameLabel.text = currentUserColor.name
        view.backgroundColor = currentUserColor.color
        saveColorInHistory(currentUserColor)
        refreshRecentColorViews(recentUserColors)
        previewView.backgroundColor = UIColor.clear
    }
  }

  //MARK: - UIViewController Methods
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setColorModels()
    setUIControls()
    
    //set default selected color model to 'RGB'
    currentColorModel = rgbColorModel
    refresh()
  }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destinationVC = segue.destination as? InfoViewController {
          destinationVC.colorModelType = currentColorModel.type
      }
    }

  //MARK: - Intial Setup

  func setColorModels() {
    //create 'RGB' color model
    let redColor = ColorValue.init(name: ColorStrings.red, minRange: ColorDefaults.min, maxRange: ColorDefaults.rgbMax)
    let greenColor = ColorValue.init(name: ColorStrings.green, minRange:  ColorDefaults.min, maxRange:  ColorDefaults.rgbMax)
    let blueColor = ColorValue.init(name: ColorStrings.blue, minRange:  ColorDefaults.min, maxRange:  ColorDefaults.rgbMax)
    rgbColorModel = ColorModel.init(name: ColorStrings.rgb, type: .rgb, colorValues: [redColor, greenColor, blueColor])

    //create 'HSB' color model
    let hueVal = ColorValue.init(name: ColorStrings.hue, minRange:  ColorDefaults.min, maxRange: ColorDefaults.hueMax)
    let saturationVal = ColorValue.init(name: ColorStrings.saturation, minRange:  ColorDefaults.min, maxRange: ColorDefaults.saturationMax)
    let brightnessVal = ColorValue.init(name: ColorStrings.brightness, minRange:  ColorDefaults.min, maxRange: ColorDefaults.saturationMax)
    hsbColorModel = ColorModel.init(name: ColorStrings.hsb, type: .hsb, colorValues: [hueVal, saturationVal, brightnessVal])
  }
  
  func setUIControls() {
    
    let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
    UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .highlighted)
    segmentedControl.createBorder(color: borderColorWhite, width: BorderValues.borderWidth, cornerRadius: BorderValues.segmentedControlCornerRadius)
    
    previewView.createBorder(color: borderColorWhite, width: BorderValues.borderWidth, cornerRadius: BorderValues.cornerRadius)
        
    recentColorBtns.forEach { recentBtn in
        recentBtn.createBorder(color: borderColorWhite, width: BorderValues.borderWidth, cornerRadius: BorderValues.cornerRadius)
        recentBtn.backgroundColor = UIColor.clear
    }
  }
 
 //MARK:- UIControl Action Trigger Events
    
  @IBAction func firstColorSliderValueChanged(_ slider: UISlider) {
    firstColorNumberLabel.text = String(Int(slider.value.rounded()))
    setColorForView(previewView)
  }
  
  @IBAction func secondColorSliderValueChanged(_ slider: UISlider) {
    secondColorNumberLabel.text = String(Int(slider.value.rounded()))
    setColorForView(previewView)
  }

  @IBAction func thirdColorSliderValueChanged(_ slider: UISlider) {
    thirdColorNumberLabel.text = String(Int(slider.value.rounded()))
    setColorForView(previewView)
  }

  @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    
    if sender.selectedSegmentIndex == 0 {
      currentColorModel = rgbColorModel
    }
    else {
      currentColorModel = hsbColorModel
    }
    refresh()
  }
  
  @IBAction func setColorBtnPressed(_ sender: UIButton) {
    
    let alert = UIAlertController(title: AlertValues.alertTitle,
                              message: AlertValues.alertMessage,
                              preferredStyle: .alert)
    alert.addTextField { textField in
        textField.placeholder = ColorNameStrings.colorPlaceholder
        textField.delegate = self
        textField.returnKeyType = .done
    }
    let okAction = UIAlertAction(title: AlertValues.alertOkBtnText, style: .default) { action in
        self.validateTextFieldInput(alert.textFields![0].text!)
        self.setColorForView(self.view)
    }
    alert.addAction(okAction)
    let cancelAction = UIAlertAction(title: AlertValues.alertCancelBtnText, style: .default) { action in
    }
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
      refresh()
      resetColorHistory()
    }
      
    @IBAction func recentColorBtnBtnPressed(_ sender: UIButton) {
      
      let index = sender.tag%100
//      guard let recentUserColors = recentUserColors else {
//            return
//      }
      let colors = recentUserColors.filter{ $0.model ==  currentColorModel.type}
      if index < colors.count && colors.count > 0 {
          let userColor = colors[index]
          if currentColorModel.type == .rgb {
              let colorTuple = userColor.color.rgba
              let rgbMax = rgbColorModel.colorValues[0].maxRange
              firstColorComponentSlider.value = Float((colorTuple.red * rgbMax).rounded())
              secondColorComponentSlider.value = Float((colorTuple.green * rgbMax).rounded())
              thirdColorComponentSlider.value = Float((colorTuple.blue * rgbMax).rounded())
          }
          else {
              let colorTuple = userColor.color.hsba
              let hueMax = hsbColorModel.colorValues[0].maxRange
              let saturationMax = hsbColorModel.colorValues[1].maxRange
              firstColorComponentSlider.value = Float((colorTuple.hue * hueMax).rounded())
              secondColorComponentSlider.value = Float((colorTuple.saturation * saturationMax).rounded())
              thirdColorComponentSlider.value = Float((colorTuple.brightness * saturationMax).rounded())
          }
          firstColorNumberLabel.text = String(Int(firstColorComponentSlider.value))
          secondColorNumberLabel.text = String(Int(secondColorComponentSlider.value))
          thirdColorNumberLabel.text = String(Int(thirdColorComponentSlider.value))
          view.backgroundColor = userColor.color
          colorNameLabel.text = userColor.name
      }
    }

   //MARK: - Set Color for View
    func setColorForView(_ view: UIView) {
    
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
    
    let color = getColor(firstValue: firstColorVal, secondValue: secondColorVal, thirdValue: thirdColorVal)

    if view == self.view {
       currentUserColor = UserColor(name: userColorName, model: currentColorModel.type, color: color)
       view.backgroundColor = color
    }
    else {
       previewView.backgroundColor = color
    }
        
  }
  
    // MARK: - Get UIColor for selected color numbers
     func getColor(firstValue: CGFloat, secondValue: CGFloat, thirdValue: CGFloat) -> UIColor {
       
       if currentColorModel.type == .hsb {
           return UIColor(hue: firstValue, saturation: secondValue, brightness: thirdValue, alpha: ColorDefaults.alpha)
       }
       else {
         return UIColor(red: firstValue, green: secondValue, blue: thirdValue, alpha: ColorDefaults.alpha)
       }
     }

  //MARK: - Set Color History
  func saveColorInHistory(_ userColor: UserColor) {
        
//    if recentUserColors == nil {
//        recentUserColors = [UserColor]()
//    }
    var colors = recentUserColors.filter{ $0.model ==  userColor.model}
    if colors.count == 5 {
        let color = colors.removeLast()
        let index = recentUserColors.firstIndex { $0.color == color.color }
        if let index = index {
           recentUserColors.remove(at: index)
        }
    }
    recentUserColors.insert(currentUserColor, at: 0)
  }
  
 //MARK: - Refresh Views in Color History
  func refreshRecentColorViews(_ recentColors: [UserColor]?) {
    
    resetRecentColorViews()
    
    guard let recentColors = recentColors else {
        return
    }
    let colors = recentColors.filter{ $0.model ==  currentColorModel.type}
    for (index, userColor) in colors.enumerated() {
      let recentView = recentColorBtns[index]
      recentView.backgroundColor = userColor.color
      //let recentLabel = recentColorLabels[index]
      //recentLabel.text = userColor.name
    }
  }

  func resetRecentColorViews() {
    recentColorLabels.forEach { $0.text = ""}
    recentColorBtns.forEach { $0.backgroundColor = UIColor.clear }
  }

  //MARK: - Refresh View

  func refresh() {
     
    resetSliders()
    
    resetRecentColorViews()
    refreshRecentColorViews(recentUserColors)
    
    //reset slider values
    firstColorComponentSlider.value = Float(defaultColorVal)
    secondColorComponentSlider.value = Float(defaultColorVal)
    thirdColorComponentSlider.value = Float(defaultColorVal)
    
    //reset selected color values for sliders
    firstColorNumberLabel.text = String(Int(defaultColorVal))
    secondColorNumberLabel.text = String(Int(defaultColorVal))
    thirdColorNumberLabel.text = String(Int(defaultColorVal))
    
    //reset color name title
    colorNameLabel.text = ColorNameStrings.colorPlaceholder
    
    let color = getColor(firstValue: defaultColorVal, secondValue: defaultColorVal, thirdValue: defaultColorVal)
    previewView.backgroundColor = UIColor.clear
    view.backgroundColor = color
    currentUserColor = nil
  }
  
  //MARK: - Reset UI Controls and Array

  func resetColorHistory() {
    recentColorBtns.forEach { $0.backgroundColor = UIColor.clear }
//    if recentUserColors !=  nil {
        recentUserColors.removeAll()
//    }
  }
    
  func resetSliders() {
      
    let colorValues = currentColorModel.colorValues
      
    let firstColor = colorValues[0]
    firstColorComponentSlider.minimumValue = Float(firstColor.minRange)
    firstColorComponentSlider.maximumValue = Float(firstColor.maxRange)
    firstColorComponentLabel.text = firstColor.name
      
    let secondColor = colorValues[1]
    secondColorComponentSlider.minimumValue = Float(secondColor.minRange)
    secondColorComponentSlider.maximumValue = Float(secondColor.maxRange)
    secondColorComponentLabel.text = secondColor.name

    let thirdColor = colorValues[2]
    thirdColorComponentSlider.minimumValue = Float(thirdColor.minRange)
    thirdColorComponentSlider.maximumValue = Float(thirdColor.maxRange)
    thirdColorComponentLabel.text = thirdColor.name
  }
  
    func validateTextFieldInput(_ text: String) {
        let charSet = NSCharacterSet.whitespaces
        let trimmedString = text.trimmingCharacters(in: charSet)
        if trimmedString.count > 0 {
            self.userColorName = trimmedString
        }
        else {
            self.userColorName  = ColorNameStrings.noNameColorText
        }
    }
       
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        validateTextFieldInput(text)
        self.setColorForView(self.view)
        dismiss(animated: true, completion: nil)
        return true
    }
}


