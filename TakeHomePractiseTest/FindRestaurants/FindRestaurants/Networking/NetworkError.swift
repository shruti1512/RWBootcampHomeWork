//
//  NetworkError.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 8/28/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  
  case invalidURL
  case invalidResponse
  case noData
  case failedRequest
  case decodingFailure

  var errorDescription: String {
    
    switch self {
      case .decodingFailure:
        return "Network Failure: Error occurred while decoding data."
      case .invalidURL:
        return "Network Failure: Invaild URL."
      case .failedRequest:
        return "Network Failure: Failed request."
      case .invalidResponse:
        return "Network Failure: Unsuccessful HTTP response or incorrect mime type."
      case .noData:
        return "Network Failure: No data returned from the api."
    }
  }
  
}
