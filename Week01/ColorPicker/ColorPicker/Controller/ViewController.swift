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
  @IBOutlet private var recentColorLabels: [UILabel]!
  @IBOutlet private var recentColorBtns: [UIButton]!

  //MARK: - Properties
  private let defaultColorVal: CGFloat = 0.0, borderColorWhite = UIColor.white
  private let recentsMaxLimit = 5
  private var rgbColorModel: ColorModel!, hsbColorModel: ColorModel!
  private var currentColorModel: ColorModel!
  private var recentUserColors = [UserColor]()
  private var userColorName: String!
    
  private var currentUserColor: UserColor! {
     didSet{
        guard let currentUserColor = currentUserColor else {
            return
        }
        colorNameLabel.text = currentUserColor.name
        let color = getColor(firstValue: currentUserColor.color1, secondValue: currentUserColor.color2, thirdValue: currentUserColor.color3)
        view.backgroundColor = color
        saveColorInHistory(currentUserColor)
        refreshRecentColorViews(recentUserColors)
        previewView.backgroundColor = UIColor.clear
    }
  }

  //MARK: - UIViewController Methods
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setUIControls()
    refresh()
  }
  
  required init?(coder: NSCoder) {
      super.init(coder: coder)
      setColorModels()
     //set default selected color model to 'RGB'
     currentColorModel = rgbColorModel
  }
  //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destinationVC = segue.destination as? InfoViewController {
        destinationVC.wikiURLString = currentColorModel.wikiUrlString
      }
    }

  //MARK: - Intial Setup

  private func setColorModels() {
    
    //create 'RGB' color model
    let redColor = ColorValue(name: ColorStrings.red, minRange: ColorDefaults.min, maxRange: ColorDefaults.rgbMax)
    let greenColor = ColorValue(name: ColorStrings.green, minRange:  ColorDefaults.min, maxRange:  ColorDefaults.rgbMax)
    let blueColor = ColorValue(name: ColorStrings.blue, minRange:  ColorDefaults.min, maxRange:  ColorDefaults.rgbMax)
    rgbColorModel = ColorModel(name: ColorStrings.rgb, type: .rgb,
                               colorValues: [redColor, greenColor, blueColor], wikiUrlString: WikiURLStrings.rgbURL)

    //create 'HSB' color model
    let hueVal = ColorValue(name: ColorStrings.hue, minRange:  ColorDefaults.min, maxRange: ColorDefaults.hueMax)
    let saturationVal = ColorValue(name: ColorStrings.saturation, minRange:  ColorDefaults.min, maxRange: ColorDefaults.saturationMax)
    let brightnessVal = ColorValue(name: ColorStrings.brightness, minRange:  ColorDefaults.min, maxRange: ColorDefaults.saturationMax)
    hsbColorModel = ColorModel(name: ColorStrings.hsb, type: .hsb,
                               colorValues: [hueVal, saturationVal, brightnessVal], wikiUrlString: WikiURLStrings.hsbURL)
  }
  
  private func setUIControls() {
    
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
      let colors = recentUserColors.filter{ $0.model ==  currentColorModel.type}
      if index < colors.count && colors.count > 0 {
          let userColor = colors[index]
        var color: UIColor!
          if currentColorModel.type == .rgb {
              color = getColor(firstValue: userColor.color1, secondValue: userColor.color2, thirdValue: userColor.color3)
              let colorTuple = color.rgba
              let rgbMax = rgbColorModel.colorValues[0].maxRange
              firstColorComponentSlider.value = Float((colorTuple.red * rgbMax).rounded())
              secondColorComponentSlider.value = Float((colorTuple.green * rgbMax).rounded())
              thirdColorComponentSlider.value = Float((colorTuple.blue * rgbMax).rounded())
          }
          else {
              color = getColor(firstValue: userColor.color1, secondValue: userColor.color2, thirdValue: userColor.color3)
              let colorTuple = color.hsba
              let hueMax = hsbColorModel.colorValues[0].maxRange
              let saturationMax = hsbColorModel.colorValues[1].maxRange
              firstColorComponentSlider.value = Float((colorTuple.hue * hueMax).rounded())
              secondColorComponentSlider.value = Float((colorTuple.saturation * saturationMax).rounded())
              thirdColorComponentSlider.value = Float((colorTuple.brightness * saturationMax).rounded())
          }
          firstColorNumberLabel.text = String(Int(firstColorComponentSlider.value))
          secondColorNumberLabel.text = String(Int(secondColorComponentSlider.value))
          thirdColorNumberLabel.text = String(Int(thirdColorComponentSlider.value))
          view.backgroundColor = color
          colorNameLabel.text = userColor.name
      }
    }

   //MARK: - Set Color for View
    private func setColorForView(_ view: UIView) {
    
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
        currentUserColor = UserColor(name: userColorName, model: currentColorModel.type, color1: firstColorVal, color2: secondColorVal, color3: thirdColorVal)
       view.backgroundColor = color
    }
    else {
       previewView.backgroundColor = color
    }
        
  }
  
    // MARK: - Get UIColor for selected color numbers
     private func getColor(firstValue: CGFloat, secondValue: CGFloat, thirdValue: CGFloat) -> UIColor {
       
       if currentColorModel.type == .hsb {
           return UIColor(hue: firstValue, saturation: secondValue, brightness: thirdValue, alpha: ColorDefaults.alpha)
       }
       else {
         return UIColor(red: firstValue, green: secondValue, blue: thirdValue, alpha: ColorDefaults.alpha)
       }
     }
    
    private func validateTextFieldInput(_ text: String) {
        let charSet = NSCharacterSet.whitespaces
        let trimmedString = text.trimmingCharacters(in: charSet)
        if trimmedString.count > 0 {
            self.userColorName = trimmedString
        }
        else {
            self.userColorName  = ColorNameStrings.noNameColorText
        }
    }


  //MARK: - Set Color History
  private func saveColorInHistory(_ userColor: UserColor) {
        
    var colors = recentUserColors.filter{ $0.model ==  userColor.model}
    if colors.count == recentsMaxLimit {
        let color = colors.removeLast()
        let index = recentUserColors.firstIndex { $0.color1 == color.color1 &&
                                                  $0.color2 == color.color2 &&
                                                  $0.color3 == color.color3}
        if let index = index {
           recentUserColors.remove(at: index)
        }
    }
    recentUserColors.insert(currentUserColor, at: 0)
  }
  
 //MARK: - Refresh Views in Color History
  private func refreshRecentColorViews(_ recentColors: [UserColor]?) {
    
    resetRecentColorViews()
    
    guard let recentColors = recentColors else {
        return
    }
    let colors = recentColors.filter{ $0.model ==  currentColorModel.type}
    for (index, userColor) in colors.enumerated() {
      let recentView = recentColorBtns[index]
      let color = getColor(firstValue: userColor.color1, secondValue: userColor.color2, thirdValue: userColor.color3)
      recentView.backgroundColor = color
    }
  }

  private func resetRecentColorViews() {
    recentColorBtns.forEach { $0.backgroundColor = UIColor.clear }
    recentColorLabels.forEach { $0.text = ""}
  }

  //MARK: - Refresh View

  private func refresh() {
     
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

  private func resetColorHistory() {
    recentColorBtns.forEach { $0.backgroundColor = UIColor.clear }
    recentUserColors.removeAll()
  }
    
  private func resetSliders() {
      
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
         
}

//MARK: - UITextFieldDelegate
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


