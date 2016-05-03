//
//  FirebaseController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/3/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    static let base = Firebase(url: "https://justype.firebaseio.com")
    
    static func dataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        
        baseForEndpoint.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
    static func observeDataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        
        baseForEndpoint.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
}

protocol FirebaseType {
    var id: String? { get set }
    var endpoint: String { get }
    var jsonValue: [String: AnyObject] { get }
    
    init?(json: [String: AnyObject], id: String)
    
    mutating func save()
    func delete()
}

extension FirebaseType {
    
    mutating func save() {
        var endpointBase: Firebase
        
        if let identifier = self.id {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(identifier)
        } else {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAutoId()
            self.id = endpointBase.key
        }
        endpointBase.updateChildValues(self.jsonValue)
    }
    
    func delete() {
        if let identifier = self.id {
            let endpointBase: Firebase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(identifier)
            endpointBase.removeValue()
        }
    }
}