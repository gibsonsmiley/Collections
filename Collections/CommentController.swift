//
//  CommentController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class CommentController {
    
    static func addCommentToPost(post: Post, text: String, completion: (success: Bool, post: Post?) -> Void) {
        guard let ownerID = UserController.sharedController.currentUser.id else { completion(success: false, post: nil); return }
        if let id = post.id {
            var comment = Comment(text: text, postID: id, ownerID: ownerID)
            comment.save()
            PostController.fetchPostForID(comment.postID, completion: { (post) in
                completion(success: true, post: post)
            })
        } else {
            completion(success: false, post: nil)
            return
        }
    }
    
    static func deleteCommentForPost(comment: Comment, completion: (success: Bool, post: Post?) -> Void) {
        comment.delete()
        PostController.fetchPostForID(comment.postID) { (post) in
            completion(success: true, post: post)
        }
    }
    
    static func editCommentOnPost(post: Post, newText: String?, completion: (success: Bool, newComment: Comment?) -> Void) {
        
    }
    
    static func fetchCommentForID(id: String, completion: (comment: Comment?) -> Void) {
        
    }
    
    static func fetchCommentsForPost(post: Post, completion: (comments: [Comment]?) -> Void) {
        
    }
}