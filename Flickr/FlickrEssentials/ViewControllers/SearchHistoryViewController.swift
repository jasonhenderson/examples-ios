//
//  SearchHistoryViewController.swift
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

@objc
class SearchHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // Could have just done a [History] structure and fetched on the main thread (default for MR)
    // for such small, simple data, but cross-thread/cross-context access is easy to get complacent about, so
    // little reason to take the risk of a crash to track down for such small reward
    fileprivate var data = [[String:Any?]]()
    
    // The currently selected history record
    fileprivate var selectedIndexPath: IndexPath?
    
    // MARK: - View Controller Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure the table element itself can be tested, but only in debug
        // so we don't annoy users who actually use the Accessibility API
        #if DEBUG
            self.tableView.accessibilityLabel = "History List"
            self.tableView.isAccessibilityElement = true
        #endif
        
        // To use external nibs, you have to register them, one nib per cell
        tableView.register(UINib(nibName: "SearchHistoryCell", bundle: nil), forCellReuseIdentifier: "SearchHistoryCell")
        
        // Bind the UINavigationController so we can control orientation 
        self.navigationController?.delegate = self
        self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    func loadData() {
        
        // Get the data async to stay off main thread, but handle thread/context sensitively
        DispatchQueue.global(qos: .background).async {
            
            // Convert to dictionary to avoid threading or fetching/perf issues with core data
            // With more time, just use the NSFetchRequest with NSFetchRequestResultType.dictionaryResultType
            // so that we don't fetch then convert (just get it as NSDictionary to begin with)
            if let histories = History.mr_findAllSorted(by:"date", ascending: false) {
                self.data = histories.map({ (object: NSManagedObject) -> Dictionary<String, Any> in
                    return Dictionary<String, Any>.init(dictionaryLiteral: ("searchText", (object as! History).searchText!), ("date",(object as! History).date!))
                })
            }
            
            // Execute back on the main queue to allow for UI updating
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows we defined in viewDidLoad
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryCell", for: indexPath) as! SearchHistoryTableViewCell
        
        // Just use the simple properties and methods we made for the custom class
        cell.data = item
        cell.bind()
        
        return cell
    }
    
    /// Need this to allow for "editing" i.e. sliding row and selecting an action
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "HistoryToPhotosSegue", sender: nil)
    }
    
    // MARK: - Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifer = segue.identifier {
            switch identifer {
            case "HistoryToPhotosSegue":
                if let selectedIndexPath = self.selectedIndexPath {
                    let dataRow = data[selectedIndexPath.row]
                    (segue.destination as! PhotosViewController).searchText = dataRow["searchText"] as! String;
                }
                break
            default: break
            }
        }
    }
    
    // MARK: - Orientation
    // Only if not inside another controller
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portraitUpsideDown //return the value as per the required orientation
    }
}

extension SearchHistoryViewController: UINavigationControllerDelegate, UITabBarControllerDelegate {
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return (navigationController.topViewController?.supportedInterfaceOrientations)!
    }
    
    func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        return (tabBarController.selectedViewController?.supportedInterfaceOrientations)!
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}



