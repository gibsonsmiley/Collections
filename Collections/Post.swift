//
//  Post.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class Post: Equatable, FirebaseType {
   
    var id: String?
    let imageEndpoint: String
    let caption: String?
    let ownerUsername: String
    let ownerID: String
    let collectionID: String
    let votes: [Vote]
    let comments: [Comment]
    
    init(imageEndpoint: String, caption: String?, ownerUsername: String = "", ownerID: String, collectionID: String, comments: [Comment] = [], votes: [Vote] = [], id: String) {
        self.imageEndpoint = imageEndpoint
        self.caption = caption
        self.ownerUsername = ownerUsername
        self.ownerID = ownerID
        self.collectionID = collectionID
        self.comments = comments
        self.votes = votes
        self.id = id
    }
    
    private let imageEndpointKey = "image"
    private let captionKey = "key"
    private let ownerUsernameKey = "ownerUsername"
    private let ownerIDKey = "ownerID"
    private let collectionIDKey = "collectionKey"
    private let votesKey = "votes"
    private let commentsKey = "comments"
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [ownerUsernameKey: ownerUsername, ownerIDKey: ownerID, imageEndpointKey: imageEndpoint, collectionIDKey: collectionID, votesKey: votes.map({$0.jsonValue}), commentsKey: comments.map({$0.jsonValue})]
        if let caption = caption {
            json.updateValue(caption, forKey: captionKey)
        }
        return json
    }
    var endpoint: String {
        return "posts"
    }
    
    required init?(json: [String : AnyObject], id: String) {
            guard let ownerUsername = json[ownerUsernameKey] as? String,
            imageEndpoint = json[imageEndpointKey] as? String,
            ownerID = json[ownerIDKey] as? String,
            collectionID = json[collectionIDKey] as? String else { return nil }
        self.id = id
        self.imageEndpoint = imageEndpoint
        self.caption = json[captionKey] as? String
        self.ownerUsername = ownerUsername
        self.ownerID = ownerID
        self.collectionID = collectionID
        
        if let voteDictionaries = json[votesKey] as? [String: AnyObject] {
            self.votes = voteDictionaries.flatMap({Vote(json: $0.1 as! [String: AnyObject], id: $0.0)})
        } else {
            self.votes = []
        }
        
        if let commentDictionaries = json[commentsKey] as? [String: AnyObject] {
            self.comments = commentDictionaries.flatMap({Comment(json: $0.1 as! [String: AnyObject], id: $0.0)})
        } else {
            self.comments = []
        }
    }
}

func ==(lhs: Post, rhs: Post) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}