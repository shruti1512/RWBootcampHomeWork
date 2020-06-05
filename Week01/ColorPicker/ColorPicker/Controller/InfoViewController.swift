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
  public var wikiURLString: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    guard let wikiURLString = wikiURLString else {
        return
    }
      
    let url = URL(string: wikiURLString)
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
