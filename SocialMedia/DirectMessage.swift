//
//  DirectMessage.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

struct DirectMessage: Codable {
    // the username of the user that recieved the direct message
    var to: String
    // the username of the user that sent the direct message
    var from: String
    var message: Message
}
