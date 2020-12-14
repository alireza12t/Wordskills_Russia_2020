//
//  MovieList.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//

import Foundation


// MARK: - MovieListElement
struct MovieListElement: Codable {
    let movieID, name, movieListDescription, age: String
    let images: [String]
    let poster: String
    let tags: [Tag]

    enum CodingKeys: String, CodingKey {
        case movieID = "movieId"
        case name
        case movieListDescription = "description"
        case age, images, poster, tags
    }
}

