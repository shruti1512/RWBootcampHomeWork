//
//  AddSandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

class AddSandwichViewController: UIViewController {
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var navigationBar: UINavigationBar!
  
  var imageName: String
  var sauceAmount: SauceAmount!
  var sandwich: Sandwich?
  var isDataUpdated = false
  var dataSource: SandwichDataSource?
  let dataManager = DataManager.shared
  
  required init?(coder: NSCoder) {
    imageName = AddSandwichViewController.randomImageName()
    sauceAmount = SauceAmount.none
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadSandwich()
  }
  
  func loadSandwich() {
    
    guard let sandwich = sandwich else { return }
    navigationBar.topItem?.title = "Edit Sandwich"
    imageName = sandwich.imageName
    nameField.text = sandwich.name
    sauceAmount = sandwich.sauceAmount.sauceAmount
    var index = 0
    while index < segmentedControl.numberOfSegments {
      let title = segmentedControl.titleForSegment(at: index)
      if title == sauceAmount?.rawValue {
        segmentedControl.selectedSegmentIndex = index
        break
      }
      index += 1
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    imageView.image = UIImage.init(imageLiteralResourceName: imageName)
  }
  
  class func randomImageName() -> String {
    let sandwichNum = Int.random(in: 1...15)
    return "sandwich\(sandwichNum)"
  }
  
  @IBAction func sauceAmountChanged(_ sender: UISegmentedControl) {
    sauceAmount = SauceAmount(rawValue: sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "None")
  }
  
  @IBAction func cancelPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func savePressed(_ sender: Any) {
    
    guard let sandwichName = nameField.text,
      !sandwichName.isEmpty else {
        showAlertForMissingSandwichName()
        return
    }
    
    guard let sauceAmount = sauceAmount else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    if let sandwich = sandwich {
      if (sandwich.name != sandwichName) || (sandwich.sauceAmount.sauceAmount != sauceAmount) {
        editSandwich(sandwich, withName: sandwichName, sauceAmount: sauceAmount)
      }
      else {
        dismiss(animated: true, completion: nil)
      }
    }
    else {
      let newSandwich = SandwichData(name: sandwichName,
                                     sauceAmount: sauceAmount,
                                     imageName: imageName)
      saveSandwich(sandwich: newSandwich)
    }
  
  }
  
  func showAlertForMissingSandwichName() {
    let alert = UIAlertController(title: "Missing Name",
                                  message: "You need to enter a sandwich name!",
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  func showAlertForSandwichAlreadyExist() {
    let alert = UIAlertController(title: "Sandwich already exists",
                                  message: "You need to create a sandwich with different name or sauce!",
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }

  func saveSandwich(sandwich: SandwichData) {
    guard let dataSource = dataSource else {
      print("Oh no! The datasource is missing and I don't know where to put these sandwiches!")
      fatalError()
    }
    let doesSandwichExist = dataManager.checkIfSandwichExists(sandwich)
    if doesSandwichExist {
      showAlertForSandwichAlreadyExist()
    }
    else {
      dataSource.saveSandwich(sandwich)
      dismiss(animated: true, completion: nil)
    }

  }
  
  func editSandwich(_ sandwich: Sandwich, withName name: String, sauceAmount: SauceAmount) {
    guard let dataSource = dataSource else {
      print("Oh no! The datasource is missing and I don't know where to put these sandwiches!")
      fatalError()
    }
    let sandwichData = SandwichData(name: name, sauceAmount: sauceAmount, imageName: sandwich.imageName)
    let doesSandwichExist = dataManager.checkIfSandwichExists(sandwichData)
    if doesSandwichExist {
      showAlertForSandwichAlreadyExist()
    }
    else {
      dataSource.editSandwich(sandwich, withName: name, sauceAmount: sauceAmount)
      dismiss(animated: true, completion: nil)
    }

  }
  
}

extension AddSandwichViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}
