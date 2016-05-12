//
//  CollectionController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class CollectionController {
    
    static func createCollection(name: String, description: String, header: UIImage, creatorID: String, timestamp: NSDate = NSDate(), completion: (success: Bool, collection: Collection?) -> Void) {
        guard let user = UserController.sharedController.currentUser else { completion(success: false, collection: nil); return }
        ImageController.uploadImage(header) { (id) in
            if let id = id {
                var collection = Collection(name: name, description: description, imageEndpoint: id, creatorID: creatorID)
                collection.creatorID = creatorID
                collection.save()
                addCollectionToUser(user, collection: collection) { (success) in
                    completion(success: true, collection: collection)
                }
            } else {
                print("Image couldn't be uploaded!", #file, #line)
                completion(success: false, collection: nil)
            }
        }
    }
    
    static func deleteCollection(collection: Collection, completion: (success: Bool) -> Void) {
        collection.delete()
        // For the time being, this won't be used, once a collection is made it can't be deleted, it can just have 0 users subscribed to it
        
        // Delete the collection from firebase
        // Find all users subscribed to the collection and delete it from their collectionsIDs array
    }
    
    static func editCollection(collection: Collection, completion: (success: Bool, newCollection: Collection?) -> Void) {
        var collection = collection
        collection.save()
        completion(success: true, newCollection: collection)
    }
    
    static func addCollectionToUser(user: User, collection: Collection, completion: (success: Bool) -> Void) {
        guard let collectionID = collection.id else { completion(success: false); return }
        var user = user
        user.collectionsIDs?.append(collectionID)
        UserController.sharedController.currentUser = user
        user.save()
        completion(success: true)
    }
    
    static func removeCollectionFromUser(user: User, collection: Collection, completion: (success: Bool) -> Void) {
        guard let collectionID = collection.id else { completion(success: false); return }
        var user = user
        user.collectionsIDs = user.collectionsIDs?.filter({$0 != collectionID})
        UserController.sharedController.currentUser = user
        user.save()
        completion(success: true)
    }
    
    static func fetchCollectionForID(id: String, completion: (collection: Collection?) -> Void) {
        FirebaseController.dataAtEndpoint("collections/\(id)") { (data) in
            if let json = data as? [String: AnyObject] {
                let collection = Collection(json: json, id: id)
                completion(collection: collection)
            } else {
                completion(collection: nil)
            }
        }
    }
    
    static func fetchAllCollections(completion: (collections: [Collection]) -> Void) {
        FirebaseController.dataAtEndpoint("collections") { (data) in
            if let json = data as? [String: AnyObject] {
                let collections = json.flatMap({Collection(json: $0.1 as! [String: AnyObject], id: $0.0)})
                completion(collections: collections)
            } else {
                completion(collections: [])
            }
        }
    }
    
    static func fetchCollectionsForUser(user: User, completion: (collections: [Collection]?) -> Void) {
        guard let id = user.id else { completion(collections: nil); return }
        FirebaseController.base.childByAppendingPath("users/\(id)/collectionsIDs").observeEventType(.Value, withBlock: { (snapshot) in
            var collections: [Collection] = []
            if let collectionIDs = snapshot.value as? [String] {
                let group = dispatch_group_create()
                for collectionID in collectionIDs {
                    dispatch_group_enter(group)
                    CollectionController.fetchCollectionForID(collectionID, completion: { (collection) in
                        if let collection = collection where !collections.contains(collection) {
                            collections.append(collection)
                        }
                        dispatch_group_leave(group)
                    })
                }
                dispatch_group_notify(group, dispatch_get_main_queue(), { 
                    completion(collections: collections)
                })
            } else {
                completion(collections: nil)
            }
        })
    }
    
    static func fetchCollectionByName() {
        
    }
}