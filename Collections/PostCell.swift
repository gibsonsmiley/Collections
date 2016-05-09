//
//  PostCell.swift
//  Collections
//
//  Created by Gibson Smiley on 5/9/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var voteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Button Actions
    
    @IBAction func usernameButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func commentButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func voteButtonTapped(sender: AnyObject) {
        
    }

}
