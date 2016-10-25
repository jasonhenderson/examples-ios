//
//  ViewController.swift
//  UITableViewExample
//
//  Created by Jason Henderson on 10/14/16.
//
//  This file is part of examples-ios.
//
//  examples-ios is free software: you c an redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  examples-ios is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with examples-ios.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Enums

    /// Animals in the kingdom
    /// - Dog: plain ol' dog
    /// - Cat: plain ol' Cat
    /// - Unknown: can't tell what it is
    private enum Animal {
        case Dog
        case Cat
        case Unknown
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    /// Test data that could be closely modeled to JSON data from a remote source
    private var data = [[String:[String:Any]]?]()
    
    // MARK: - View Controller Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To use external nibs, you have to register them, one nib per cell
        tableView.registerNib(UINib(nibName: "DogCell", bundle: nil), forCellReuseIdentifier: "DogCell")
        tableView.registerNib(UINib(nibName: "CatCell", bundle: nil), forCellReuseIdentifier: "CatCell")
        
        // Notice that no registration is required for the cell added directly to the table in IB
        
        // Identify as delegate and dataSource here or in IB
        //self.tableView.dataSource = self
        //self.tableView.delegate = self
        
        // Instantiate our fake model for purposes of display
        self.data.append(["ProfileInfo": ["Type": Animal.Dog, "Name": "Jake", "EyeColor":UIColor.brownColor(), "Height":12.0, "HomePage" : "http://www.csumb.edu"]])
        self.data.append(["ProfileInfo": ["Type": Animal.Cat, "Name": "Sarah", "EyeColor":UIColor.blackColor(), "Height":24.0, "HomePage" : "http://www.csumb.edu"]])
        self.data.append(["ProfileInfo": ["Type": Animal.Cat, "Name": "Eddy", "EyeColor":UIColor.blueColor(), "Height":33.0, "HomePage" : "http://www.csumb.edu"]])
        self.data.append(["ProfileInfo": ["Type": Animal.Unknown, "Name": "Jill", "EyeColor":UIColor.greenColor(), "Height":8.0, "HomePage" : "http://www.csumb.edu"]])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load the table data when the view controller appears
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows we defined in viewDidLoad
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = data[indexPath.row]
        
        var cell : UITableViewCell
        
        // If the type of animal is a dog, use the special dog cell, and associated cell derived class,
        // if tye type of animal is a cat, use the special cat cell, with no special cell class,
        // or just use the basic cell associated with the table if the animal is unknown
        // This demonstrates 3 of the common ways we can work with the cells, and also shows
        // a good use for extensions
        
        switch ((item?["ProfileInfo"]?["Type"] as? Animal) ?? .Unknown) {
        case .Dog:
            cell = tableView.dequeueReusableCellWithIdentifier("DogCell", forIndexPath: indexPath) as! DogTableViewCell
            
            // Just use the simple properties and methods we made for the custom class...very simple, and clean
            (cell as! DogTableViewCell).data = item
            (cell as! DogTableViewCell).bind()
            
        case .Cat:
            cell = tableView.dequeueReusableCellWithIdentifier("CatCell", forIndexPath: indexPath) as UITableViewCell
            
            // Set the name label by retrieving it with the tag
            if let nameLabel = cell.viewWithTag(1) as! UILabel? {
                nameLabel.text = item?["ProfileInfo"]?["Name"] as! String?;
            }
            
            // Setup the button by retrieving it with the tag
            if let meowButton = cell.viewWithTag(2) as! UIButton? {
                // Add a custom target that is handled here
                meowButton.addTarget(self, action: #selector(meowPressed), forControlEvents: .TouchUpInside)
                
                // Use the button extension to attach the index path; this will allow us to identify which cell was clicked in the target
                meowButton.indexPath = indexPath
            }
            
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as UITableViewCell

            if let nameLabel = cell.viewWithTag(1) as! UILabel? {
                nameLabel.text = item?["ProfileInfo"]?["Name"] as! String?;
            }
            
            // Note that there is no action in this case
            
            break
        }
        
        
        return cell
    }
    
    /// Need this to allow for "editing" i.e. sliding row and selecting an action
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    // MARK: - UITableViewDelegate
    
    /// Allow user to enable animal communication generally, regardless of the custom cell
    /// Edit Actions are activated by sliding the row
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let talkAction = UITableViewRowAction(style: .Normal, title: "Talk") { action, index in
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath);
            
            if (selectedCell is DogTableViewCell) {
                (selectedCell as! DogTableViewCell).bark()
            }
            else if let item = self.data[indexPath.row] {
                if ((item["ProfileInfo"]?["Type"] as! Animal) == .Cat) {
                    self.meow(indexPath)
                }
            }
            
            tableView.setEditing(false, animated: true)
        }
        
        return [talkAction]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let person = data[indexPath.row] {
            print("\(person)")
        }
        else {
            print("nobody selected")
        }
    }
    
    // MARK: - Actions

    func meowPressed(sender: UIButton!) {
        let indexPath = sender.indexPath
        meow(indexPath!)
    }
    
    func meow(indexPath: NSIndexPath) {
        if let item = data[indexPath.row] {
            if let checkURL = NSURL(string:(item["ProfileInfo"]?["HomePage"] as? String)!) {
                if UIApplication.sharedApplication().openURL(checkURL) {
                    print("meow url successfully opened")
                    return;
                }
            }
        }
        
        print("invalid meowing url")
    }
}

