//
//  UserListCell.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// displays a username in UserListViewController's table view
class UserListCell: UITableViewCell {
    
    var username: String?
    
    // displays the username
    @IBOutlet weak var usernameLabel: UILabel!
    
    // clear out the cell when it is out of scope
    override func prepareForReuse() {
        self.usernameLabel.text = nil
    }
    
    // prepare the cell to be viewed
    func configure(username: String){
        self.username = username
        self.usernameLabel.text = self.username
    }
}

