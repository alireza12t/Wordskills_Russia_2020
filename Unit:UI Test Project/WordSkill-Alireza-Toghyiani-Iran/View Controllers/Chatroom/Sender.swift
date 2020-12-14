//
//  User.swift
//  boonoob-ios-app
//
//  Created by ali on 8/21/20.
//  Copyright © 2020 Yves Songolo. All rights reserved.
//

import Foundation
import MessageKit


struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
    
    var avatarID: String?
}

