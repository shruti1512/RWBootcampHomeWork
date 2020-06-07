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
                                      promptText: "Put the Bulls's Eye as close as to:",
                                      minValue: 0,
                                      maxValue: 100,
                                      defaultValue: 50)
    let rgbBullsEyeGameModel = GameModel(name: "RGBulls Eye",
                                      type: .rgbBullsEye,
                                      promptText: "Match this color",
                                      minValue: 0,
                                      maxValue: 255,
                                      defaultValue: 127)

    let revBullsEyeGameModel = GameModel(name: "RevBullsEye",
                                      type: .revBullsEye,
                                      promptText: "Guess where the slider is:",
                                      minValue: 1,
                                      maxValue: 100,
                                      defaultValue: 1)


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            case "BullsEyeSegue":
             if let destinationVC = segue.destination as? BullsEyeViewController {
                 destinationVC.gameModel = bullsEyeGameModel
            }
            case "RGBullsEyeSegue":
             if let destinationVC = segue.destination as? RGBullsEyeViewController {
                 destinationVC.gameModel = rgbBullsEyeGameModel
            }
            case "RevBullsEyeSegue":
             if let destinationVC = segue.destination as? BullsEyeViewController {
                 destinationVC.gameModel = revBullsEyeGameModel
            }
            default: print("Case not handled")
        }
    }

}

