//
//  User.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class User: Equatable, FirebaseType {
    
    var id: String?
    let email: String
    let username: String
    let bio: String?
    let url: String?
    let collectionsIDs: [String]?
    
    init(id: String, email: String, username: String, bio: String?, url: String?, collectionsIDs: [String]?) {
        self.id = id
        self.email = email
        self.username = username
        self.bio = bio
        self.url = url
        self.collectionsIDs = collectionsIDs
    }
    
    private let emailKey = "email"
    private let usernameKey = "username"
    private let bioKey = "bio"
    private let urlKey = "url"
    private let collectionsIDsKey = "collectionsIDs"
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [emailKey: email, usernameKey: username]
        if let bio = bio {
            json.updateValue(bio, forKey: bioKey)
        }
        if let url = url {
            json.updateValue(url, forKey: urlKey)
        }
        if let collectionsIDs = collectionsIDs {
            json.updateValue(collectionsIDs, forKey: collectionsIDsKey)
        }
        return json
    }
    var endpoint: String {
        return "users"
    }
    
    required init?(json: [String : AnyObject], id: String) {
            guard let email = json[emailKey] as? String,
            username = json[usernameKey] as? String else { return nil }
        self.id = id
        self.email = email
        self.username = username
        self.bio = json[bioKey] as? String
        self.url = json[urlKey] as? String
        if let collectionsIDs = json[collectionsIDsKey] as? [String] {
            self.collectionsIDs = collectionsIDs
        }
    }
}

func ==(lhs: Post, rhs: Post) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}