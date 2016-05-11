//
//  CollectionsView.swift
//  Collections
//
//  Created by Gibson Smiley on 5/5/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class CollectionsView: UITableViewController, UISearchBarDelegate, CollectionCellDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var collections: [Collection] = []
    var filteredCollections: [Collection] = []
    
    // MARK: - View Modes
    
    enum FromView {
        case Normal
        case AddPost
    }
    
    var fromView = FromView.Normal
    
    enum SegmentedViewMode: Int {
        case Mine = 0
        case All = 1
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        CollectionController.fetchAllCollections { (collections) in
            self.collections = collections
        }
        filteredCollections = collections.filter({String($0.name).lowercaseString.containsString(searchText.lowercaseString)})
        tableView.reloadData()
    }
    
    func collectionAdded(cell: CollectionCell) {
        
    }
    
    // MARK: - Actions
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            SegmentedViewMode.Mine
            setUpMine()
        case 1:
            SegmentedViewMode.All
            setUpAll()
        default:
            break
        }
    }
    

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCollections.count > 0 {
            return filteredCollections.count
        }
        return collections.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionCell
        let collection = filteredCollections.count > 0 ? filteredCollections[indexPath.row] : collections[indexPath.row]
        cell.updateWithCollection(collection)
        cell.delegate = self

        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - "Mine" View Mode
    
    func setUpMine() {
        CollectionController.fetchCollectionsForUser(UserController.sharedController.currentUser) { (collections) in
            guard let collections = collections else { return }
            self.collections = collections
        }
    }
    
    // MARK: - "All" View Mode
    
    func setUpAll() {
    CollectionController.fetchAllCollections { (collections) in
        self.collections = collections
        }
    }

}
