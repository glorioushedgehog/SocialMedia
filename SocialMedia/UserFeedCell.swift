//
//  UserFeedCell.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/13/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// display a single direct message
class UserFeedCell: UITableViewCell {
    
    // used for formatting the date at which this
    // direct message was sent
    static var dateFormatter = DateFormatter()
    
    var directMessage: DirectMessage?
    
    // shows the date at which this direct message
    // was sent
    @IBOutlet weak var dateLabel: UILabel!
    
    // shows the text of the direct message
    @IBOutlet weak var messageLabel: UILabel!
    
    // shows the image corresponding to the imageURL of
    // this direct message
    @IBOutlet weak var messageImageView: UIImageView!
    
    // shows how many like this direct message has recieved
    @IBOutlet weak var likeCountLabel: UILabel!
    
    // the height of messageImageView
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    // store the number of likes the direct message has recieved
    // to avoid uncesesarily parsing ints from strings
    var likeCount: Int = 0
    
    // transmit a like for this direct message when the user taps
    // the like button
    @IBAction func likeButtonTapped(_ sender: Any) {
        MessageService.sharedMessageService.postLike(messageID: (self.directMessage?.message.id)!) { (success) in
            if success {
                DispatchQueue.main.async {
                    // update the view count to inform
                    // the user that their like was successful
                    self.likeCount += 1
                    self.likeCountLabel.text = self.likeCount.description
                }
            }
        }
    }
    
    // clear out the cell when it is out of scope
    override func prepareForReuse() {
        self.messageImageView.image = nil
        self.imageViewHeight.constant = 0
        self.dateLabel.text = nil
        self.messageLabel.text = nil
    }
    
    // prepare the cell to be viewed
    func configure(directMessage: DirectMessage) {
        self.directMessage = directMessage
        UserFeedCell.dateFormatter.dateFormat = "MMM d, yyyy"
        self.dateLabel.text = UserFeedCell.dateFormatter.string(from: directMessage.message.date)
        self.messageLabel.text = directMessage.message.text
        self.likeCount = directMessage.message.likedBy.count
        self.likeCountLabel.text = self.likeCount.description
        // check if the direct message has an imageURL
        if let imageURLString = directMessage.message.imgURL {
            let imageURL = URL(string: imageURLString)
            ImageService.shared.imageForURL(url: imageURL) { (image, url) in
                // ensure that the image returned is the
                // image for this message and not some other
                // message
                if url == imageURL {
                    if let img = image {
                        // prevent scaling or cropping of the image
                        let ratio = img.size.height / img.size.width
                        self.imageViewHeight.constant = self.messageImageView.frame.width * ratio
                        self.messageImageView.image = img
                    }
                }
            }
        }
    }
}

