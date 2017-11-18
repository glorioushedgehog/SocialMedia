//
//  Login.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

// only used for encoding the user's info into json
// to send to server in the login() method in MessageService
struct Login: Codable {
    var name: String
    var password: String
}
