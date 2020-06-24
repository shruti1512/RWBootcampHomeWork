//
//  AvatarList.swift
//  Compatibility
//
//  Created by Shruti Sharma on 6/23/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation

class AvatarList {
  
  let avatars: [String]!
  
  init() {
    var maleAvatars = [String]()
    for i in 1...8 {
      let imageName = "male_00\(i)"
      maleAvatars.append(imageName)
    }
    var femaleAvatars = [String]()
    for i in 1...8 {
      let imageName = "female_00\(i)"
      femaleAvatars.append(imageName)
    }
    self.avatars = maleAvatars + femaleAvatars
  }

}
