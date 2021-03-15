//
//  Observable.swift
//  FindRestaurants
//
//  Created by Shruti Sharma on 1/23/21.
//  Copyright © 2021 Shruti Sharma. All rights reserved.
//

import Foundation

class Observable<T> {
  
  typealias Listener = (T) -> Void
  
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
