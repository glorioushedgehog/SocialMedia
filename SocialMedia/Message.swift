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
    var imgURL: String?
    var id: String?
    var replyTo: String?
    var likedBy: [String]
}
