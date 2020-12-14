//
//  AgeColorHelper.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/23/20.
//  Copyright © 2020 ali. All rights reserved.
//

import UIKit


class AgeColorHelper {
    class func ageColor(for age: Int) -> UIColor {
        switch age {
        case 0 ... 5:
            return .white
        case 6 ... 10:
            return .systemPink
        case 11 ... 16:
            return .systemOrange
        case 16 ... 18:
            return .red
        default:
            return .red
        }
    }
}
