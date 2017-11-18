//
//  MessageService.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

// communicate with the API
class MessageService {
    
    var mainURL = "https://obscure-crag-65480.herokuapp.com"

    // avoid instantiating this class every time a request is made
    static var sharedMessageService = MessageService()

    // fetch the list of users so that the user can choose a user
    // to send a dm to
    func getUserList(completion: @escaping ([String]?) -> ()) {
        let getURL = URL(string: mainURL + "/users")!
        var getReq = URLRequest(url: getURL)
        getReq.httpMethod = "GET"
        // get the token saved when the user logged in
        // from UserDefaults, where it is unsecurely stored.
        // this will be done for all API communication except logging in
        let tokenId = UserStorage.shared.getToken()
        getReq.addValue(tokenId, forHTTPHeaderField: "token")
        let getTask = URLSession(configuration: .ephemeral).dataTask(with: getReq) { (data, response, error) in
            guard data != nil else { completion(nil); return }
            if error != nil { completion(nil); return }
            let users = try? JSONDecoder().decode([String].self, from: data!)
            completion(users)
        }
        getTask.resume()
    }
    
    // retrieve the array of message that will be displayed in FeedViewController's table view
    func getMessages(completion: @escaping ([Message]?) -> ()) {
        let getURL = URL(string: mainURL + "/messages")!
        var getReq = URLRequest(url: getURL)
        getReq.httpMethod = "GET"
        let tokenId = UserStorage.shared.getToken()
        getReq.addValue(tokenId, forHTTPHeaderField: "token")
        let getTask = URLSession(configuration: .ephemeral).dataTask(with: getReq) { (data, response, error) in
            guard data != nil else { completion(nil); return }
            if error != nil { completion(nil); return }
            let messages = try? JSONDecoder().decode([Message].self, from: data!)
            completion(messages)
        }
        getTask.resume()
    }
    
    // get the token from the server after the user has provided their username and password
    func login(username: String, password: String, completion: @escaping (String?) -> ()) {
        let postURL = URL(string: mainURL + "/login")!
        var request = URLRequest(url: postURL)
        let login = Login(name: username, password: password)
        request.httpBody = try! JSONEncoder().encode(login)
        request.httpMethod = "POST"
        let postTask = URLSession(configuration: .ephemeral).dataTask(with: request) { (data, response, error) in
            guard data != nil else { completion(nil); return }
            if error != nil { completion(nil); return }
            let uuid = try! JSONDecoder().decode(Id.self, from: data!)
            completion(uuid.token)
        }
        postTask.resume()
    }
    
    // send a message to the server
    func postMessage(message: Message, completion: @escaping (Bool) -> ()) {
        let postURL = URL(string: mainURL + "/messages")!
        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        let tokenId = UserStorage.shared.getToken()
        request.addValue(tokenId, forHTTPHeaderField: "token")
        request.httpBody = try! JSONEncoder().encode(message)
        let postTask = URLSession(configuration: .ephemeral).dataTask(with: request) { (data, response, error) in
            guard data != nil else { completion(false); return }
            if error != nil { completion(false); return }
            // check whether the server's response indicates that the post was successful
            completion(String(data: data!, encoding: .utf8) == "[\"success\"]")
        }
        postTask.resume()
    }
    
    // retrieve direct messages to display in UserViewController
    func getDirect(completion: @escaping ([DirectMessage]?) -> ()) {
        let getURL = URL(string: mainURL + "/direct")!
        var getReq = URLRequest(url: getURL)
        getReq.httpMethod = "GET"
        let tokenId = UserStorage.shared.getToken()
        getReq.addValue(tokenId, forHTTPHeaderField: "token")
        let getTask = URLSession(configuration: .ephemeral).dataTask(with: getReq) { (data, response, error) in
            guard data != nil else { completion(nil); return }
            if error != nil { completion(nil); return }
            let directMessages = try? JSONDecoder().decode([DirectMessage].self, from: data!)
            completion(directMessages)
        }
        getTask.resume()
    }
    
    // send a direct message
    func postDirect(directMessage: DirectMessage, completion: @escaping (Bool) -> ()) {
        let postURL = URL(string: mainURL + "/direct")!
        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        let tokenId = UserStorage.shared.getToken()
        request.addValue(tokenId, forHTTPHeaderField: "token")
        request.httpBody = try! JSONEncoder().encode(directMessage)
        let postTask = URLSession(configuration: .ephemeral).dataTask(with: request) { (data, response, error) in
            guard data != nil else { completion(false); return }
            if error != nil { completion(false); return }
            // check whether the server's response indicates that the post was successful
            completion(String(data: data!, encoding: .utf8) == "[\"success\"]")
        }
        postTask.resume()
    }

    // post a like to the server
    func postLike(messageID: String, completion: @escaping (Bool) -> ()) {
        let postURL = URL(string: mainURL + "/like")!
        var request = URLRequest(url: postURL)
        let like = Like(likedMessageID: messageID)
        request.httpMethod = "POST"
        let tokenId = UserStorage.shared.getToken()
        request.addValue(tokenId, forHTTPHeaderField: "token")
        request.httpBody = try! JSONEncoder().encode(like)
        let postTask = URLSession(configuration: .ephemeral).dataTask(with: request) { (data, response, error) in
            guard data != nil else { completion(false); return }
            if error != nil { completion(false); return }
            // check whether the server's response indicates that the post was successful
            completion(String(data: data!, encoding: .utf8) == "[\"success\"]")
        }
        postTask.resume()
    }
}
