//
//  RevBullsEyeViewController.swift
//  GameBullsEye
//
//  Created by Shruti Sharma on 6/6/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit

class RevBullsEyeViewController: BullsEyeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        sliderContainerView.addCornerRadius(cornerRadius: 5.0)
//        textField.addTarget(self, action: #selector(textFielddDidChange(_:)), for: .editingChanged)
    }

}
