//
//  RestaurantTableViewController.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/12/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit
import Keys

class RestaurantTableViewController: UITableViewController {

  //MARK: - Properties
  
  var restaurants = [Restaurant]()
  var selectedPlace: Restaurant!
  var dataSource: TableViewDataSouce!
  var delegate: TableViewDelegate!
  let radius = "5000"
  let placeType = "restaurant"
  let keyword = "burrito"
  let navigationBarTitle = "Burrito Places"

  //MARK: - View Controller Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = navigationBarTitle
    requestUserAuthorizationForLocation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    registerForLocationSuccess()
    registerForLocationFailed()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForLocation()
  }
  
  //MARK: - Get Places Data from NetworkService

  func requestUserAuthorizationForLocation() {
    let locationMngr = LocationManager.shared
    locationMngr.requestUserAuthorization()
  }
  
  @objc func getPlacesForLocation() {
    
    guard let currentLocation = LocationManager.shared.currentLocation else { return }
    
      let parameterModel = PlacesAPIParameter(location: currentLocation,
                                              radius: radius,
                                              type: placeType,
                                              keyword: keyword)
      NetworkServices.getPlacesDataFor(parameterModel) { [weak self] (placesAPIModel, error) in
      guard let self = self, let placesAPIModel = placesAPIModel else {
        return
      }
      self.restaurants = placesAPIModel.results
      let dataSource = TableViewDataSouce(places: self.restaurants,
                                          reuseIdentifier: RestaurantTableViewCell.reuseIdentifier)
      self.dataSource = dataSource
      self.tableView.dataSource = self.dataSource

      let delegate = TableViewDelegate(places: self.restaurants) { (selectedRow) in
        self.selectedPlace = self.restaurants[selectedRow]
        self.performSegue(withIdentifier: "MapVC", sender: nil)
      }
      self.delegate = delegate
      self.tableView.delegate = delegate
      
      self.tableView.reloadData()
    }
  }
    
  @objc func showAlertForLocationFailure() {
    
  }

  //MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationVC = segue.destination as? MapViewController {
      destinationVC.place = selectedPlace
    }
  }
  
}

//MARK: - LocationProtocol

extension RestaurantTableViewController: LocationProtocol {
  
  func registerForLocationSuccess() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(getPlacesForLocation),
                                           name: .UserLocationFetchSuccessful,
                                           object: nil)
  }
  
  func registerForLocationFailed() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(showAlertForLocationFailure),
                                           name: .UserLocationFetchFailed,
                                           object: nil)
  }

  func unregisterForLocation() {
    NotificationCenter.default.removeObserver(self)
  }
  
}

