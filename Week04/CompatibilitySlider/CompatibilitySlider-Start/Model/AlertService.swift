//
//  AlertService.swift
//  CompatibilitySlider-Start
//
//  Created by Shruti Sharma on 6/19/20.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit

class AlertService {
    
  func alert(title: String,
             body: String,
             imageLeft: String?,
             imageRight: String?,
             actionButtonTitle: String,
             dismissButtonTitle: String?,
             completion: @escaping () -> Void) -> AlertViewController {
        
      let storyboard = UIStoryboard(name: "CustomAlert", bundle: .main)
      
      let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
      
      alertVC.alertTitle = title
      alertVC.alertBody = body
    
      if let imageLeft = imageLeft {
        alertVC.imageLeft = imageLeft
      }
    
      if let imageRight = imageRight {
        alertVC.imageRight = imageRight
      }
    
      alertVC.actionButtonTitle = actionButtonTitle
    
      if let dismissButtonTitle = dismissButtonTitle {
        alertVC.dismissButtonTitle = dismissButtonTitle
      }
    
      alertVC.buttonAction = completion
      
      return alertVC
    }
}
