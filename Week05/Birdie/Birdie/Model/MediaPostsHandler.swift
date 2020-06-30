//
//  MediaPosts.swift
//  Birdie
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

enum MediaPostsSortAttribute: String, CaseIterable {
  case dateOldestFirst = "Date (Oldest First)"
  case dateNewestFirst = "Date (Newest First)"
}

enum MediaPostsFilterAttribute: String, CaseIterable {
  case allPosts = "All Posts"
  case allTextPosts = "Text Posts"
  case allImagePosts = "Image Posts"
}

class MediaPostsHandler: NSObject {
  
    static let shared = MediaPostsHandler()
    var mediaPosts: [MediaPost] = []

    private override init() {
      super.init()
      self.addDummyPostsData()
    }

    private func addDummyPostsData() {
      let imagePost1 = ImagePost(textBody: "I love debugging software!", userName: "Jeff", timestamp: Date(timeIntervalSince1970: 10000), image: UIImage(named: "chop")!)
      let imagePost2 = ImagePost(textBody: "Went to the Aquarium today :]", userName: "Audrey", timestamp: Date(timeIntervalSince1970: 30000), image: UIImage(named: "octopus")!)
      let textPost1 = TextPost(textBody: "Hello World!", userName: "Bhagat", timestamp: Date(timeIntervalSince1970: 20000))
      let textPost2 = TextPost(textBody: "This is my favorite social media app!", userName: "Jay", timestamp: Date(timeIntervalSince1970: 40000))

        mediaPosts = [imagePost1, imagePost2, textPost1, textPost2]
        mediaPosts = mediaPosts.sorted(by: { $0.timestamp > $1.timestamp })
    }
  
    func deletePost(at index: Int) {
        mediaPosts.remove(at: index)
    }
  
    func addMediaPost(mediaPost: MediaPost) {
      mediaPosts.append(mediaPost)
      mediaPosts.sort { $0.timestamp > $1.timestamp }
    }
  
    func sortPostsBy(_ sortType: MediaPostsSortAttribute) {
      if sortType == .dateNewestFirst {
        mediaPosts.sort {$0.timestamp > $1.timestamp }
      }
      else {
        mediaPosts.sort {$0.timestamp < $1.timestamp }
      }
    }
    
  func filterPostsBy(_ filterType: MediaPostsFilterAttribute) -> [MediaPost] {
    switch filterType {
      case .allPosts:
        return self.mediaPosts
      case .allImagePosts:
        let imagePosts = mediaPosts.filter { ($0 as? ImagePost) != nil }
        return imagePosts
      case .allTextPosts:
        let textPosts = mediaPosts.filter { ($0 as? TextPost) != nil }
        return textPosts
    }
  }

  func searchMediaPostsBy(_ searchTerm: String) -> [MediaPost] {
    let filteredPosts = mediaPosts.filter { post in
      var postBodySearchResult = false
      if let textBody = post.textBody {
        postBodySearchResult = textBody.localizedCaseInsensitiveContains(searchTerm)
      }
      let postTitleSearchResult = post.userName.contains(searchTerm)
      return postTitleSearchResult || postBodySearchResult
    }
    return filteredPosts
  }

}

