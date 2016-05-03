//
//  Vote.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class Vote: Equatable, FirebaseType {
    
    var id: String?
    let postID: String
    let ownerID: String
    
    init(id: String? = nil, postID: String, ownerID: String) {
        self.postID = postID
        self.ownerID = ownerID
    }
    
    private let postIDKey = "postID"
    private let ownerIDKey = "ownerID"
    
    var jsonValue: [String: AnyObject] {
        return [postIDKey: postID, ownerIDKey: ownerID]
    }
    var endpoint: String {
        return "posts/\(postID)/votes"
    }
    
    required init?(json: [String : AnyObject], id: String) {
            guard let postID = json[postIDKey] as? String,
            ownerID = json[ownerIDKey] as? String else { return nil }
        self.id = id
        self.postID = postID
        self.ownerID = ownerID
    }
}

func ==(lhs: Vote, rhs: Vote) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}