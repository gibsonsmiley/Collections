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
                addPostIDToUser(user, post: post, completion: { (success) in
                    completion(success: true, post: post)
                })
                completion(success: true, post: post)
            } else {
                completion(success: false, post: nil)
            }
        }
    }
    
    static func addPostIDToUser(user: User, post: Post, completion: (success: Bool) -> Void) {
        guard let postID = post.id else { completion(success: false); return }
        var user = user
        user.postsIDs?.append(postID)
        UserController.sharedController.currentUser = user
        user.save()
        completion(success: true)
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
            var allPosts: [Post] = []
            let group = dispatch_group_create()
//            dispatch_group_enter(group)
//            fetchPostsForUser(UserController.sharedController.currentUser, completion: { (posts) in
//                guard let posts = posts else {
//                    completion(posts: nil); return }
//                for post in posts {
//                allPosts.append(post)
//                }
//                dispatch_group_leave(group)
//            })
            guard let collections = collections else {
                completion(posts: nil); return }
            for collection in collections {
                dispatch_group_enter(group)
                fetchPostsForCollection(collection, completion: { (posts) in
                    guard let posts = posts else { completion(posts: nil); return }
                    for post in posts {
                        allPosts.append(post)
                    }
                    dispatch_group_leave(group)
                })
            }
            dispatch_group_notify(group, dispatch_get_main_queue(), {
//                for posts in allPosts {
//                    if $0 == $1 {
//                        
//                    }
//                }
                completion(posts: allPosts)
            })
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
        var collectionsPosts: [Post] = []
        FirebaseController.base.childByAppendingPath("posts").queryOrderedByChild("collectionKey").queryEqualToValue(collectionID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let postDictionaries = snapshot.value as? [String: AnyObject] {
                let posts = postDictionaries.flatMap({Post(json: $0.1 as! [String: AnyObject], id: $0.0)})
                let group = dispatch_group_create()
                for post in posts {
                    dispatch_group_enter(group)
                    guard let id = post.id else { completion(posts: nil); return }
                    fetchPostForID(id, completion: { (post) in
                        guard let post = post else { completion(posts: nil); return }
                        collectionsPosts.append(post)
                        //collectionsPosts.sortInPlace({$0.0.votes.count > $0.1.votes.count})
                        dispatch_group_leave(group)
                    })
                }
                dispatch_group_notify(group, dispatch_get_main_queue(), { 
                    completion(posts: collectionsPosts)
                })
            }
        })
        
        
//        CollectionController.fetchCollectionForID(collectionID) { (collection) in
//            guard let postsIDs = collection?.postsIDs else { completion(posts: nil); return }
//            var collectionsPosts: [Post] = []
//            for postID in postsIDs {
//                fetchPostForID(postID, completion: { (post) in
//                    guard let post = post else { completion(posts: nil); return }
//                    collectionsPosts.append(post)
//                    collectionsPosts.sortInPlace({$0.0.votes.count > $0.1.votes.count})
//                    completion(posts: collectionsPosts)
//                })
//            }
//        }
    }
}