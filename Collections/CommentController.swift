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
    
    static func editCommentOnPost(comment: Comment, completion: (success: Bool, newComment: Comment?) -> Void) {
        var comment = comment
        comment.save()
        completion(success: true, newComment: comment)
    }
    
    static func fetchCommentForID(post: Post, id: String, completion: (comment: Comment?) -> Void) {
        guard let postID = post.id else { completion(comment: nil); return }
        FirebaseController.dataAtEndpoint("posts/\(postID)/comments/\(id)") { (data) in
            guard let json = data as? [String: AnyObject] else { completion(comment: nil); return }
            let comment = Comment(json: json, id: id)
            completion(comment: comment)
        }
    }
    
    static func fetchCommentsForPost(post: Post, completion: (comments: [Comment]?) -> Void) {
        guard let postID = post.id else { completion(comments: nil); return }
        PostController.fetchPostForID(postID) { (post) in
            guard let comments = post?.comments else { completion(comments: nil); return }
            completion(comments: comments)
        }
    }
}