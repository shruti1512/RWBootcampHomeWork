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

  //MARK: - IBOutlets

  private let mapView: MKMapView = {
    let map = MKMapView(frame: .zero)
    return map
  }()
  
  private lazy var nameLbl: UILabel = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .center
    label.backgroundColor = Colors.themeColor
    label.textColor = .white
    label.font = UIFont(name: "Arial Rounded MT Bold", size: 22.0)
    return label
  }()
  
  private lazy var cardView: CardView = {
    let view = CardView(frame: .zero)
    view.clipsToBounds = true
    return view
  }()

  private lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nameLbl, mapView])
    stack.axis = .vertical
    stack.distribution = .fill
    stack.alignment = .fill
    stack.spacing = 0
    return stack
  }()

  //MARK: - Properties

  var place: Restaurant?
  let annotationType = "Restaurant"
  
  //MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupNavigiationTitle()
    setupViews()
    setupLayout()
    showRestaurantAnnotationOnMap()
  }
  
  func setupViews() {
    view.addSubview(cardView)
    cardView.addSubview(stackView)
  }
  
  func setupLayout() {
    
    let safeArea = view.safeAreaLayoutGuide
    cardView.anchor(top: safeArea.topAnchor,
                    leading: safeArea.leadingAnchor,
                    bottom: safeArea.bottomAnchor,
                    trailing: safeArea.trailingAnchor,
                    padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    
    nameLbl.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2).isActive = true

    stackView.anchor(top: cardView.topAnchor,
                     leading: cardView.leadingAnchor,
                     bottom: cardView.bottomAnchor,
                     trailing: cardView.trailingAnchor)
  }
  
  func setupNavigiationTitle() {
    
    guard let place = place else { return }
    navigationItem.title = place.name
    nameLbl.text = place.name
  }
  
  func showRestaurantAnnotationOnMap() {
    
    guard let place = place else { return }
    let placeLocation = place.geometry.location
    let initialLocation = CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude)
    mapView.centerToLocation(initialLocation)
    mapView.showsUserLocation = true
    
    mapView.register(RestaurantAnnotationView.self,
                     forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    
    // Show restauarnt annotation on map
    let clLocation = CLLocationCoordinate2DMake(placeLocation.latitude, placeLocation.longitude)
    let annotation = RestaurantAnnotation(coordinate: clLocation, title: place.name, type: annotationType)
    mapView.addAnnotation(annotation)
  }
    
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
    
    guard let restaurant = view.annotation as? RestaurantAnnotation else {
      return
    }

    let launchOptions = [
      MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
    ]
    restaurant.mapItem?.openInMaps(launchOptions: launchOptions)
  }
  
}

//MARK: - MKMapView

private extension MKMapView {
  
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    
    let coordinateRegion = MKCoordinateRegion(
    center: location.coordinate,
    latitudinalMeters: regionRadius,
    longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
  
}
