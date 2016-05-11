//
//  AddPostView.swift
//  Collections
//
//  Created by Gibson Smiley on 5/9/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class AddPostView: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var collectionTextField: UITextField!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var errorLabel: UILabel!
    
    var image: UIImage?
    var collection: Collection?
    var caption: String?
    var allCollections: [String] = []
    var collectionIDs: [String] = []
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCollections()
        collectionTextField.delegate = self
        blackTextTint()
//        gestureCenter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Text Field
    
    func blackTextTint() {
        collectionTextField.tintColor = UIColor.blackColor()
        captionTextField.tintColor = UIColor.blackColor()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        collectionTextField.text = collection?.name
//        caption = captionTextField.text
        collectionTextField.delegate = self
        captionTextField.delegate = self
        collectionTextField.resignFirstResponder()
        captionTextField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
//        if collectionTextField.editing == true {
        if collectionTextField.text != nil {
            guard let text = collectionTextField.text else { return }
            if allCollections.contains(text) {
                collectionTextField.textColor = UIColor.blackColor()
                errorLabel.hidden = true
                guard let index = allCollections.indexOf(text) else { return }
                let collectionsID = collectionIDs[index]
                CollectionController.fetchCollectionForID(collectionsID, completion: { (collection) in
                    guard let collection = collection else { return }
                    self.collection = collection
                    print(collection)
                })
            } else {
                collectionTextField.textColor = UIColor.redColor()
                errorLabel.hidden = false
                errorLabel.text = "That collection doesn't exist yet. Make it first!"
            }
        } else {
            errorLabel.hidden = false
            errorLabel.text = "You need to select a collection to post this in."
        }
    }
    
    // MARK: - Collection
    
    func getCollections() {
        CollectionController.fetchAllCollections { (collections) in
            for collection in collections {
                self.allCollections.append(collection.name)
                self.collectionIDs.append(collection.id!)
            }
        }
    }
    
    // MARK: - Image
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.image = image
        photoImageView.image = image
        self.cameraButton.hidden = true
        self.libraryButton.hidden = true
        photoImageView.hidden = false
    }
        
    // MARK: - Button Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        captionTextField.resignFirstResponder()
        collectionTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        if image != nil || collectionTextField.text != nil {
            if let image = image,
                collection = collection {
                errorLabel.hidden = true
                PostController.createPostForUser(image, user: UserController.sharedController.currentUser, collection: collection, caption: self.captionTextField?.text, completion: { (success, post) in
                    if post != nil {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.errorLabel.hidden = false
                        self.errorLabel.text = "Something went wrong! Please try again."
                        // It didn't work!
                    }
                })
            }
        } else {
            // Fields are empty
        }
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func libraryButtonTapped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}
