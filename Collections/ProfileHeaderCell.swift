//
//  ProfileHeaderCell.swift
//  Collections
//
//  Created by Gibson Smiley on 5/11/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UICollectionReusableView {
        
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    var user: User?
    
    func updateWithUser(user: User) {
        if let bio = user.bio {
            bioLabel.text = bio
        } else {
            bioLabel.hidden = true
        }
        
        if let url = user.url {
            urlButton.setTitle(url, forState: .Normal)
        } else {
            urlButton.hidden = true
        }
        
        usernameLabel.text = user.username
        
        if user.postsIDs?.count > 0 {
            postCountLabel.text = "\(user.postsIDs?.count) Posts"
        }
        
        PostController.fetchPostsForUser(user) { (posts) in
            var votesNum: Int = 0
            guard let posts = posts else { return }
            for post in posts {
                votesNum = votesNum + post.votes.count
            }
        }
        
        if user != UserController.sharedController.currentUser {
            imageButton.hidden = true
        } else {
            if profilePictureImageView.image == nil {
                imageButton.setTitle("Tap to set a \nprofile picture.", forState: .Normal)
            } else {
                imageButton.setTitle("", forState: .Normal)
            }
        }
    }
}

protocol ProfileHeaderCellDelegate {
    
    func userTappedURLButton()
    func userTappedImageButton()
}