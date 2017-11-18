//
//  MessageViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// display a detail view of a message which allows the user to reply
// to the message
class MessageViewController: UIViewController {
    
    var message: Message?

    // used for formatting the date at which the message was sent
    static var dateFormatter = DateFormatter()
    
    // where the user can input the text of their reply
    @IBOutlet weak var replyMessageTextField: UITextField!
    
    // where the user can input the imageURL for their reply
    @IBOutlet weak var replyImageURLTextField: UITextField!
    
    // the username of the user who posted the message
    @IBOutlet weak var usernameLabel: UILabel!
    
    // the date at which the message was posted
    @IBOutlet weak var dateLabel: UILabel!

    // the message itself
    @IBOutlet weak var messageLabel: UILabel!
    
    // allow the user to like the message
    @IBOutlet weak var likeButton: UIButton!
    
    // show how many likes the message has recieved
    @IBOutlet weak var likeCountLabel: UILabel!
    
    // keep track of the number of likes to avoid
    // unecessary parsing of strings into ints
    var likeCount: Int = 0
    
    // detect screen taps so the user can close the keyboard.
    // note: this will not be called if the tap is inside
    // either of the textFields
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        self.replyMessageTextField.resignFirstResponder()
        self.replyImageURLTextField.resignFirstResponder()
    }
    
    // send the user's reply to the message
    func reply() {
        let message: Message
        let messageText = self.replyMessageTextField.text ?? ""
        // get the user's username from UserDefaults
        let user = UserStorage.shared.getUsername()
        // determine whether or not there is an imageURL for this message
        if let givenImageURL = self.replyImageURLTextField.text {
            // avoid sending an empty string as an imageURL
            if givenImageURL == "" {
                message = Message(user: user, text: messageText, date: Date(), imgURL: nil, id: nil, replyTo: self.message!.id!, likedBy: [])
            }else{
                message = Message(user: user, text: messageText, date: Date(), imgURL: givenImageURL, id: nil, replyTo: self.message!.id!, likedBy: [])
            }
        }else{
            message = Message(user: user, text: messageText, date: Date(), imgURL: nil, id: nil, replyTo: self.message!.id!, likedBy: [])
        }
        MessageService.sharedMessageService.postMessage(message: message) { (success) in
            if success {
                DispatchQueue.main.async {
                    // empty the text field's to allow the user
                    // to enter a new message and to inform them
                    // that the sending of their reply was successful
                    self.replyMessageTextField.text = ""
                    self.replyImageURLTextField.text = ""
                }
            }
        }
        // close the keyboard while the message is sending
        replyMessageTextField.resignFirstResponder()
        replyImageURLTextField.resignFirstResponder()
    }
    
    // detect the user tapped the reply button
    @IBAction func replyButtonTapped(_ sender: Any) {
        reply()
    }
    
    // post a like to this message if the user taps the like button
    @IBAction func likeButtonTapped(_ sender: Any) {
        MessageService.sharedMessageService.postLike(messageID: (message?.id)!) { (success) in
            if success {
                DispatchQueue.main.async {
                    // update the like count to inform the user
                    // that the sending of their like was successful
                    self.likeCount += 1
                    self.likeCountLabel.text = self.likeCount.description
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // prepare to detect the return key on the keyboard being pressed
        self.replyMessageTextField.delegate = self
        self.replyImageURLTextField.delegate = self
        // detect the user tapping the screen to close the keyboard if it is open
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewMessageViewController.screenTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
        // format the date at which the message was sent
        MessageViewController.dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        // display all the information about the message
        self.usernameLabel.text = self.message?.user
        self.dateLabel.text = MessageViewController.dateFormatter.string(from: (self.message?.date)!)
        self.messageLabel.text = self.message?.text
        self.likeCount = self.message?.likedBy.count ?? 0
        self.likeCountLabel.text = self.likeCount.description
    }
}

extension MessageViewController: UITextFieldDelegate {
    
    // detect the return key being pressed, which will send the user's reply to the message
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reply()
        return true
    }
    
    // allow the user to stop editing either of the text fields
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
