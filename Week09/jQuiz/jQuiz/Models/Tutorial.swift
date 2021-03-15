//
//  Tutorial.swift
//  InterviewPracticeTest
//
//  Created by Shruti Sharma on 2/17/21.
//

import Foundation

enum ContentType: String {
  case article = "article"
  case video = "video"
}

struct TutorialCollection: Codable {
  let data: [TutorialData]
}

struct TutorialData: Codable {
  let attributes: Tutorial
}

struct Tutorial: Codable, Hashable {
  let name: String
//  let artworkUrl: String
//  let description: String
//  let type: String
//  let releasedAt: Date
//  let duration: Int
//  let technology: String
  
//  enum CodingKeys: String, CodingKey {
//    case name
//    case artworkUrl = "card_artwork_url"
//    case description
//    case type = "content_type"
//    case releasedAt = "released_at"
//    case duration
//    case technology = "technology_triple_string"
//  }

//  var contentType: ContentType? {
//    ContentType(rawValue: type)
//  }
}

