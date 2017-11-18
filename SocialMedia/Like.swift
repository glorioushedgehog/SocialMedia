//
//  Like.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

// only used for encoding a message ID into json for
// sending a like to the server in postLike() in
// MessageService
struct Like: Codable {
    var likedMessageID: String
}
