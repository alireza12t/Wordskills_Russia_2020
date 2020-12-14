//
//  UserData.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/19/20.
//  Copyright © 2020 ali. All rights reserved.
//

import Foundation


struct User: Codable {
    var firstName, lastName, email: String
    var userId, avatarId: String?
}
