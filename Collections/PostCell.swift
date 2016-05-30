//
//  PostCell.swift
//  Collections
//
//  Created by Gibson Smiley on 5/9/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    
    var post: Post?
    weak var delegate: PostCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    
    func updateWithPost(post: Post) {
        self.postImageView.image = nil
        
        self.usernameButton.setTitle("@\(post.ownerUsername)", forState: .Normal)
        CollectionController.fetchCollectionForID(post.collectionID) { (collection) in
            guard let collection = collection?.name else { return }
            self.collectionButton.setTitle("#\(collection)", forState: .Normal)

        }
        if let caption = post.caption {
        self.postCaption.text = "\"\(caption)\""
        } else {
            postCaption.hidden = true
        }
        self.commentButton.setTitle("\(post.comments.count) comments", forState: .Normal)
        self.voteCountLabel.text = "\(post.votes.count) votes"
        
        VoteController.userVotedForPost(post, completion: { (voted, onVote) in
            if voted == true {
                self.voteButton.setImage(UIImage(named: "voted"), forState: .Normal)
            } else {
                self.voteButton.setImage(UIImage(named: "unvoted"), forState: .Normal)
            }
        })
        
        ImageController.imageForID(post.imageEndpoint) { (image) in
            dispatch_async(dispatch_get_main_queue(), {
                self.postImageView.image = image
            })
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func usernameButtonTapped(sender: AnyObject) {
        // Go to user's profile
    }
    
    @IBAction func collectionButtonTapped(sender: AnyObject) {
        // Go to collection feed
    }
    
    @IBAction func commentButtonTapped(sender: AnyObject) {
        // Go to post's comments
    }
    
    @IBAction func voteButtonTapped(sender: AnyObject) {
        if let post = self.post {
            VoteController.userVotedForPost(post, completion: { (voted, onVote) in
                self.delegate?.postVote(self, vote: voted)
                if voted == true {
                    self.voteButton.setImage(UIImage(named: "voted"), forState: .Normal)
                } else {
                    self.voteButton.setImage(UIImage(named: "unvoted"), forState: .Normal)
                }
            })
        }
    }
}

protocol PostCellDelegate: class {
    func postVote(cell: PostCell, vote: Bool)
}