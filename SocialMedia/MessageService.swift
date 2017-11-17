//
//  MessageService.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import Foundation

class MessageService {

    var mainURL = "https://obscure-crag-65480.herokuapp.com"
    
    //var tokenId = "D0D4DD66-0EDA-4F74-97E0-E39A7503FF9B"

    static var sharedMessageService = MessageService()

    func getUserList(completion: @escaping ([String]?) -> ()) {
        let getURL = URL(string: mainURL + "/users")!
        var getReq = URLRequest(url: getURL)
        getReq.httpMethod = "GET"
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
            completion(String(data: data!, encoding: .utf8) == "[\"success\"]")
        }
        postTask.resume()
    }

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
            completion(String(data: data!, encoding: .utf8) == "[\"success\"]")
        }
        postTask.resume()
    }

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
            completion(String(data: data!, encoding: .utf8) == "[\"success\"]")
        }
        postTask.resume()
    }
}
