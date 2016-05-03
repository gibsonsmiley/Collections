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
    
    var currentUser: User! = nil
    
    static func createUser(email: String, password: String, username: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        FirebaseController.base.createUser(email, password: password) { (error, response) in
            if let id = response["uid"] as? String {
                var user = User(id: id, email: email, username: username, bio: bio, url: url)
                user.save()
                
                authenticateUser(email, password: password, completion: { (success, user) in
                    completion(success: success, user: user)
                })
            } else {
                completion(success: false, user: nil)
            }
        }
    }
    
    static func deleteUser(user: User, completion: (success: Bool) -> Void) {
        
    }
    
    static func editUser(user: User, newEmail: String?, newPassword: String?, newUsername: String?, newBio: String?, newURL: String?, completion: (success: Bool, newUser: User) -> Void ) {
        
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
    
    static func logoutUser() {
        FirebaseController.base.unauth()
    }
}