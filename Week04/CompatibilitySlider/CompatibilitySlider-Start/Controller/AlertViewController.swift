//
//  AlertViewController.swift
//  CompatibilitySlider-Start
//
//  Created by Shruti Sharma on 6/19/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var imgViewLeft: UIImageView!
    @IBOutlet weak var imgViewRight: UIImageView!

    var alertTitle = String()
    var alertBody = String()
    var imageLeft = String()
    var imageRight: String?
    var actionButtonTitle = String()
    var dismissButtonTitle: String?
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
      
        imgViewRight.round()
        imgViewLeft.round()
      
        titleLabel.text = alertTitle
        bodyLabel.text = alertBody
      
        actionButton.setTitle(actionButtonTitle, for: .normal)
              
        imgViewLeft.image = UIImage(named: imageLeft)

        imgViewRight.image = imageRight != nil ? UIImage(named: imageRight!) : nil
        imgViewRight.isHidden = imageRight != nil ? false : true
      
        if let dismissButtonTitle = dismissButtonTitle {
          dismissButton.setTitle(dismissButtonTitle, for: .normal)
          dismissButton.isHidden = false
        }
        else {
          dismissButton.isHidden = true
        }

    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
        
    @IBAction func didTapActionButton(_ sender: Any) {
        dismiss(animated: true)
        buttonAction?()
    }
    
}
