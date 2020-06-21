//
//  Restaurant.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/12/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: - PlaceSearchAPIModel Model

struct PlaceSearchAPIModel: Decodable {
  let results: [Restaurant]
}

//MARK: - Restaurant Model

struct Restaurant {
  
  enum PriceLevel: Int, Decodable {
    case Free = 0
    case Inexpensive = 1
    case Moderate = 2
    case Expensive = 3
    case VeryExpensive = 4
  }

  let name: String
  let address: String
  let rating: Float? // Define a key as optional if it can be returned as `nil` or if it does not always exist in the JSON.
  let priceLevel: PriceLevel?
  var geometry: Geometry
  
  var distanceFromCurrentLocation: Double? {
    
    guard let userLoc = LocationManager.shared.currentLocation else {
      return nil
    }
    let placeLocation = CLLocation(latitude: geometry.location.latitude, longitude: geometry.location.longitude)
    let currentLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
    let distanceInMetres = currentLocation.distance(from: placeLocation)
    let meterToMiles: Double = 0.000621371
    return round(100 * distanceInMetres * meterToMiles) / 100
  }
}

extension Restaurant: Decodable {
  
  // To define custom mapping for JSON keys, i.e, different names for the JSON keys
  enum CodingKeys: String, CodingKey {
      case name, priceLevel, rating, geometry
      case address = "vicinity" // Map the JSON key "vicinity" to the Swift property name "address"
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
