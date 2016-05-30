//
//  CollectionCell.swift
//  Collections
//
//  Created by Gibson Smiley on 5/11/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var headerImageView: UIImageView!
    
    var collection: Collection?
    weak var delegate: CollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // If cell is selected, go to collection feed
    }

    // MARK: - Methods
    
    func updateWithCollection(collection: Collection) {
        self.headerImageView.image = nil
        
        self.nameLabel.text = collection.name
        self.descriptionLabel.text = collection.description
        
        // See if user follows collection and display correct button
        
        ImageController.imageForID(collection.imageEndpoint) { (image) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.headerImageView.image = image
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        guard let currentUser = UserController.sharedController.currentUser else { return }
        guard let collection = self.collection else { return }
        
        // If user does not follow collection {
        CollectionController.addCollectionToUser(currentUser, collection: collection) { (success) in
            if success == true {
                
            } else {
                // Could not add collection to user
            }
        }
        
        
        // If usser follows collection {
        CollectionController.removeCollectionFromUser(currentUser, collection: collection) { (success) in
            if success == true {
                
            } else {
                // Couldn't delete collection
            }
        }
    }
}

protocol CollectionCellDelegate: class {
    func collectionAdded(cell: CollectionCell)
}