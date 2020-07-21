//
//  JSONParser.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/16/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import Foundation

enum FileError: String, Error {
  case fileNotFound
}

//JSON Parser class to decode json from a json file in bundle

class JSONParser<Model: Decodable>  {
  
   func loadDataFromJSONFile( _ fileName: String) -> [Model]? {
    guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
      print("JSON file \(fileName) not found in Bundle.")
      print("\(FileError.fileNotFound) : \(fileName)")
      return nil
    }
    
    let decoder = JSONDecoder()
    do {
      let data = try Data(contentsOf: fileURL)
      let jsonData = try decoder.decode([Model].self, from: data)
      return jsonData
    } catch {
      print(error)
    }
    return nil
  }
}
