//
//  SearchResult.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 27/04/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Codable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    let screenshotUrls: [String]?
    let artworkUrl100: String
    var formattedPrice: String?
    let description: String?
    var releaseNotes: String?
    var artistName: String?
    var collectionName: String?
}
