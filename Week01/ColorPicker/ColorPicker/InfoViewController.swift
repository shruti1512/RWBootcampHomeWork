//
//  InfoViewController.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/29/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {

  @IBOutlet private weak var webView: WKWebView!
  var colorModelType: ColorModel.ModelType?
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    guard let colorModelType = colorModelType else {
        return
    }
      
      var url: URL!
      if colorModelType == .rgb {
         url = URL(string: "https://en.wikipedia.org/wiki/RGB_color_model")
      }
      else {
         url = URL(string: "https://en.wikipedia.org/wiki/HSL_and_HSV")
      }
      if let wikipediaURL = url {
        let urlRequest = URLRequest(url: wikipediaURL)
        webView.load(urlRequest)
      }
  }
  
  @IBAction func closeBtnPressed(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
    
    deinit {
        webView.stopLoading()
    }
}
