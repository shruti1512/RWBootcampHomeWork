//
//  AddSandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

class AddSandwichViewController: UIViewController {
  
  //MARK: - IBOutlets

  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var navigationBar: UINavigationBar!
  
  //MARK: - Properties

  var imageName: String
  var sauceAmount: SauceAmount!
  var sandwich: Sandwich?
  var isDataUpdated = false
  var dataSource: SandwichDataSource?
  public var dataManager: DataManager? = nil
  
  //MARK: - Initializer

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    fatalError("init() has not been implemented")
  }
  
  required init?(dataManager: DataManager, dataSource: SandwichDataSource) {
    self.dataManager = dataManager
    self.dataSource = dataSource
    imageName = AddSandwichViewController.randomImageName()
    sauceAmount = SauceAmount.none
    super.init(nibName: nil, bundle: nil)
  }
  
  //MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    loadSandwich()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    imageView.image = UIImage.init(imageLiteralResourceName: imageName)
  }
  
  //MARK: - Set up data

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
  
  class func randomImageName() -> String {
    let sandwichNum = Int.random(in: 1...15)
    return "sandwich\(sandwichNum)"
  }
  
  //MARK: - IBActions

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
  
  //MARK: - Show AlertViewController

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

  //MARK: - Save & Edit Sandwich

  func saveSandwich(sandwich: SandwichData) {
    guard let dataSource = dataSource else {
      print("Oh no! The datasource is missing and I don't know where to put these sandwiches!")
      fatalError()
    }
    if let doesSandwichExist = dataManager?.checkIfSandwichExists(sandwich),
       doesSandwichExist == true {
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
    if let doesSandwichExist = dataManager?.checkIfSandwichExists(sandwichData),
       doesSandwichExist == true {
      showAlertForSandwichAlreadyExist()
    }
    else {
      dataSource.editSandwich(sandwich, withName: name, sauceAmount: sauceAmount)
      dismiss(animated: true, completion: nil)
    }
  }
  
}

//MARK: - UITextFieldDelegate

extension AddSandwichViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}
