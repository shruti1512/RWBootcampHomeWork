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
  case badURL
}

class Networking {
  
  //MARK: - Properties

//  typealias CategoryCompletionHandler = (Result<Category, NetworkError>) -> Void
//  typealias ClueCompletionHandler = (Result<[Clue], NetworkError>) -> Void
  
  typealias CompletionHandler<T: Decodable> = (Result<T, NetworkError>) -> Void

//  private struct URLs {
//
//    private init() { }
//    static let categoryIdURL = "http://www.jservice.io/api/random"
//    static let cluesURL = "http://www.jservice.io/api/clues/?category="
//    static let cluesURLScheme = "http"
//    static let cluesURLHost = "www.jservice.io"
//    static let cluesURLPath = "/api/clues/"
//    static let cluesURLQueryItemCategory = "category"
//    static let cluesURLQueryItemOffset = "offset"
//  }
  
  //MARK: - Get Catgeory From JService API

  static func fetchData<T: Decodable>(for url: URL?,
                                      completion: @escaping CompletionHandler<T>) {
    guard let url = url else {
      completion(.failure(.badURL))
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      //Executing completion handler on main thread
      DispatchQueue.main.async {
        
        guard error == nil else {
          print("Failed request: \(error!.localizedDescription)")
          completion(.failure(.failedRequest))
          return
        }
        
        guard let data = data else {
          print("No data returned")
          completion(.failure(.noData))
          return
        }
        
        guard let response = response as? HTTPURLResponse else {
          print("Server error")
          completion(.failure(.invalidResponse))
          return
        }
        
        guard (200...229).contains(response.statusCode) else {
          print("Failure response: \(response.statusCode)")
          completion(.failure(.failedRequest))
          return
        }
        
        print("response.mimeType: \(response.mimeType)")
//        guard let mime = response.mimeType, mime == "application/json" else {
//          print("Wrong MIME type! The data returned is not json.")
//          completion(.failure(.invalidResponse))
//          return
//        }
        
        do {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let parsedJSON = try decoder.decode(T.self, from: data)
          completion(.success(parsedJSON))
        } catch {
          print("Unable to decode response: \(error.localizedDescription)")
          completion(.failure(.invalidData))
        }
      }
    }.resume()
  }
  
//  public static func getCategoryID(withCompletion completion: @escaping CategoryCompletionHandler) {
//
//    guard let url = URL(string: URLs.categoryIdURL) else {
//      completion(.failure(.badURL))
//      return
//    }
//
//    URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//      //Executing completion handler on main thread
//      DispatchQueue.main.async {
//
//        guard error == nil else {
//          print("Failed request: \(error!.localizedDescription)")
//          completion(.failure(.failedRequest))
//          return
//        }
//
//        guard let data = data else {
//          print("No data returned")
//          completion(.failure(.noData))
//          return
//        }
//
//        guard let response = response as? HTTPURLResponse else {
//          print("Server error")
//          completion(.failure(.invalidResponse))
//          return
//        }
//
//        guard (200...229).contains(response.statusCode) else {
//          print("Failure response: \(response.statusCode)")
//          completion(.failure(.failedRequest))
//          return
//        }
//
//        guard let mime = response.mimeType, mime == "application/json" else {
//          print("Wrong MIME type! The data returned is not json.")
//          completion(.failure(.invalidResponse))
//          return
//        }
//
//        do {
//          let decoder = JSONDecoder()
//          decoder.keyDecodingStrategy = .convertFromSnakeCase
//          let parsedJSON: [CategoryWrapper] = try decoder.decode([CategoryWrapper].self, from: data)
//          guard let firstObject = parsedJSON.first else {
//            completion(.failure(.invalidData))
//            return
//          }
//          completion(.success(firstObject.category))
//
//        } catch {
//          print("Unable to decode response: \(error.localizedDescription)")
//          completion(.failure(.invalidData))
//        }
//      }
//    }.resume()
//
//  }
//
//  //MARK: - Get Clues From JService API
//
//  public static func getCluesForQuestion(withCategoryID categoryID: String,
//                                         offset: String,
//                                         onCompletion completion: @escaping ClueCompletionHandler) {
//
//    var urlBuilder = URLComponents()
//    urlBuilder.scheme = URLs.cluesURLScheme
//    urlBuilder.host = URLs.cluesURLHost
//    urlBuilder.path = URLs.cluesURLPath
//    urlBuilder.queryItems = [
//      URLQueryItem(name: URLs.cluesURLQueryItemCategory, value: categoryID),
//      URLQueryItem(name: URLs.cluesURLQueryItemOffset, value: offset)]
//
//    guard let url = urlBuilder.url else {
//      completion(.failure(.badURL))
//      return
//    }
//
//    URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//      //Executing completion handler on main thread
//      DispatchQueue.main.async {
//
//        guard error == nil else {
//          print("Failed request: \(error!.localizedDescription)")
//          completion(.failure(.failedRequest))
//          return
//        }
//
//        guard let data = data else {
//          print("No data returned")
//          completion(.failure(.noData))
//          return
//        }
//
//        guard let response = response as? HTTPURLResponse else {
//          print("Server error")
//          completion(.failure(.invalidResponse))
//          return
//        }
//
//        guard (200...229).contains(response.statusCode) else {
//          print("Failure response: \(response.statusCode)")
//          completion(.failure(.failedRequest))
//          return
//        }
//
//        guard let mime = response.mimeType, mime == "application/json" else {
//          print("Wrong MIME type! The data returned is not json.")
//          completion(.failure(.invalidResponse))
//          return
//        }
//
//        do {
////          let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
////          print(jsonObject)
//
//          let decoder = JSONDecoder()
//          let parsedJSON: [Clue] = try decoder.decode([Clue].self, from: data)
//          completion(.success(parsedJSON))
//
//        } catch {
//          print("Unable to decode response: \(error.localizedDescription)")
//          completion(.failure(.invalidData))
//        }
//      }
//    }.resume()
//
//  }
  
  
}

