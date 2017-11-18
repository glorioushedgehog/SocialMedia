//
//  NewMessageViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// allows the user to send a new message
class NewMessageViewController: UIViewController {
    
    // recieves the text of the new message
    @IBOutlet weak var newMessageTextField: UITextField!
    
    // recieves the imageURL (if any) of the new message
    @IBOutlet weak var imageURLTextField: UITextField!
    
    // detect the screen being tapped to close the keyboard if it is open
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        newMessageTextField.resignFirstResponder()
        imageURLTextField.resignFirstResponder()
    }
    
    // detect the user pressing the send button
    @IBAction func sendButtonTapped(_ sender: Any) {
        sendMessage()
    }
    
    // send the message after determining if it has an imageURL
    func sendMessage() {
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
        // send the new message
        MessageService.sharedMessageService.postMessage(message: message) { (success) in
            if success {
                DispatchQueue.main.async {
                    // clear out the text fields to make it
                    // easy for the user to enter a new message
                    // and to tell them that the sending of their
                    // message was successful
                    self.newMessageTextField.text = ""
                    self.imageURLTextField.text = ""
                }
            }
        }
        // get rid of the keyboard while the message is being sent
        newMessageTextField.resignFirstResponder()
        imageURLTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // detect the screen being tapped to allow the user to close the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewMessageViewController.screenTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
        newMessageTextField.delegate = self
        imageURLTextField.delegate = self
    }
}
extension NewMessageViewController: UITextFieldDelegate {
    // detect the return button on either text field being tapped to send the message
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }

    // allow the user to stop editing either of the text fields
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
