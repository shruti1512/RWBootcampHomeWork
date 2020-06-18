//
//  RestaurantANnotationView.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/17/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit
import MapKit

class RestaurantAnnotationView: MKMarkerAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      
      guard let restaurant = newValue as? RestaurantAnnotation else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(
        origin: CGPoint.zero,
        size: CGSize(width: 48, height: 48)))
      mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
      rightCalloutAccessoryView = mapsButton
      glyphImage = restaurant.image
      markerTintColor = restaurant.markerTintColor
    }
  }

}
