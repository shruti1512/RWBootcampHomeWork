//
//  CompatibilityTests.swift
//  CompatibilityTests
//
//  Created by Shruti Sharma on 6/22/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import XCTest
@testable import Compatibility

class CompatibilityTests: XCTestCase {

  var sut: ComptibilityLogic!
  
  override func setUpWithError() throws {
      // Put setup code here. This method is called before the invocation of each test method in the class.
    try super.setUpWithError()
  }

  override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
    sut = nil
    super.tearDown()
  }

  func testCalculateCompatibilityScoreIs100() {
    //1. Given
    let compatibilityItems = ["cat", "dog"]
    let person1 = Person(id: 1, profileImage: "", items: ["cat" : 0.5, "dog": 0.9])
    let person2 = Person(id: 2, profileImage: "", items: ["cat" : 0.5, "dog": 0.9])
    sut = ComptibilityLogic(person1: person1, person2: person2, compatibilityItems: compatibilityItems)

    //2. When
    let score = sut.calculateCompatibilityScore()
    
    //3. Then
    XCTAssertEqual(score, "100%", "Calculated score is incorrect. Expected: 100% and Actual: \(score)")
  }
  
  func testCalculateCompatibilityScoreIs0() {
    //1. Given
    let compatibilityItems = ["cat", "dog"]
    let person1 = Person(id: 1, profileImage: "", items: ["cat" : 0.0, "dog": 1.0])
    let person2 = Person(id: 2, profileImage: "", items: ["cat" : 1.0, "dog": 0.0])
    sut = ComptibilityLogic(person1: person1, person2: person2, compatibilityItems: compatibilityItems)

    //2. When
    let score = sut.calculateCompatibilityScore()
    
    //3. Then
    XCTAssertEqual(score, "0%", "Calculated score is incorrect. Expected: 0% and Actual: \(score)")
  }

  func testCalculateCompatibilityScoreIs50() {
    //1. Given
    let compatibilityItems = ["cat", "dog"]
    let person1 = Person(id: 1, profileImage: "", items: ["cat" : 0.0, "dog": 1.0])
    let person2 = Person(id: 2, profileImage: "", items: ["cat" : 0.0, "dog": 0.0])
    sut = ComptibilityLogic(person1: person1, person2: person2, compatibilityItems: compatibilityItems)

    //2. When
    let score = sut.calculateCompatibilityScore()
    
    //3. Then
    XCTAssertEqual(score, "50%", "Calculated score is incorrect. Expected: 50% and Actual: \(score)")
  }
  
  func testCalculateCompatibilityScoreIs25() {
    //1. Given
    let compatibilityItems = ["cat", "dog"]
    let person1 = Person(id: 1, profileImage: "", items: ["cat" : 0.0, "dog": 1.0])
    let person2 = Person(id: 2, profileImage: "", items: ["cat" : 0.5, "dog": 0.0])
    sut = ComptibilityLogic(person1: person1, person2: person2, compatibilityItems: compatibilityItems)

    //2. When
    let score = sut.calculateCompatibilityScore()
    
    //3. Then
    XCTAssertEqual(score, "25%", "Calculated score is incorrect. Expected: 25% and Actual: \(score)")
  }
  
  func testCalculateCompatibilityScoreIs75() {
    //1. Given
    let compatibilityItems = ["cat", "dog"]
    let person1 = Person(id: 1, profileImage: "", items: ["cat" : 0.0, "dog": 1.0])
    let person2 = Person(id: 2, profileImage: "", items: ["cat" : 0.0, "dog": 0.5])
    sut = ComptibilityLogic(person1: person1, person2: person2, compatibilityItems: compatibilityItems)

    //2. When
    let score = sut.calculateCompatibilityScore()
    
    //3. Then
    XCTAssertEqual(score, "75%", "Calculated score is incorrect. Expected: 75% and Actual: \(score)")
  }


}
