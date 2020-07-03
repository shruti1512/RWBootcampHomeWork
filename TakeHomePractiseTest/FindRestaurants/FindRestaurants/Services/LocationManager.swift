//
//  CurrentLocation.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/16/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: - LocationProtocol Declaration

protocol LocationProtocol {
  func registerForLocationSuccess()
  func registerForLocationFailed()
  func unregisterForLocation()
}

//MARK: - Notification.Name

extension Notification.Name {
  static let UserLocationFetchSuccessful = Notification.Name("UserLocationFetchSuccessful")
  static let UserLocationFetchFailed = Notification.Name("UserLocationFetchFailed")
}

//MARK: - LocationManager

class LocationManager: NSObject {
  
  //MARK:  Properties

  static let shared = LocationManager()
  let manager = CLLocationManager()
  
  public var currentLocation: Location? {
      didSet {
        NotificationCenter.default.post(name: .UserLocationFetchSuccessful, object: nil)
      }
  }
  
  //MARK: - Initilaizer

  private override init() {
    super.init()
  }
  
  //MARK: - Request User Authorization for Location Services

  public func requestUserAuthorization() {
    
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    manager.delegate = self
    let status = CLLocationManager.authorizationStatus()

    if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
      // show alert to user telling them they need to allow location data to use some feature of your app
    }
    
    // if haven't show location permission dialog before, show it to user
    if status == .notDetermined {
      // request permission to get user location when the app is in use (ie. active)
      // this will show an alert box to the user
      manager.requestWhenInUseAuthorization()
      return
    }

    // at this point the authorization status is authorized
    // request location data once
    manager.requestLocation()
  }

}

//MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
  
  // After user tap on 'Allow' or 'Disallow' on the dialog
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if(status == .authorizedWhenInUse || status == .authorizedAlways){
      manager.requestLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    // .requestLocation will only pass one location to the locations array
    // hence we can access it by taking the first element of the array
    if let location = locations.first {
      currentLocation = Location(latitude: Double(location.coordinate.latitude),
                                 longitude: Double(location.coordinate.longitude))
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      // might be that user didn't enable location service on the device
      // or there might be no GPS signal inside a building
    NotificationCenter.default.post(name: .UserLocationFetchFailed, object: nil)
  }
}
