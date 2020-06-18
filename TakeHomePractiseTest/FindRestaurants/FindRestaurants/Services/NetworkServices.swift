//
//  NetworkManager.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 6/12/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import Keys

enum NetworkError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

class NetworkServices {
    
  typealias PlacesAPIDataCompletion = (PlaceSearchAPIModel?, NetworkError?) -> ()
  
  static func getPlacesDataFor(_ parameters: PlacesAPIParameter, completion: @escaping PlacesAPIDataCompletion) {
        
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=34.1010979,-118.1261898&radius=5000&type=restaurant&keyword=burrito&key=AIzaSyCV-K9JmLTaUad1TVTzIMwcumpR7HkP-qs
        
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
      completion(nil, .failedRequest)
      return
    }
    print("url: \(url)")
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
    
      //Execute completion handler on main thread
      DispatchQueue.main.async {
        guard error == nil else {
            print("Failed request from Google Maps Nearby Places API: \(error!.localizedDescription)")
            completion(nil, .failedRequest)
            return
          }
          
          guard let data = data else {
            print("No data returned from Google Maps Nearby Places API")
            completion(nil, .noData)
            return
          }

          guard let response = response as? HTTPURLResponse else {
            print("Server error")
            completion(nil, .invalidResponse)
            return
          }
          
          guard (200...229).contains(response.statusCode) else {
            print("Failure response from Google Maps Nearby Places API: \(response.statusCode)")
            completion(nil, .failedRequest)
            return
          }
          
          guard let mime = response.mimeType, mime == "application/json" else {
            print("Wrong MIME type! The data returned is not json.")
            completion(nil, .invalidResponse)
            return
          }

          do {
            let decoder = JSONDecoder()
//            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//            print(jsonObject)
            let parsedJSON: PlaceSearchAPIModel = try decoder.decode(PlaceSearchAPIModel.self, from: data)
//            print(parsedJSON.results)
            completion(parsedJSON, nil)
          } catch {
            print("Unable to decode Google Maps Nearby Places API response: \(error.localizedDescription)")
            completion(nil, .invalidData)
          }
        }
    }.resume()
  }
  
}

