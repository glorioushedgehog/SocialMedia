//
//  DirectMessage.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

struct DirectMessage: Codable {
    var to: String
    var from: String
    var message: Message
}
