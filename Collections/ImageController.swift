//
//  ImageController.swift
//  Collections
//
//  Created by Gibson Smiley on 5/3/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class ImageController {
    
    static func uploadImage(image: UIImage?, completion: (id: String?) -> Void) {
        if let base64Image = image?.base64String {
            let base = FirebaseController.base.childByAppendingPath("images").childByAutoId()
            base.setValue(base64Image)
            completion(id: base.key)
        } else {
            completion(id: nil)
        }
    }
    
    static func imageForID(id: String, completion: (image: UIImage?) -> Void) {
        FirebaseController.dataAtEndpoint("images/\(id)") { (data) in
            if let data = data as? String {
                let image = UIImage(base64: data)
                completion(image: image)
            } else {
                completion(image: nil)
            }
        }
    }
}

extension UIImage {
    var base64String: String? {
        guard let data = UIImageJPEGRepresentation(self, 0.8) else { return nil }
        return data.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
    convenience init?(base64: String) {
        if let imageData = NSData(base64EncodedString: base64, options: .IgnoreUnknownCharacters) {
            self.init(data: imageData)
        } else {
            return nil
        }
    }
}