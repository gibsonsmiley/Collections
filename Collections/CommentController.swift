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
        
    }
    
    static func deleteCommentForPost(post: Post, completion: (success: Bool) -> Void) {
        
    }
    
    static func editCommentOnPost(post: Post, newText: String?, completion: (success: Bool, newComment: Comment?) -> Void) {
        
    }
    
    static func fetchCommentForID(id: String, completion: (comment: Comment?) -> Void) {
        
    }
    
    static func fetchCommentsForPost(post: Post, completion: (comments: [Comment]?) -> Void) {
        
    }
}