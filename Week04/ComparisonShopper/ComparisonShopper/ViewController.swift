//
//  ViewController.swift
//  ComparisonShopper
//
//  Created by Jay Strawn on 6/15/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Left
    @IBOutlet weak var titleLabelLeft: UILabel!
    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var priceLabelLeft: UILabel!
    @IBOutlet weak var roomLabelLeft: UILabel!

    // Right
    @IBOutlet weak var titleLabelRight: UILabel!
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var priceLabelRight: UILabel!
    @IBOutlet weak var roomLabelRight: UILabel!

    var house1: House?
    var house2: House?

    override func viewDidLoad() {
        super.viewDidLoad()
        house1 = House(address: "400 ABC Street", price: "$12,000", bedrooms: "3 bedrooms")
        setUpLeftSideUI()
        setUpRightSideUI()
    }

    func setUpLeftSideUI() {
      /* There were four issues for the crash.
      1. The code was trying to access house1 which was nil as it was not initilaized.
      2. The code was trying to access address property of house1 which was nil as it was not set.
      3. roomLabelLeft was nil as the respective IBOutlet wasn't hooked up in IB..
      4. setUpLeftSideUI() was called before the properties for house1 object were set and thus the code here was trying to access the properties of a nil object
      */
      guard let house1 = house1 else {
        return
      }
      titleLabelLeft.text = house1.address
      priceLabelLeft.text = house1.price
      roomLabelLeft.text = house1.bedrooms
    }

    func setUpRightSideUI() {
      /* The data for house2 details was not visible after adding the item because the properties (titleLabelRight, imageViewRight, priceLabelRight, roomLabelRight) all had alpha 0.0. */
      let uiControls: [UIView] = [titleLabelRight, imageViewRight, priceLabelRight, roomLabelRight]
        if house2 == nil {
          uiControls.forEach { $0.alpha = 0.0 }
        } else {
          titleLabelRight.text! = house2!.address!
          priceLabelRight.text! = house2!.price!
          roomLabelRight.text! = house2!.bedrooms!
          uiControls.forEach { $0.alpha = 1.0 }
        }
    }

    @IBAction func didPressAddRightHouseButton(_ sender: Any) {
        openAlertView()
    }

    func openAlertView() {
        let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.placeholder = "address"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "price"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "bedrooms"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            var house = House()
            house.address = alert.textFields?[0].text
            house.price = alert.textFields?[1].text
            house.bedrooms = alert.textFields?[2].text
            self.house2 = house
            self.setUpRightSideUI()
        }))

        self.present(alert, animated: true, completion: nil)
    }

}

struct House {
    var address: String?
    var price: String?
    var bedrooms: String?
}

