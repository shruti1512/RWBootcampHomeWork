//
//  FindRestaurantsTests.swift
//  FindRestaurantsTests
//
//  Created by Shruti Sharma on 1/25/21.
//  Copyright © 2021 Shruti Sharma. All rights reserved.
//

import XCTest
@testable import FindRestaurants

class FindRestaurantsAsyncTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown()  {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_isCallToServer_Valid() {
      
      //1. Given
      let urlPath = """
      https://maps.googleapis.com/maps/api/place/nearbysearch/json?\
      location=lat,-long&radius=5000&type=restaurant&keyword=burrito&key=API_KEY
      """
      let url = URL(string: urlPath)!
      let expectation = self.expectation(description: "Status code is 200")
      
      //2. When
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        defer { expectation.fulfill() }
        XCTAssertNil(error)
        XCTAssertNotNil(data)
        do {
          let httpResponse = try XCTUnwrap(response as? HTTPURLResponse)
          XCTAssertEqual(httpResponse.statusCode, 200)
        }catch { }
      }
      .resume()
      
      wait(for: [expectation], timeout: 2)
    }

  func test_isCallToServer_InValid() {
    
    //1. Given
    let urlPath = """
    https://maps.googleaapis.com/maps/api/place/nearbysearch/json?\
    location=lat,-long&radius=5000&type=restaurant&keyword=burrito&key=API_KEY
    """
    let url = URL(string: urlPath)!
    let expectation = self.expectation(description: "No server response")
    
    //2. When
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      defer { expectation.fulfill() }
      XCTAssertNotNil(error)
      XCTAssertNil(data)
      XCTAssertNil(response)
    }
    .resume()
    
    wait(for: [expectation], timeout: 2)
  }

}
