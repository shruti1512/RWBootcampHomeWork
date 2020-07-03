//
//  RestaurantAnnotation.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/16/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class RestaurantAnnotation: NSObject, MKAnnotation {
  
  //MARK: - Properties
  
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var type: String
  var markerTintColor: UIColor = UIColor(red: 108/255, green: 17/255, blue: 255/255, alpha: 1.0)
  
  var mapItem: MKMapItem? {
    
    guard let title = title else { return nil }

    let addressDict = [CNPostalAddressStreetKey: title]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }

  var image: UIImage {

    switch type {
    case "Restauarant":
      return #imageLiteral(resourceName: "icons8-restaurant")
    default:
      return #imageLiteral(resourceName: "icons8-restaurant")
    }
  }

  //MARK: - Initializer

  init(coordinate: CLLocationCoordinate2D, title: String?, type: String) {
    self.coordinate = coordinate
    self.title = title
    self.type = type
    super.init()
  }

}
