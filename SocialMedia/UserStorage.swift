//
//  UserStorage.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/16/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

// Manage local storage of the user's info
class UserStorage {
    
    // avoid making a new instance of UserStorage for
    // every user
    static var shared = UserStorage()
    
    // tell whether the user's username and token ID
    // are stored locally, in which case messages can be
    // retrieved and sent
    func userIsLoggedIn() -> Bool {
        return UserDefaults.standard.string(forKey: "username") != nil && UserDefaults.standard.string(forKey: "token") != nil
    }
    
    // save the user's username and token ID to UserDefaults
    func saveUserInfo(username: String, token: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(token, forKey: "token")
        // ensure that the username and token are ready to be retrieved
        UserDefaults.standard.synchronize()
    }
    
    // return the user's username from UserDefaults
    func getUsername() -> String {
        return UserDefaults.standard.string(forKey: "username")!
    }
    
    // return the user's token ID from UserDefaults
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: "token")!
    }
}
