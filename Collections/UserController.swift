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
    
    let currentUser: User! = nil
    
    static func createUser(email: String, password: String, username: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        
    }
    
    static func deleteUser(user: User, completion: (success: Bool) -> Void) {
        
    }
    
    static func editUser(user: User, newEmail: String?, newPassword: String?, newUsername: String?, newBio: String?, newURL: String?, completion: (success: Bool, newUser: User) -> Void ) {
        
    }
    
    static func authenticateUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        
    }
    
    static func fetchUserForID(id: String, completion: (user: User?) -> Void) {
        
    }
    
    static func logoutUser() {
        FirebaseController.base.unauth()
    }
}