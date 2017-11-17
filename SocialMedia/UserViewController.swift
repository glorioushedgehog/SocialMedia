//
//  UserViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/13/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    var user: String = ""
    
    var messages: [DirectMessage] = []
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var newMessageTextField: UITextField!
    
    @IBOutlet weak var imageURLTextField: UITextField!

    @IBOutlet weak var feedTableView: UITableView!
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        sendDirectMessage()
    }
    
    func getMessages() {
        MessageService.sharedMessageService.getDirect() { (messages) in
            DispatchQueue.main.async {
                if let mess = messages {
                    self.setMessages(directMessages: mess)
                }
            }
        }
    }
    
    func setMessages(directMessages: [DirectMessage]) {
        var relevantMessages = [DirectMessage]()
        for dm in directMessages {
            if dm.from == user {
                relevantMessages.append(dm)
            }
        }
        self.messages = relevantMessages.reversed()
        self.feedTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        feedTableView.addSubview(self.refreshControl)
        newMessageTextField.delegate = self
        imageURLTextField.delegate = self
        userLabel.text = user
        getMessages()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        //refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getMessages()
        self.refreshControl.endRefreshing()
    }
    
    func sendDirectMessage() {
        let message: Message
        let messageText = self.newMessageTextField.text ?? ""
        let user = UserStorage.shared.getUsername()
        if let givenImageURL = self.imageURLTextField.text {
            if givenImageURL == "" {
                message = Message(user: user, text: messageText, date: Date(), imgURL: nil, id: nil, replyTo: nil, likedBy: [])
            }else{
                message = Message(user: user, text: messageText, date: Date(), imgURL: givenImageURL, id: nil, replyTo: nil, likedBy: [])
            }
        }else{
            return
        }
        let directMessage = DirectMessage(to: self.user, from: user, message: message)
        MessageService.sharedMessageService.postDirect(directMessage: directMessage) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.newMessageTextField.text = ""
                    self.imageURLTextField.text = ""
                }
            }
        }
        newMessageTextField.resignFirstResponder()
        imageURLTextField.resignFirstResponder()
    }
}

extension UserViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as! UserFeedCell
        cell.configure(directMessage: message)
        return cell
    }
}

extension UserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendDirectMessage()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

