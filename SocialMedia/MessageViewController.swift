//
//  MessageViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    var message: Message?

    static var dateFormatter = DateFormatter()
    
    @IBOutlet weak var replyMessageTextField: UITextField!
    
    @IBOutlet weak var replyImageURLTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var likeCount: Int = 0
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        self.replyMessageTextField.resignFirstResponder()
        self.replyImageURLTextField.resignFirstResponder()
    }
    
    func reply() {
        let message: Message
        let messageText = self.replyMessageTextField.text ?? ""
        let user = UserStorage.shared.getUsername()
        if let givenImageURL = self.replyImageURLTextField.text {
            if givenImageURL == "" {
                message = Message(user: user, text: messageText, date: Date(), imgURL: nil, id: nil, replyTo: self.message!.id!, likedBy: [])
            }else{
                message = Message(user: user, text: messageText, date: Date(), imgURL: givenImageURL, id: nil, replyTo: self.message!.id!, likedBy: [])
            }
        }else{
            return
        }
        MessageService.sharedMessageService.postMessage(message: message) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.replyMessageTextField.text = ""
                    self.replyImageURLTextField.text = ""
                }
            }
        }
        replyMessageTextField.resignFirstResponder()
        replyImageURLTextField.resignFirstResponder()
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        reply()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        MessageService.sharedMessageService.postLike(messageID: (message?.id)!) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.likeCount += 1
                    self.likeCountLabel.text = self.likeCount.description
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.replyMessageTextField.delegate = self
        self.replyImageURLTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewMessageViewController.screenTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
        MessageViewController.dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        self.usernameLabel.text = self.message?.user
        self.dateLabel.text = MessageViewController.dateFormatter.string(from: (self.message?.date)!)
        self.messageLabel.text = self.message?.text
        self.likeCount = self.message?.likedBy.count ?? 0
        self.likeCountLabel.text = self.likeCount.description
    }
}

extension MessageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reply()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
