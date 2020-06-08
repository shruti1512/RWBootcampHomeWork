//
//  ViewController.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/5/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {


  //MARK: - Properties

  private let bullsEyeGameModel = GameModel(name: BullsEyeConstants.name,
                                    type: .bullsEye,
                                    promptText: BullsEyeConstants.promptText,
                                    minValue: BullsEyeConstants.sliderMinValue,
                                    maxValue: BullsEyeConstants.sliderMaxValue,
                                    defaultValue: BullsEyeConstants.sliderDefaultValue,
                                    htmlFileName: BullsEyeConstants.htmlFileName)
  
  private let rgbBullsEyeGameModel = GameModel(name: RGBullsEyeConstants.name,
                                    type: .rgbBullsEye,
                                    promptText: RGBullsEyeConstants.promptText,
                                    minValue: RGBullsEyeConstants.sliderMinValue,
                                    maxValue: RGBullsEyeConstants.sliderMaxValue,
                                    defaultValue: RGBullsEyeConstants.sliderDefaultValue,
                                    htmlFileName: RGBullsEyeConstants.htmlFileName)

  private let revBullsEyeGameModel = GameModel(name: RevBullsEyeConstants.name,
                                    type: .revBullsEye,
                                    promptText: RevBullsEyeConstants.promptText,
                                    minValue: RevBullsEyeConstants.sliderMinValue,
                                    maxValue: RevBullsEyeConstants.sliderMaxValue,
                                    defaultValue: RevBullsEyeConstants.sliderDefaultValue,
                                    htmlFileName: RevBullsEyeConstants.htmlFileName)


  //MARK: - View Lifecycle

  override func viewDidLoad() {
      super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  //MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      switch segue.identifier {
      case BullsEyeConstants.segueIdentifier:
           if let destinationVC = segue.destination as? BullsEyeViewController {
               destinationVC.gameModel = bullsEyeGameModel
          }
      case RGBullsEyeConstants.segueIdentifier:
           if let destinationVC = segue.destination as? RGBullsEyeViewController {
               destinationVC.gameModel = rgbBullsEyeGameModel
          }
      case RevBullsEyeConstants.segueIdentifier:
           if let destinationVC = segue.destination as? BullsEyeViewController {
               destinationVC.gameModel = revBullsEyeGameModel
          }
          default: print("Case not handled")
      }
  }

}

