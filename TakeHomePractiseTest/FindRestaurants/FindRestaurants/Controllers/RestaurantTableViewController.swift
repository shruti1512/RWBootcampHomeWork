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
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - Properties
  let navigationBarTitle = "Burrito Places"
  let reuseIdentifier = "RestaurantTableViewCell"
  let viewModel = FindPlacesViewModel()
  
  // MARK: - View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = navigationBarTitle
    viewModel.delegate = self
    configureTableView()
    //setupViewModelDataBindings()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.registerForLocationSuccess()
    viewModel.registerForLocationFailed()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.unregisterForLocation()
  }
  
  // MARK: - SetupView and ViewModel Bindings

  func setupViewModelDataBindings() {
    viewModel.restaurants.bind { [weak self] places in
      guard let self = self else { return }
      self.tableView.reloadData()
    }
  }
  
  private func configureTableView() {
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 180
    tableView.separatorStyle = .none
    tableView.register(RestaurantTableViewCell.self,
                       forCellReuseIdentifier: RestaurantTableViewCell.reuseIdentifier)
  }
    
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? MapViewController,
      let cell = sender as? RestaurantTableViewCell else {
        return
    }
    guard let selectedIndexPath = self.tableView.indexPath(for: cell) else { return }
    destinationVC.place = viewModel.restaurantAt(selectedIndexPath.row)
  }
  
}

// MARK: - UITableViewDataSource

extension RestaurantTableViewController {
  
  override func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRestaurants()
  }

  override func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
              as? RestaurantTableViewCell else {
        fatalError("Could not create cell")
      }
    cell.addressLbl.text = viewModel.addressForRestaurantAt(indexPath.row)
    cell.captionLbl.text = viewModel.captionForRestaurantAt(indexPath.row)
    cell.nameLbl.text = viewModel.nameForRestaurantAt(indexPath.row)
    cell.ratingLbl.text = viewModel.ratingTextForRestaurantAt(indexPath.row)
    if let ratingDouble =  viewModel.ratingDoubleForRestaurantAt(indexPath.row) {
      cell.ratingView.rating = ratingDouble
    }
    else {
      cell.ratingView.isHidden = true
    }
    return cell
  }

}

// MARK: - UITableViewDelegate

extension RestaurantTableViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let mapVC = MapViewController()
    mapVC.place = viewModel.restaurantAt(indexPath.row)
    navigationController?.pushViewController(mapVC, animated: true)
  }
}

extension RestaurantTableViewController: FindPlacesViewModelDelegate {
  
  func findPlacesViewModel(_ viewModel: FindPlacesViewModel,
                           didFinishFetchingPlaces response: Result<(), Error>) {
    switch response {
    case .failure(let error):
      print(error.localizedDescription)
      self.showAlert(withTitle: "Error", message: "Unable to fetch nearby restaurants.")
    case .success(()):
      self.tableView.reloadData()
    }
  }
  
  @objc func showAlertForLocationFailure() {
    self.showAlert(withTitle: "Error", message: "Unable to fetch current location.")
  }
  
}

