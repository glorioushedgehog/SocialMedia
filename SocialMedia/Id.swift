//
//  Id.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

// only used to decode the server's response to
// a login request made by the login() method in
// MessageService
struct Id: Codable {
    var token: String
}
