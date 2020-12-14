//
//  Message.swift
//  boonoob-ios-app
//
//  Created by ali on 8/21/20.
//  Copyright © 2020 Yves Songolo. All rights reserved.
//

import Foundation
import MessageKit



struct MessageKit: MessageType {
    var sender: SenderType {
        get {
            return user
        }
    }
    
    
    var user: Sender
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    private init(kind: MessageKind, user: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, user: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }

    init(attributedText: NSAttributedString, user: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date)
    }

    init(image: UIImage, user: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(thumbnail: UIImage, user: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date)
    }
    
}

private struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}



struct Message: Codable {
    var chatId, messageId: String
    var creationDateTime, text: String // 2020-09-19
    var authorAvatarId, authorName: String?
}

struct Chat: Codable {
    var chatId: String
    var movieName: String?
}
