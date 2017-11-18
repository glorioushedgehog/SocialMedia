//
//  FeedViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/11/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// display messages in a table view
class FeedViewController: UIViewController {
    
    // static so that MessageViewController can find
    // messages to which a message replied
    static var messages: [Message] = []
    
    // the table view whose cells will each contain a message
    @IBOutlet weak var feedTableView: UITableView!
    
    // retrieve messages from server and put them in the table view
    // called when the view is loaded and when the user refreshes
    // the table view
    func getMessages() {
        MessageService.sharedMessageService.getMessages() { (messages) in
            DispatchQueue.main.async {
                if let mess = messages {
                    // reverse the list of messages so the most
                    // recent ones are on top
                    FeedViewController.messages = mess.reversed()
                    // put the messages in the table
                    self.feedTableView.reloadData()
                }
                // tell the user that the messages are no longer being retrieved
                // whether or not the retrieval was successful
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        feedTableView.delegate = self
        // allow the user to refresh message by pulling down on the screen
        self.feedTableView.addSubview(self.refreshControl)
        getMessages()
    }

    // prepare to detect the user pulling down on the screen
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    // detect the user pulling down on the screen
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getMessages()
    }
}

extension FeedViewController: UITableViewDataSource {
    
    // all messages will be displayed in FeedViewCells, so there is only one section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // there will be exactly one message per cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedViewController.messages.count
    }
    
    // configure each FeedViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = FeedViewController.messages[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedViewCell", for: indexPath) as! FeedViewCell
        cell.configure(message: message)
        return cell
    }
}

// open a detail view of each message when the user taps it
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageViewController = storyboard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        messageViewController.message = FeedViewController.messages[indexPath.item]
        navigationController?.pushViewController(messageViewController, animated: true)
    }
}
