//
//  PostController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class PostController {
    
    static func createPostForUser(image: UIImage, user: User, collection: Collection, caption: String?, completion: (success: Bool, post: Post?) -> Void) {
        
    }
    
    static func deletePostForUser(post: Post, completion: (success: Bool) -> Void) {
        
    }
    
    static func editPostForUser(post: Post, newCaption: String?, completion: (success: Bool, newPost: Post?) -> Void) {
        
    }
    
    static func fetchPostForID(id: String, completion: (post: Post) -> Void) {
        
    }
    
    static func fetchFeedForUser(user: User, collections: [Collection], completion: (posts: [Post]?) -> Void) {
        
    }
    
    static func fetchPostsForUser(user: Post, completion: (posts: [Post]?) -> Void) {
//        Posts are in order
    }
    
    static func fetchPostsForCollection(collection: Collection, completion: (posts:[Post]?) -> Void) {
//        Posts are in order
    }
}