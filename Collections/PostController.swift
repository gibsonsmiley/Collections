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
        guard let user = UserController.sharedController.currentUser else { completion(success: false, post: nil); return }
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
    
    static func deletePostForUser(post: Post, user: User = UserController.sharedController.currentUser) {
        post.delete()
        guard let postID = post.id else { return }
        var user = user
        guard let usersPosts = user.postsIDs else { return }
        user.postsIDs = usersPosts.filter({$0 != postID})
        user.save()
    }
    
    static func editPostForUser(post: Post, completion: (success: Bool, newPost: Post?) -> Void) {
        var post = post
        post.save()
        completion(success: true, newPost: post)
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
    
    static func fetchFeedForUser(user: User, completion: (posts: [Post]?) -> Void) {
        CollectionController.fetchCollectionsForUser(user) { (collections) in
            guard let collections = collections else { completion(posts: nil); return }
            for collection in collections {
                fetchPostsForCollection(collection, completion: { (posts) in
                    guard let posts = posts else { completion(posts: nil); return }
                    var allPosts: [Post] = []
                    for post in posts {
                        allPosts.append(post)
                        completion(posts: allPosts)
                    }
                })
            }
        }
    }
    
    static func fetchPostsForUser(user: User, completion: (posts: [Post]?) -> Void) {
        guard let userID = user.id else { completion(posts: nil); return }
        FirebaseController.dataAtEndpoint("users/\(userID)/postsIDs") { (data) in
            guard let postsIDs = data as? [String] else { completion(posts: nil); return }
            var usersPosts: [Post] = []
            for postID in postsIDs {
                fetchPostForID(postID, completion: { (post) in
                    guard let post = post else { completion(posts: nil); return }
                    usersPosts.append(post)
                    usersPosts.sortInPlace({$0.0.timestamp.timeIntervalSince1970.hashValue > $0.1.timestamp.timeIntervalSince1970.hashValue})
                    completion(posts: usersPosts)
                })
            }
        }
    }
    
    static func fetchPostsForCollection(collection: Collection, completion: (posts:[Post]?) -> Void) {
        guard let collectionID = collection.id  else { completion(posts: nil); return }
        CollectionController.fetchCollectionForID(collectionID) { (collection) in
            guard let postsIDs = collection?.postsIDs else { completion(posts: nil); return }
            var collectionsPosts: [Post] = []
            for postID in postsIDs {
                fetchPostForID(postID, completion: { (post) in
                    guard let post = post else { completion(posts: nil); return }
                    collectionsPosts.append(post)
                    collectionsPosts.sortInPlace({$0.0.votes.count > $0.1.votes.count})
                    completion(posts: collectionsPosts)
                })
            }
        }
    }
}