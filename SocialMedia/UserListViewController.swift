//
//  UserListViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// display a list of users so the user can choose which
// user's UserViewController to see
class UserListViewController: UIViewController {
    
    var users: [String] = []
    
    // table view where each cell will hold a username
    @IBOutlet weak var userListTableView: UITableView!
    
    // retrieve the list of users from the server
    // called when the view in loaded and when the user
    // refeshes the table view
    func getUsers() {
        MessageService.sharedMessageService.getUserList() { (users) in
            DispatchQueue.main.async {
                if let use = users {
                    self.users = use
                    // put the usernames in the table view
                    self.userListTableView.reloadData()
                }
                // tell the user that the user list is no
                // longer being retrieved whether or not the
                // retrieval was successful
                self.refreshControl.endRefreshing()
            }
        }
    }

    // prepare the view if the user is logged in and present the
    // LoginViewController if the viewer still needs to login
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check whether or not the user's username and token ID are stored
        // in UserDefaults
        if !UserStorage.shared.userIsLoggedIn() {
            // allow the user to login if the required fields are missing from UserDefaults
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            present(loginViewController, animated: false, completion: nil)
        }else{
            // if the user is logged, prepare the table view of usernames
            userListTableView.dataSource = self
            userListTableView.delegate = self
            // allow the user to refresh the list of users
            userListTableView.addSubview(self.refreshControl)
            getUsers()
        }
    }
    
    // prepare to detect the user pulling down on the screen to
    // refresh the list of users
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    // detect the user pulling down on the screen
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getUsers()
    }
}

extension UserListViewController: UITableViewDataSource {
    
    // usernames will all be in UserListCell's, so there is only one section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // there will be exactly one username per cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // configure each UserListCell with a username
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        cell.configure(username: user)
        return cell
    }
    
}

// open a UserViewController in the navigation controller when the user taps a username
extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        userViewController.user = users[indexPath.item]
        navigationController?.pushViewController(userViewController, animated: true)
    }
}

