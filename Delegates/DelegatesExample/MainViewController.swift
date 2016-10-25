//
//  MainViewController.swift
//  DelegatesExample
//
//  Created by Jason Henderson on 9/23/16.
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

class MainViewController: UIViewController, ChildViewControllerDelegate {

    // MARK: - Actions
    
    /// TouchUpInside method of the open button
    @IBAction func openPressed(sender: AnyObject) {
        let childVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChildVC") as! ChildViewController
        
        // Try commenting out the following to see what happens...does the allDoneWithViewController method get called below?
        
        // Assign the delegate so that the child view controller can get back to the
        childVC.delegate = self
        
        // Present
        self.presentViewController(childVC, animated:true, completion:nil)
    }
    
    // MARK: - ChildViewControllerDelegate
    
    /// The child controller called back with a message after completing its work successfully
    func successfulCompletionOfViewControllerTask(viewController: ChildViewController, message: String?) {
        viewController.dismissViewControllerAnimated(true) {
            if let text = message {
                print("\(text)")
            }
        }
    }

    /// The child controller called back with an optional error after not completing its work
    func failedCompletionOfViewControllerTask(viewController: ChildViewController, error: NSError?) {
        viewController.dismissViewControllerAnimated(true) {
            if let problem = error {
                print("\(problem)")
            }
            else {
                print("No problems")
            }
        }
    }
}

