//
//  CollectionsView.swift
//  Collections
//
//  Created by Gibson Smiley on 5/5/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class CollectionsView: UITableViewController {
    
    // MARK: - Properties
    
    var collections: [Collection] = []
    
    // MARK: - View Modes
    
    enum FromView {
        case Normal
        case AddPost
    }
    
    var fromView = FromView.Normal
    
    enum SegmentedViewMode: Int {
        case Mine = 0
        case All = 1
        case Search = 2
    }
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func arrivedFromAddPost() {
        fromView = .AddPost
    }

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
