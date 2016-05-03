//
//  PostController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class PostController {
    
    static func createPostForUser(image: UIImage, user: User, collection: Collection, caption: String?, timestamp: NSDate = NSDate(), completion: (success: Bool, post: Post?) -> Void) {
        ImageController.uploadImage(image) { (id) in
            if let id = id {
                    guard let ownerID = user.id,
                    collectionID = collection.id else { return }
                var post = Post(imageEndpoint: id, caption: caption, timestamp: timestamp, ownerUsername: user.username, ownerID: ownerID, collectionID: collectionID, comments: [], votes: [])
                post.save()
                completion(success: true, post: post)
            } else {
                completion(success: false, post: nil)
            }
        }
    }
    
    static func deletePostForUser(post: Post) {
        post.delete()
    }
    
    static func editPostForUser(post: Post, newCaption: String?, completion: (success: Bool, newPost: Post?) -> Void) {
        
    }
    
    static func fetchPostForID(id: String, completion: (post: Post?) -> Void) {
        FirebaseController.dataAtEndpoint("posts/\(id)") { (data) in
            if let json = data as? [String: AnyObject] {
                let post = Post(json: json, id: id)
                completion(post: post)
            } else {
                completion(post: nil)
            }
        }
    }
    
    static func fetchFeedForUser(user: User, collections: [Collection], completion: (posts: [Post]?) -> Void) {
        
    }
    
    static func fetchPostsForUser(user: User, completion: (posts: [Post]?) -> Void) {
//        Put posts in order
    }
    
    static func fetchPostsForCollection(collection: Collection, completion: (posts:[Post]?) -> Void) {
//        Put posts in order
    }
}