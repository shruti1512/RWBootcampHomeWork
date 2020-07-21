//
//  Helper.swift
//  SandwichSaturation
//
//  Created by Shruti Sharma on 7/16/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import Foundation


// MARK:-  Get unique elements from a Sequence

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return filter { seen.insert($0).inserted }
  }
}

// MARK:-  Binary Search on a collection sorted in ascending

extension RandomAccessCollection where Element : Comparable {
  
  func insertionIndexAscending(of value: Element) -> Index {
    var slice : SubSequence = self[...]
    
    while !slice.isEmpty {
      let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
      if value < slice[middle] {
        slice = slice[..<middle]
      } else {
        slice = slice[index(after: middle)...]
      }
    }
    return slice.startIndex
  }
  
  // MARK:-  Binary Search on a collection sorted in descending
  
  func insertionIndexDescending(of value: Element) -> Index {
    var slice : SubSequence = self[...]
    
    while !slice.isEmpty {
      
      let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
      
      if value < slice[middle] {
        slice = slice[index(after: middle)...]
      } else {
        slice = slice[..<middle]
      }
    }
    return slice.startIndex
  }
  
}
