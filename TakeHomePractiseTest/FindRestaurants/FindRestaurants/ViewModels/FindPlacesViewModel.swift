//
//  FindPlacesViewModel.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 1/23/21.
//  Copyright © 2021 Shruti Sharma. All rights reserved.
//

import Foundation

protocol FindPlacesViewModelDelegate: class {
  func findPlacesViewModel(_ viewModel: FindPlacesViewModel,
                           didFinishFetchingPlaces response: Result<(), Error>)
  func showAlertForLocationFailure()
}

class FindPlacesViewModel {
  
  var restaurants = Observable([Restaurant]())
  
  var selectedPlace: Restaurant?
  let radius = "5000"
  let placeType = "restaurant"
  let keyword = "burrito"

  weak var delegate: FindPlacesViewModelDelegate?
  
  init() {
    requestUserAuthorizationForLocation()
    registerForLocationSuccess()
    registerForLocationFailed()
  }
  
  //MARK: - Request User Authorization From Location Manager
  
  func requestUserAuthorizationForLocation() {
    let locationMngr = LocationManager.shared
    locationMngr.requestUserAuthorization()
  }
  
  //MARK: - Fetch Places Data from NetworkService Manager
  
  @objc func getPlacesForLocation() {
    
    guard let currentLocation = LocationManager.shared.currentLocation else { return }
    
    let parameterModel = PlacesAPIParameter(location: currentLocation,
                                            radius: radius,
                                            type: placeType,
                                            keyword: keyword)
    // Implemented using Boxing
//    NetworkServices.getPlacesDataFor(parameterModel) { [weak self] result in
//
//      guard let self = self else { return }
//
//      switch result {
//      case .failure(let error):
//        print("Error fetching neraby places \(error.localizedDescription)")
//      case .success(let placesAPIModel):
//        self.restaurants.value = placesAPIModel.results
//      }
//    }
    
    //Implemented using Delegation
    APIClient.getPlacesDataFor(parameterModel) { [weak self] result in

      guard let self = self else { return }

      switch result {
      case .failure(let error):
        self.delegate?.findPlacesViewModel(self, didFinishFetchingPlaces: .failure(error))
      case .success(let placesAPIModel):
        self.restaurants.value = placesAPIModel.results
        self.delegate?.findPlacesViewModel(self, didFinishFetchingPlaces: .success(()))
      }
    }
  }
}

extension FindPlacesViewModel {
  
  @objc func showAlertForLocationFailure() {
    delegate?.showAlertForLocationFailure()
  }
  
  func numberOfRestaurants() -> Int {
    restaurants.value.count
  }
  
  func restaurantAt(_ index: Int) -> Restaurant {
    restaurants.value[index]
  }

  func nameForRestaurantAt(_ index: Int) -> String {
    restaurants.value[index].name
  }

  func addressForRestaurantAt(_ index: Int) -> String {
    restaurants.value[index].address
  }
  
  func ratingTextForRestaurantAt(_ index: Int) -> String {
    if let rating = restaurants.value[index].rating {
      return "\(Double(rating))"
    }
    else {
      return "No rating avaialable"
    }
  }
  
  func ratingDoubleForRestaurantAt(_ index: Int) -> Double? {
    if let rating = restaurants.value[index].rating {
      return Double(rating)
    }
    else {
      return nil
    }
  }

  func captionForRestaurantAt(_ index: Int) -> String {
    var distanceText = ""
    if let distance = restaurants.value[index].distanceFromCurrentLocation {
       distanceText = " \u{2022} " + String(distance) + " mi"
    }
    return (restaurants.value[index].priceLevel?.priceText ?? "") + distanceText
  }

}

//MARK: - LocationProtocol

extension FindPlacesViewModel: LocationProtocol {
  
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


