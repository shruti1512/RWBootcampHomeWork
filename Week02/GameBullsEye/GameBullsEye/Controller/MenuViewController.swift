//
//  ViewController.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/5/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {


    let bullsEyeGameModel = GameModel(name: "BullsEye",
                                      type: .bullsEye,
                                      displayText: "Put the Bulls's Eye as close as to:",
                                      minValue: 0,
                                      maxValue: 100)
    let rgbBullsEyeGameModel = GameModel(name: "RGBulls Eye",
                                      type: .rgbBullsEye,
                                      displayText: "Match this color",
                                      minValue: 0,
                                      maxValue: 255)

    let revBullsEyeGameModel = GameModel(name: "RevBullsEye",
                                      type: .revBullsEye,
                                      displayText: "Guess where the slider is:",
                                      minValue: 1,
                                      maxValue: 100)


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? BullsEyeViewController {
            destinationVC.gameModel = revBullsEyeGameModel
       }
        else  if let destinationVC = segue.destination as? RGBullsEyeViewController {
             destinationVC.gameModel = rgbBullsEyeGameModel
        }
    }

}

