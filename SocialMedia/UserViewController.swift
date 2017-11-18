//
//  UserViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/13/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// show the direct messages from this user and allow
// the user to send direct messages to this user
class UserViewController: UIViewController {
    
    // the username of this user
    var user: String = ""
    
    // all the direct messages that this user has sent
    // to the user
    var messages: [DirectMessage] = []
    
    // show the username of this user
    @IBOutlet weak var userLabel: UILabel!
    
    // recieve the text of the direct messages to be sent
    // to this user
    @IBOutlet weak var newMessageTextField: UITextField!
    
    // recieve the imageURL of the direct messages to be sent
    // to this user
    @IBOutlet weak var imageURLTextField: UITextField!

    // display all the direct messages recieved from this user in a table
    @IBOutlet weak var feedTableView: UITableView!
    
    // detect the user pressing to send button
    @IBAction func sendButtonTapped(_ sender: Any) {
        sendDirectMessage()
    }
    
    // retrieve the direct messages from the server
    func getMessages() {
        MessageService.sharedMessageService.getDirect() { (messages) in
            DispatchQueue.main.async {
                if let mess = messages {
                    self.setMessages(directMessages: mess)
                }
                // tell user that the messages are no longer being
                // retrieved whether or not the retrieval was successful
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // get the direct messages that are from this user
    // and ignore all other direct messages
    func setMessages(directMessages: [DirectMessage]) {
        var relevantMessages = [DirectMessage]()
        for dm in directMessages {
            if dm.from == user {
                relevantMessages.append(dm)
            }
        }
        self.messages = relevantMessages.reversed()
        // put the messages in the table view
        self.feedTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        // detect the user pulling down on the table to
        // refresh the direct messages
        feedTableView.addSubview(self.refreshControl)
        newMessageTextField.delegate = self
        imageURLTextField.delegate = self
        // tell the user what direct message history is being
        // displayed
        userLabel.text = "Messages from " + user
        // fill the table view with the correct messages
        getMessages()
    }
    
    // prepare to detect the user pulling down on the table view
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    // detect the user pulling down on the table view and refresh the messages
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getMessages()
    }
    
    // send the direct message the user has written to the server
    func sendDirectMessage() {
        let message: Message
        let messageText = self.newMessageTextField.text ?? ""
        // get the user's username from UserDefaults
        let user = UserStorage.shared.getUsername()
        if let givenImageURL = self.imageURLTextField.text {
            // avoid sending an empty string as an imageURL
            if givenImageURL == "" {
                message = Message(user: user, text: messageText, date: Date(), imgURL: nil, id: nil, replyTo: nil, likedBy: [])
            }else{
                message = Message(user: user, text: messageText, date: Date(), imgURL: givenImageURL, id: nil, replyTo: nil, likedBy: [])
            }
        }else{
            message = Message(user: user, text: messageText, date: Date(), imgURL: nil, id: nil, replyTo: nil, likedBy: [])
        }
        // make this message a direct message
        let directMessage = DirectMessage(to: self.user, from: user, message: message)
        MessageService.sharedMessageService.postDirect(directMessage: directMessage) { (success) in
            if success {
                DispatchQueue.main.async {
                    // clear out the text fields to make it easier
                    // for the user to send a new message and to
                    // inform them that the sending of their direct
                    // message was successful
                    self.newMessageTextField.text = ""
                    self.imageURLTextField.text = ""
                }
            }
        }
        // remove the keyboard while the message is sending
        newMessageTextField.resignFirstResponder()
        imageURLTextField.resignFirstResponder()
    }
}

extension UserViewController: UITableViewDataSource {
    
    // since all direct message will be displayed in UserFeedCells, there is only one section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // there will be exactly one direct message per UserFeedCell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // configure each UserFeedCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as! UserFeedCell
        cell.configure(directMessage: message)
        return cell
    }
}

extension UserViewController: UITextFieldDelegate {
    
    // send the user's direct message when the return key on the
    // keyboard is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendDirectMessage()
        return true
    }
    
    // allow the user to stop editing either of the text fields
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

