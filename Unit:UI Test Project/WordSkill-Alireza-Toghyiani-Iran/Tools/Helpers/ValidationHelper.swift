//
//  ValidationHelper.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//

import Foundation


class ValidationHelper {
    class func validateEmail(_ email: String) -> Bool {
            let regExp = "[a-z0-9]+@[a-z0-9]+.[a-z]+"
            let regex = try! NSRegularExpression(pattern: regExp)
            let range = NSRange(location: 0, length: email.count)
            return regex.firstMatch(in: email , options: [], range: range) != nil
    }
}
