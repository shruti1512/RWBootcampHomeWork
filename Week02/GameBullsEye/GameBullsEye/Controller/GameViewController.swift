//
//  GameViewController.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/6/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var gameModel: GameModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNvaigationItemView()
    }
    
    func setupNvaigationItemView() {
        self.navigationItem.title = gameModel.name
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false);
    }
    
}
