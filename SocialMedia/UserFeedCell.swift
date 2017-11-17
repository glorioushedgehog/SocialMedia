//
//  UserFeedCell.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/13/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class UserFeedCell: UITableViewCell {
    
    static var dateFormatter = DateFormatter()
    
    var directMessage: DirectMessage?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    var likeCount: Int = 0
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        MessageService.sharedMessageService.postLike(messageID: (self.directMessage?.message.id)!) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.likeCount += 1
                    self.likeCountLabel.text = self.likeCount.description
                }
            }
        }
    }
    
    override func prepareForReuse() {
        self.messageImageView.image = nil
        self.imageViewHeight.constant = 0
        self.dateLabel.text = nil
        self.messageLabel.text = nil
    }
    
    func configure(directMessage: DirectMessage) {
        self.directMessage = directMessage
        UserFeedCell.dateFormatter.dateFormat = "MMM d, yyyy"
        self.dateLabel.text = UserFeedCell.dateFormatter.string(from: directMessage.message.date)
        self.messageLabel.text = directMessage.message.text
        self.likeCount = directMessage.message.likedBy.count
        self.likeCountLabel.text = self.likeCount.description
        if let imageURLString = directMessage.message.imgURL {
            let imageURL = URL(string: imageURLString)
            ImageService.shared.imageForURL(url: imageURL) { (image, url) in
                if url == imageURL {
                    if let img = image {
                        let ratio = img.size.height / img.size.width
                        self.imageViewHeight.constant = self.messageImageView.frame.width * ratio
                        self.messageImageView.image = img
                    }
                }
            }
        }
    }
}

