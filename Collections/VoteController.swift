//
//  VoteController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class VoteController {
    
    static func addVoteToPost(post: Post, completion: (success: Bool, post: Post?) -> Void) {
        guard let ownerID = UserController.sharedController.currentUser.id else { completion(success: false, post: nil); return }
        if let postID = post.id {
            var vote = Vote(postID: postID, ownerID: ownerID)
            vote.save()
        } else {
            var post = post
            post.save()
            var vote = Vote(postID: post.id!, ownerID: ownerID)
            vote.save()
        }
        PostController.fetchPostForID(post.id!) { (post) in
            completion(success: true, post: post)
        }
    }
    
    static func deleteVoteOnPost(vote: Vote, completion: (success: Bool, post: Post?) -> Void) {
        vote.delete()
        PostController.fetchPostForID(vote.postID) { (post) in
            completion(success: true, post: post)
        }
    }
    
    static func fetchVoteForID(post: Post, user: User, id: String, completion: (vote: Vote?) -> Void) {
        
    }
    
    static func fetchVotesForPost(post: Post, completion: (votes: [Vote]?) -> Void) {
        
    }
}