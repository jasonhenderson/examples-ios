//
//  BasicTableViewCell.swift
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

/// Custom cell to handle dog animals
class DogTableViewCell: UITableViewCell {
    
    var data: [String:[String:Any]]!
    
    @IBOutlet weak var barkButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    /// We call this function once all the data is assigned, and bind the data to the cell views
    internal func bind() {
        nameLabel.text = self.data?["ProfileInfo"]?["Name"] as! String?
    }
    
    // Allow the bark to be called programmatically
    internal func bark() {
        if let checkURL = NSURL(string: (data?["ProfileInfo"]?["HomePage"] as! String?)!) {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print("barking url successfully opened")
            }
        }
        else {
            print("invalid barking url")
        }
    }
    
    /// Allow bark to be initiated with user input from the table view cell
    @IBAction private func barkPressed(sender: AnyObject) {
        bark()
    }
}
