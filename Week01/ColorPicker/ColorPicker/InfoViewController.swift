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
  var colorModelStr: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      guard let colorModelStr = colorModelStr else {
        return
      }
      if let wikipediaURL = URL(string: "https://en.wikipedia.org/wiki/" + colorModelStr + "_color_model") {
        let urlRequest = URLRequest(url: wikipediaURL)
        webView.load(urlRequest)
      }
      
    }
  
  @IBAction func closeBtnPressed(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}
