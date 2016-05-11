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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButtonTapped(sender: AnyObject) {
        
    }
}
