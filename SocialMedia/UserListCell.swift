//
//  UserListCell.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    
    var username: String? {
        didSet(value) {
            self.usernameLabel.text = self.username
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    
}

