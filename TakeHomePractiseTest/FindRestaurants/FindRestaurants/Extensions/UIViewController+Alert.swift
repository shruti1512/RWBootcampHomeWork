//
//  UIViewController+Alert.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 8/28/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
  
  func showAlert(withTitle title: String?, message: String) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okButton = UIAlertAction(title: "OK", style: .default) { action in
      alertController.dismiss(animated: true, completion: nil)
    }
    alertController.addAction(okButton)
    present(alertController, animated: true, completion: nil)
  }

}

