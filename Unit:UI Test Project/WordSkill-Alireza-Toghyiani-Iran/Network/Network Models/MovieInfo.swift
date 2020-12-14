//
//  MovieInfo.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//

import Foundation


// MARK: - MovieInfo
struct MovieInfo: Codable {
    let movieID: String
    let name, movieInfoDescription, age: String
    let images: [String]
    let poster: String
    let tags: [Tag]

    enum CodingKeys: String, CodingKey {
        case movieID = "movieId"
        case name
        case movieInfoDescription = "description"
        case age, images, poster, tags
    }
}
