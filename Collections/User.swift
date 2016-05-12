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
    let profileImageEndpoint: String?
    var collectionsIDs: [String]? = []
    var postsIDs: [String]? = []
    
    init(id: String?, email: String, username: String, bio: String?, url: String?, profileImageEndpoint: String?, collectionsIDs: [String]? = [], postsIDs: [String]? = []) {
        self.email = email
        self.username = username
        self.bio = bio
        self.url = url
        self.profileImageEndpoint = profileImageEndpoint
        self.collectionsIDs = collectionsIDs
        self.postsIDs = postsIDs
    }
    
    private let emailKey = "email"
    private let usernameKey = "username"
    private let bioKey = "bio"
    private let urlKey = "url"
    private let profileImageKey = "profileImage"
    private let collectionsIDsKey = "collectionsIDs"
    private let postsIDsKey = "postsIDs"
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [emailKey: email, usernameKey: username]
        if let bio = bio {
            json.updateValue(bio, forKey: bioKey)
        }
        if let url = url {
            json.updateValue(url, forKey: urlKey)
        }
        if let profileImageEndpoint = profileImageEndpoint {
            json.updateValue(profileImageEndpoint, forKey: profileImageKey)
        }
        if let collectionsIDs = collectionsIDs {
            json.updateValue(collectionsIDs, forKey: collectionsIDsKey)
        }
        if let postsIDs = postsIDs {
            json.updateValue(postsIDs, forKey: postsIDsKey)
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
        self.profileImageEndpoint = json[profileImageKey] as? String
        if let collectionsIDs = json[collectionsIDsKey] as? [String] {
            self.collectionsIDs = collectionsIDs
        }
        if let postsIDs = json[postsIDsKey] as? [String] {
            self.postsIDs = postsIDs
        }
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}