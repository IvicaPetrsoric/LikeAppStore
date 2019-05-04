//
//  Reviews.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 04/05/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import Foundation

struct Reviews: Codable {
    let feed: ReviewFeed
}

struct ReviewFeed: Codable {
    let entry: [Entry]
}

struct Entry: Codable {
    let author: Author
    let title: Label
    let content: Label
}

struct Author: Codable {
    let name: Label
    
}

struct Label: Codable {
    let label: String
}
