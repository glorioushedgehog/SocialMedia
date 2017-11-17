//
//  FeedViewCell.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell {
    
    static var dateFormatter = DateFormatter()
    
    var message: Message?

    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    var likeCount: Int = 0
    
    override func prepareForReuse() {
        self.messageImageView.image = nil
        self.imageViewHeight.constant = 0
        self.userLabel.text = nil
        self.dateLabel.text = nil
        self.messageLabel.text = nil
    }

    func configure(message: Message) {
        self.message = message
        FeedViewCell.dateFormatter.dateFormat = "MMM d, yyyy"
        self.userLabel.text = message.user
        self.dateLabel.text = FeedViewCell.dateFormatter.string(from: message.date)
        self.messageLabel.text = message.text
        self.likeCount = message.likedBy.count
        self.likeCountLabel.text = self.likeCount.description
        if let imageURLString = message.imgURL {
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
}
