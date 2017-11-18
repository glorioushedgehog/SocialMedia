//
//  Message.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

struct Message: Codable {
    var user: String
    var text: String
    var date: Date
    // messages do not have to have imageURL's
    var imgURL: String?
    // id's are assigned by the server, so they must
    // be declared as optional here
    var id: String?
    // messages do not have to be replies
    var replyTo: String?
    // contains the usernames of all the users that liked
    // this message. usernames can be repeated.
    var likedBy: [String]
}
