//
//  CollectionsPostsView.swift
//  Collections
//
//  Created by Gibson Smiley on 5/30/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class CollectionsPostsView: UITableViewController, PostCellDelegate {
    
    var collection: Collection?
    var collectionsPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on CollectionsPostsView")
    }
    
    // MARK: - Methods
    
    func updateWithCollection(collection: Collection) {
        self.collection = collection
        PostController.fetchPostsForCollection(collection) { (posts) in
            guard let posts = posts else { self.refreshControl?.endRefreshing(); return }
            self.collectionsPosts = posts
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    func postVote(cell: PostCell, vote: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let post = collectionsPosts[indexPath.row]
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
    
    @IBAction func userRefreshed(sender: AnyObject) {
        guard let collection = collection else { return }
        PostController.fetchPostsForCollection(collection) { (posts) in
            guard let posts = posts else { self.refreshControl?.endRefreshing(); return }
            self.collectionsPosts = posts
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionsPosts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as? PostCell {
        let post = collectionsPosts[indexPath.row]
        cell.updateWithPost(post)
        cell.delegate = self
        return cell
        } else {
            return UITableViewCell()
        }
    }
    
     // MARK: - Navigation
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     }
}
