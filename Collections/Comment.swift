//
//  Comment.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class Comment: Equatable, FirebaseType {
    
    var id: String?
    let text: String
    var postID: String = ""
    var ownerID: String = ""
    
    init(id: String? = nil, text: String, postID: String, ownerID: String) {
        self.text = text
        self.postID = postID
        self.ownerID = ownerID
    }
    
    private let textKey = "text"
    private let postIDKey = "postID"
    private let ownerIDKey = "ownerID"
    
    var jsonValue: [String: AnyObject] {
        return [textKey: text, postIDKey: postID, ownerIDKey: ownerID]
    }
    var endpoint: String {
        return "posts/\(postID)/comments"
    }
    
    required init?(json: [String : AnyObject], id: String) {
            guard let text = json[textKey] as? String,
            postID = json[postID] as? String,
            ownerID = json [ownerID] as? String else { return nil }
        self.text = text
        self.id = id
        self.postID = postID
        self.ownerID = ownerID
    }
}

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}