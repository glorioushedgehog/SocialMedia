//
//  UserStorage.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/16/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

class UserStorage {
    
    static var shared = UserStorage()
    
    func isReady() -> Bool {
        return UserDefaults.standard.string(forKey: "username") != nil && UserDefaults.standard.string(forKey: "token") != nil
    }
    
    func saveUserInfo(username: String, token: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
    func getUsername() -> String {
        return UserDefaults.standard.string(forKey: "username")!
    }
    
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: "token")!
    }
}
