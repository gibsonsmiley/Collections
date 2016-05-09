//
//  UserController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/2/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class UserController {
    static let sharedController = UserController()
    
    let userKey = "userKey"
    var currentUser: User! {
        get {
            guard let uid = FirebaseController.base.authData?.uid, let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(userKey) as? [String: AnyObject] else { return nil }
            return User(json: userDictionary, id: uid)
        }
        set {
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: userKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(userKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    static func createUser(email: String, password: String, username: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        FirebaseController.base.createUser(email, password: password) { (error, response) in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(success: false, user: nil)
            } else {
                if let id = response["uid"] as? String {
                    var user = User(id: id, email: email, username: username, bio: bio, url: url)
                    FirebaseController.base.childByAppendingPath("users").childByAppendingPath(id).setValue(user.jsonValue)
                    user.save()
                    authenticateUser(email, password: password, completion: { (success, user) in
                        completion(success: success, user: user)
                    })
                } else {
                    completion(success: false, user: nil)
                }
            }
        }
    }
    
    static func deleteUser(user: User, completion: (success: Bool) -> Void) {
        user.delete()
        guard let userID = user.id else { completion(success: false); return }
        fetchUserForID(userID) { (user) in
            completion(success: true)
        }
    }
    
    static func editUser(user: User, completion: (success: Bool, newUser: User) -> Void ) {
        var user = user
        user.save()
        completion(success: true, newUser: user)
    }
    
    static func authenticateUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        FirebaseController.base.authUser(email, password: password) { (error, authData) in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(success: false, user: nil)
            } else {
                UserController.fetchUserForID(authData.uid, completion: { (user) in
                    if let user = user {
                        sharedController.currentUser = user
                        completion(success: true, user: user)
                    } else {
                        completion(success: false, user: nil)
                    }
                })
            }
        }
    }
    
    static func fetchUserForID(id: String, completion: (user: User?) -> Void) {
        FirebaseController.dataAtEndpoint("users/\(id)") { (data) in
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, id: id)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    static func searchForUserByUsername() {
        // This can probably just be a search controller filtering through all users
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        FirebaseController.dataAtEndpoint("users") { (data) in
            if let json = data as? [String: AnyObject] {
                let users = json.flatMap({User(json: $0.1 as! [String: AnyObject], id: $0.0)})
                completion(users: users)
            } else {
                completion(users: [])
            }
        }
    }
    
    static func logoutUser() {
        FirebaseController.base.unauth()
    }
}