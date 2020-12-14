//
//  Episodes.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/19/20.
//  Copyright © 2020 ali. All rights reserved.
//

import Foundation



struct Episode: Codable {
    var episodeId, runtime, name, description, director, year, preview, filePath: String?

    var stars, images: [String]?
  }

typealias Episodes = [Episode]

