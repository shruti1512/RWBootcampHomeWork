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

  //MARK:- IBOutlets
  
  @IBOutlet private weak var webView: WKWebView!
  
  //MARK:- Properties
  
  var htmFile: String?
  
  //MARK:- View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
      
    setupNavigationItemView()
    
    guard let htmFile = htmFile else {
        return
    }
    let fileURL = Bundle.main.url(forResource: htmFile, withExtension: ".html")
    if let fileURL = fileURL {
        let urlRequest = URLRequest(url: fileURL)
        webView.load(urlRequest)
      }
  }
  
  deinit {
      webView.stopLoading()
  }

  //MARK:- Initial Setup

  private func setupNavigationItemView() {
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      self.navigationItem.setHidesBackButton(true, animated: false);
  }

  //MARK:- IBActions

  @IBAction func closeBtnPressed(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
    
}
