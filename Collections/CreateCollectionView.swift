//
//  CreateCollectionView.swift
//  Collections
//
//  Created by Gibson Smiley on 5/9/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class CreateCollectionView: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var name: String?
    var collectionDescription: String?
    var headerImage: UIImage?
    var allCollections: [String] = []
    var collectionIDs: [String] = []
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCollections()
        blackTextTint()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func getCollections() {
        CollectionController.fetchAllCollections { (collections) in
            for collection in collections {
                self.allCollections.append(collection.name)
                self.collectionIDs.append(collection.id!)
            }
        }
    }
    
    // MARK: - Text Fields
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if nameTextField.editing == true {
            guard let text = nameTextField.text else { return }
            if allCollections.contains(text) {
                nameTextField.textColor = UIColor.redColor()
                errorLabel.hidden = false
                errorLabel.text = "Looks like that collection already exists."
            } else {
                nameTextField.textColor = UIColor.blackColor()
                errorLabel.hidden = true
            }
        }
    }
    
    func blackTextTint() {
        nameTextField.tintColor = UIColor.blackColor()
        descriptionTextField.tintColor = UIColor.blackColor()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }

    // MARK: - Image
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.headerImage = image
        self.headerImageView.hidden = false
        self.headerImageView.image = image
        self.headerButton.setImage(nil, forState: .Normal)
        self.headerLabel.hidden = true
    }
    
    // MARK: - Buttons
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if nameTextField.text != nil || descriptionTextField.text != nil || headerImage != nil {
            if let name = nameTextField.text,
                description = descriptionTextField.text,
                image = headerImage {
                guard let id = UserController.sharedController.currentUser.id else { return }
                CollectionController.createCollection(name, description: description, header: image, creatorID: id, timestamp: NSDate(), completion: { (success, collection) in
                    if collection != nil {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.errorLabel.hidden = false
                        self.errorLabel.text = "Something went wrong! Please try again."
                    }
                })
            }
        } else {
            // Fields are empty
        }
    }

    @IBAction func photoButtonTapped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
