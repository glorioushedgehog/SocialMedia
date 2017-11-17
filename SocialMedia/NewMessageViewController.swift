//
//  NewMessageViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {
    
    @IBOutlet weak var newMessageTextField: UITextField!
    
    @IBOutlet weak var imageURLTextField: UITextField!
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        newMessageTextField.resignFirstResponder()
        imageURLTextField.resignFirstResponder()
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        sendMessage()
    }
    
    func sendMessage() {
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
        MessageService.sharedMessageService.postMessage(message: message) { (success) in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewMessageViewController.screenTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
        newMessageTextField.delegate = self
        imageURLTextField.delegate = self
    }
}
extension NewMessageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
