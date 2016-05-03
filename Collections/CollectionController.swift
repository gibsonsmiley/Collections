//
//  CollectionController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class CollectionController {
    
    static func createCollection(name: String, description: String, ownerID: String, completion: (success: Bool, collection: Collection?) -> Void) {
        
    }
    
    static func deleteCollection(collection: Collection, completion: (success: Bool) -> Void) {
        
    }
    
    static func editCollection(collection: Collection, newName: String?, newDescription: String?, completion: (success: Bool, newCollection: Collection?) -> Void) {
        
    }
    
    static func addCollectionToUser(user: User, collection: Collection, completion: (success: Bool) -> Void) {
        
    }
    
    static func removeCollectionFromUser(user: User, collection: Collection, completion: (success: Bool) -> Void) {
        
    }
    
    static func fetchCollectionForID(id: String, completion: (collection: Collection?) -> Void) {
        
    }
    
    static func fetchCollectionsForUser(user: User, completion: (collections: [Collection]?) -> Void) {
        
    }
}