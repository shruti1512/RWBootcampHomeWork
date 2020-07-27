//
//  NetworkingHandler.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

class Networking {
  
  typealias CategoryCompletionHandler = (Category?, NetworkError?) -> Void
  typealias ClueCompletionHandler = ([Clue]?, NetworkError?) -> Void

  static let sharedInstance = Networking()
  
  public static func getCategoryID(withCompletion completion: @escaping CategoryCompletionHandler) {
    
    guard let url = URL(string: "http://www.jservice.io/api/random") else {
      completion(nil, .failedRequest)
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      //Execute completion handler on main thread
      DispatchQueue.main.async {
        
        guard error == nil else {
          print("Failed request: \(error!.localizedDescription)")
          completion(nil, .failedRequest)
          return
        }
        
        guard let data = data else {
          print("No data returned")
          completion(nil, .noData)
          return
        }
        
        guard let response = response as? HTTPURLResponse else {
          print("Server error")
          completion(nil, .invalidResponse)
          return
        }
        
        guard (200...229).contains(response.statusCode) else {
          print("Failure response: \(response.statusCode)")
          completion(nil, .failedRequest)
          return
        }
        
        guard let mime = response.mimeType, mime == "application/json" else {
          print("Wrong MIME type! The data returned is not json.")
          completion(nil, .invalidResponse)
          return
        }
        
        do {
//          let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//          print(jsonObject)

          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let parsedJSON: [CategoryWrapper] = try decoder.decode([CategoryWrapper].self, from: data)
//          print(parsedJSON)
          guard let firstObject = parsedJSON.first else {
            completion(nil, .invalidData)
            return
          }
          completion(firstObject.category, nil)
          
        } catch {
          print("Unable to decode response: \(error.localizedDescription)")
          completion(nil, .invalidData)
        }
      }
    }.resume()
    
  }
  
  public static func getCluesForQuestion(withCategoryID categoryID: Int,
                                  withCompletion completion: @escaping ClueCompletionHandler) {
    
    guard let url = URL(string: "http://www.jservice.io/api/clues/?category=\(categoryID)") else {
      completion(nil, .failedRequest)
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      //Execute completion handler on main thread
      DispatchQueue.main.async {
        
        guard error == nil else {
          print("Failed request: \(error!.localizedDescription)")
          completion(nil, .failedRequest)
          return
        }
        
        guard let data = data else {
          print("No data returned")
          completion(nil, .noData)
          return
        }
        
        guard let response = response as? HTTPURLResponse else {
          print("Server error")
          completion(nil, .invalidResponse)
          return
        }
        
        guard (200...229).contains(response.statusCode) else {
          print("Failure response: \(response.statusCode)")
          completion(nil, .failedRequest)
          return
        }
        
        guard let mime = response.mimeType, mime == "application/json" else {
          print("Wrong MIME type! The data returned is not json.")
          completion(nil, .invalidResponse)
          return
        }
        
        do {
//          let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//          print(jsonObject)

          let decoder = JSONDecoder()
          let parsedJSON: [Clue] = try decoder.decode([Clue].self, from: data)
//          print(parsedJSON)
          completion(parsedJSON, nil)
          
        } catch {
          print("Unable to decode response: \(error.localizedDescription)")
          completion(nil, .invalidData)
        }
      }
    }.resume()

  }
  
  
}

