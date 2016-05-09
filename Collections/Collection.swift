//
//  Collection.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class Collection: Equatable, FirebaseType {
    
    var id: String?
    let name: String
    let description: String
    let timestamp: NSDate
    var creatorID: String
    var postsIDs: [String]? = []
    
    init(id: String? = nil, name: String, description: String, timestamp: NSDate = NSDate(), creatorID: String, postsIDs: [String]? = []) {
        self.name = name
        self.description = description
        self.timestamp = timestamp
        self.creatorID = creatorID
        self.postsIDs = postsIDs
    }
    
    private let nameKey = "name"
    private let descriptionKey = "description"
    private let timestampKey = "timestamp"
    private let creatorIDKey = "createrID"
    private let postsIDsKey = "postsIDs"
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [nameKey: name, descriptionKey: description, timestampKey: timestamp.timeIntervalSince1970, creatorIDKey: creatorID]
        if let postsIDs = postsIDs {
            json.updateValue(postsIDs, forKey: postsIDsKey)
        }
        return json
    }
    var endpoint: String {
        return "collections"
    }
    
    required init?(json: [String : AnyObject], id: String) {
            guard let name = json[nameKey] as? String,
            description = json[descriptionKey] as? String,
            timestamp = json[timestampKey] as? NSTimeInterval,
            creatorID = json[creatorIDKey] as? String else { return nil }
        self.id = id
        self.name = name
        self.description = description
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        self.creatorID = creatorID
        if let postsIDs = json[postsIDsKey] as? [String] {
            self.postsIDs = postsIDs
        }
    }
}

func == (lhs: Collection, rhs: Collection) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}