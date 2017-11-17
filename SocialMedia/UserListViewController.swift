//
//  UserListViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    var users: [String] = []
    
    @IBOutlet weak var userListTableView: UITableView!
    
    func getUsers() {
        MessageService.sharedMessageService.getUserList() { (users) in
            if let use = users {
                self.users = use
                DispatchQueue.main.async {
                    self.userListTableView.reloadData()
                }
            }else{
                print("could not get user list")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserStorage.shared.isReady() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            present(loginViewController, animated: false, completion: nil)
        }else{
            userListTableView.dataSource = self
            userListTableView.delegate = self
            userListTableView.addSubview(self.refreshControl)
            getUsers()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        //refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getUsers()
        refreshControl.endRefreshing()
    }
}

extension UserListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        cell.username = user
        return cell
    }
    
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        userViewController.user = users[indexPath.item]
        navigationController?.pushViewController(userViewController, animated: true)
    }
}

