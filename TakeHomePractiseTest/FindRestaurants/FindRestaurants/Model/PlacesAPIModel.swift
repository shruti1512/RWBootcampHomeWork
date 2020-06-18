//
//  Restaurant.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/12/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: - PriceLevel Enumeration

enum PriceLevel: Int {
  case Free = 0
  case Inexpensive = 1
  case Moderate = 2
  case Expensive = 3
  case VeryExpensive = 4
}

//MARK: - PlaceSearchAPIModel Model

struct PlaceSearchAPIModel: Decodable {
  let results: [Restaurant]
}

//MARK: - Restaurant Model

struct Restaurant {
  let name: String
  let address: String
  let priceLevel: Int?
  let rating: Float?
  var geometry: Geometry
  
  var distanceFromCurrentLocation: Double? {
    
    guard let userLoc = LocationManager.shared.currentLocation else {
      return nil
    }
    let placeLocation = CLLocation(latitude: geometry.location.latitude, longitude: geometry.location.longitude)
    let currentLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
    let distanceInMetres = currentLocation.distance(from: placeLocation)
    return round(100 * distanceInMetres * 0.000621371) / 100

  }
}

extension Restaurant: Decodable {
  enum CodingKeys: String, CodingKey {
      case name
      case address = "vicinity"
      case priceLevel = "price_level"
      case rating
      case geometry
  }
}

//MARK: - Geometry Model

struct Geometry: Decodable {
  let location: Location
}

//MARK: - PlacesAPIParameter Model

struct PlacesAPIParameter {
  let location: Location
  let radius: String
  let type: String
  let keyword: String
}

//MARK: - Location Model

struct Location {
  var latitude: Double = 0
  var longitude: Double = 0
}

extension Location: Decodable {
  enum CodingKeys: String, CodingKey {
    case latitude = "lat"
    case longitude = "lng"
  }
}
