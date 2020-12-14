//
//  LastWatch.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//

import Foundation

// MARK: - LastWatchElement
struct LastWatchElement: Codable {
    let movieID: Int
    let name, lastWatchDescription, age: String
    let images: [String]
    let poster: String
    let tags: [Tag]

    enum CodingKeys: String, CodingKey {
        case movieID = "movieId"
        case name
        case lastWatchDescription = "description"
        case age, images, poster, tags
    }
}


typealias LastWatch = [LastWatchElement]
