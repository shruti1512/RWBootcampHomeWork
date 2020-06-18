//
//  MapViewController.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/12/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

  @IBOutlet private var mapView: MKMapView!
  @IBOutlet private var nameLbl: UILabel!

  var place: Restaurant!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      navigationItem.title = place.name
      nameLbl.text = place.name
      
      let placeLocation = place.geometry.location
      let initialLocation = CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude)
      mapView.centerToLocation(initialLocation)
      mapView.showsUserLocation = true
      
      mapView.register(RestaurantAnnotationView.self,
                       forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
      
      // Show restauarnt annotation on map
      let clLocation = CLLocationCoordinate2DMake(placeLocation.latitude, placeLocation.longitude)
      let annotation = RestaurantAnnotation(coordinate: clLocation, title: place.name, type: "Restaurant")
      mapView.addAnnotation(annotation)

    }
}


extension MapViewController: MKMapViewDelegate {
    
  func mapView(
    _ mapView: MKMapView,
    annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl
  ) {
    guard let restaurant = view.annotation as? RestaurantAnnotation else {
      return
    }

    let launchOptions = [
      MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
    ]
    restaurant.mapItem?.openInMaps(launchOptions: launchOptions)
  }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
