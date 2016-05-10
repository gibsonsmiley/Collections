//
//  UserFeedView.swift
//  Collections
//
//  Created by Gibson Smiley on 5/5/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class UserFeedView: UITableViewController, PostCellDelegate {

    var usersFeed: [Post] = []
    
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserController.sharedController.currentUser == nil {
            performSegueWithIdentifier("toAuth", sender: self)
        } else {
            let currentUser = UserController.sharedController.currentUser
            if usersFeed.count > 0 {
                loadFeedForUser(currentUser)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on UserFeedView")
    }
    
    // MARK: - Methods
    
    func loadFeedForUser(user: User) {
        PostController.fetchFeedForUser(user) { (posts) in
            if let posts = posts {
                self.usersFeed = posts
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            } else {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func postVote(cell: PostCell, vote: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let post = usersFeed[indexPath.row]
            VoteController.userVotedForPost(post, completion: { (voted, onVote) in
                if voted == true {
                    guard let vote = onVote else { return }
                    VoteController.deleteVoteOnPost(vote, completion: { (success, post) in
                        if success == true {
                            vote.delete()
                        } else {
                            print("Error deleting vote \(vote.id) on post.", #file, #line)
                        }
                    })
                } else if voted == false {
                    // Add vote
                    VoteController.addVoteToPost(post, completion: { (success, post) in
                        if success == true {
                            print("SUCCESS!!")
                        } else {
                            print("Error adding vote on post.", #file, #line)
                        }
                    })
                }
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func userRefreshedTable(sender: AnyObject) {
        loadFeedForUser(UserController.sharedController.currentUser)
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersFeed.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        let post = usersFeed[indexPath.row]
        cell.updateWithPost(post)
        cell.delegate = self
        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
