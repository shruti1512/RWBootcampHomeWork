//
//  NetworkManager.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/12/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import Keys

//Class marked as final to prevent inheritance from other classes

final class APIClient {
    
  typealias PlacesAPIDataCompletion = (Result<PlaceSearchAPIModel, NetworkError>) -> Void
  
  //MARK: - Fetch Nearby Places Data Using Google Maps API

  static func getPlacesDataFor(_ parameters: PlacesAPIParameter, completion: @escaping PlacesAPIDataCompletion) {
        
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=lat,-long&radius=5000&type=restaurant&keyword=burrito&key=API_KEY
        
    let apiKey = FindRestaurantsKeys().findRestaurantsGoogleMapsAPIKey
    
    var urlBuilder = URLComponents()
    urlBuilder.scheme = "https"
    urlBuilder.host = GoogleMapsAPI.placesAPIHost
    urlBuilder.path = GoogleMapsAPI.placsAPIPath
    urlBuilder.queryItems = [
      URLQueryItem(name: "location", value: "\(parameters.location.latitude),\(parameters.location.longitude)"),
      URLQueryItem(name: "radius", value: parameters.radius),
      URLQueryItem(name: "type", value: parameters.type),
      URLQueryItem(name: "keyword", value: parameters.keyword),
      URLQueryItem(name: "key", value: apiKey)
    ]
  
    guard let url = urlBuilder.url else {
      completion(.failure(.invalidURL))
      return
    }
    print("url: \(url)")
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
    
      //Execute completion handler on main thread
      DispatchQueue.main.async {
        guard error == nil else {
            print("Failed request from Google Maps Nearby Places API: \(error!.localizedDescription)")
            completion(.failure(.failedRequest))
            return
          }
          
          guard let data = data else {
            print("No data returned from Google Maps Nearby Places API")
            completion(.failure(.noData))
            return
          }

          guard let response = response as? HTTPURLResponse else {
            print("Server error")
            completion(.failure(.invalidResponse))
            return
          }
          
          guard (200...229).contains(response.statusCode) else {
            print("Failure response from Google Maps Nearby Places API: \(response.statusCode)")
            completion(.failure(.failedRequest))
            return
          }
          
          guard let mime = response.mimeType, mime == "application/json" else {
            print("Wrong MIME type! The data returned is not json.")
            completion(.failure(.invalidResponse))
            return
          }

          do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let parsedJSON: PlaceSearchAPIModel = try decoder.decode(PlaceSearchAPIModel.self, from: data)
            completion(.success(parsedJSON))
          } catch {
            print("Unable to decode Google Maps Nearby Places API response: \(error.localizedDescription)")
            completion(.failure(.decodingFailure))
          }
        }
    }.resume()
  }
  
}

