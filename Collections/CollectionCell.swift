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
        self.nameLabel.text = collection.name
        self.descriptionLabel.text = collection.description
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        
    }
}

protocol CollectionCellDelegate: class {
    func collectionAdded(cell: CollectionCell)
}