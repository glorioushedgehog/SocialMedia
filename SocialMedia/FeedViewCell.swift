//
//  FeedViewCell.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell {
    
    // used to format the date at which the message was sent
    static var dateFormatter = DateFormatter()
    
    var message: Message?
    
    // shows who sent this message
    @IBOutlet weak var userLabel: UILabel!
    
    // shows when the message was sent
    @IBOutlet weak var dateLabel: UILabel!
    
    // shows the message
    @IBOutlet weak var messageLabel: UILabel!
    
    // shows the image corresponding to this message's imageURL, if any
    @IBOutlet weak var messageImageView: UIImageView!
    
    // tells how many times the message has been liked
    @IBOutlet weak var likeCountLabel: UILabel!
    
    // specifies the height of messageImageView
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    // keep track of the number of likes as a number to avoid unecessary
    // int parsing from strings
    var likeCount: Int = 0
    
    // reset the cell when it is out of scope
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
        // retrieve the image for this message, if any
        if let imageURLString = message.imgURL {
            let imageURL = URL(string: imageURLString)
            ImageService.shared.imageForURL(url: imageURL) { (image, url) in
                // ensure that the image returned is the image for this message and
                // not some other message's image
                if url == imageURL {
                    // check if the message's imageURL is a valid image
                    if let img = image {
                        // set the messageImageView's height so that the image is not stretched
                        // or cropped
                        let ratio = img.size.height / img.size.width
                        self.imageViewHeight.constant = self.messageImageView.frame.width * ratio
                        self.messageImageView.image = img
                    }
                }
            }
        }
    }
    
    // post a like to the server when the like button is tapped
    @IBAction func likeButtonTapped(_ sender: Any) {
        MessageService.sharedMessageService.postLike(messageID: (message?.id)!) { (success) in
            if success {
                DispatchQueue.main.async {
                    // update the like count to inform the user that
                    // their like was successful
                    self.likeCount += 1
                    self.likeCountLabel.text = self.likeCount.description
                }
            }
        }
    }
}
