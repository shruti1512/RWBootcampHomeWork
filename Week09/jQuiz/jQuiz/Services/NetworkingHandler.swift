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
  
  //MARK: - Properties

  typealias CategoryCompletionHandler = (Category?, NetworkError?) -> Void
  typealias ClueCompletionHandler = ([Clue]?, NetworkError?) -> Void
  
  private struct URLs {
    
    private init() { }
    static let categoryIdURL = "http://www.jservice.io/api/random"
    static let cluesURL = "http://www.jservice.io/api/clues/?category="
    static let cluesURLScheme = "http"
    static let cluesURLHost = "www.jservice.io"
    static let cluesURLPath = "/api/clues/"
    static let cluesURLQueryItemCategory = "category"
    static let cluesURLQueryItemOffset = "offset"
  }

  //MARK: - Shared Instance

  public static let shared = Networking()
  private init() { }
  
  //MARK: - Get Catgeory From JService API

  public func getCategoryID(withCompletion completion: @escaping CategoryCompletionHandler) {
    
    guard let url = URL(string: URLs.categoryIdURL) else {
      completion(nil, .failedRequest)
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      //Executing completion handler on main thread
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
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let parsedJSON: [CategoryWrapper] = try decoder.decode([CategoryWrapper].self, from: data)
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
  
  //MARK: - Get Clues From JService API
  
  public func getCluesForQuestion(withCategoryID categoryID: String,
                                         offset: String,
                                         onCompletion completion: @escaping ClueCompletionHandler) {
    
    var urlBuilder = URLComponents()
    urlBuilder.scheme = URLs.cluesURLScheme
    urlBuilder.host = URLs.cluesURLHost
    urlBuilder.path = URLs.cluesURLPath
    urlBuilder.queryItems = [
      URLQueryItem(name: URLs.cluesURLQueryItemCategory, value: categoryID),
      URLQueryItem(name: URLs.cluesURLQueryItemOffset, value: offset)]
    
    guard let url = urlBuilder.url else {
      completion(nil, .failedRequest)
      return
    }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      //Executing completion handler on main thread
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
          completion(parsedJSON, nil)
          
        } catch {
          print("Unable to decode response: \(error.localizedDescription)")
          completion(nil, .invalidData)
        }
      }
    }.resume()

  }
  
  
}

