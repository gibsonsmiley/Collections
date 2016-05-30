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
    
    var mode: ViewMode {
        get {
            return ViewMode(rawValue: segmentedControl.selectedSegmentIndex)!
        }
    }
    
    // MARK: - View Modes
    
    enum ViewMode: Int {
        case Mine = 0
        case All = 1
        
        func collections(completion: (collections: [Collection]?) -> Void) {
            switch self {
            case .Mine:
                guard let currentUser = UserController.sharedController.currentUser else { return }
                CollectionController.fetchCollectionsForUser(currentUser, completion: { (collections) in
                    completion(collections: collections)
                })
            case .All:
                CollectionController.fetchAllCollections({ (collections) in
                    completion(collections: collections)
                })
            }
        }
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewBasedOnMode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    func updateViewBasedOnMode() {
        mode.collections { (collections) in
            if let collections = collections {
                self.collections = collections
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            } else {
                self.collections = []
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        CollectionController.fetchAllCollections { (collections) in
            self.collections = collections
        }
        filteredCollections = collections.filter({String($0.name).lowercaseString.containsString(searchText.lowercaseString)})
        tableView.reloadData()
    }
    
    func collectionAdded(cell: CollectionCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        let collection = collections[indexPath.row]
        guard let currentUser = UserController.sharedController.currentUser else { return }
        CollectionController.addCollectionToUser(currentUser, collection: collection) { (success) in
            if success == true {
                
            } else {
                print("Couldn't add collection to user")
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func indexChanged(sender: AnyObject) {
        updateViewBasedOnMode()
    }
    
    @IBAction func userRefreshed(sender: AnyObject) {
        updateViewBasedOnMode()
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
        if segue.identifier == "toCollection" {
            if let destinationViewController = segue.destinationViewController as? CollectionsPostsView {
                _ = destinationViewController.view
                if let cell = sender as? CollectionCell,
                    indexPath = tableView.indexPathForCell(cell) {
                    let collection = collections[indexPath.row]
                    destinationViewController.updateWithCollection(collection)
                }
            }
        }
    }
}
