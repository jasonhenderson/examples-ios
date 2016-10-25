//
//  ChildViewController.swift
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

// MARK: - ChildViewControllerDelegate

/**
 
 Delegate to allow master controller to interact with the child, through push, modal or popup
 `@objc`
 this modifier is needed to allow for optional protocol methods, which are not natively available in Swift
 
 */
@objc protocol ChildViewControllerDelegate {
    func successfulCompletionOfViewControllerTask(viewController: ChildViewController, message: String?)
    optional func failedCompletionOfViewControllerTask(viewController: ChildViewController, error: NSError?)
}

// MARK: - ChildViewController

///  Child class that will call back to the master IFF a delegate has been set
public class ChildViewController: UIViewController {
    
    weak var delegate:ChildViewControllerDelegate?
    
    /// Closing emulating success
    /// - parameters:
    ///     - sender: the button pressed
    @IBAction func successPressed(sender: AnyObject) {
        
        // If the delegate has been provided, call the method, which is not optional so no ?
        self.delegate?.successfulCompletionOfViewControllerTask(self, message: "We are done here")
    }

    /// Closing emulating failure
    /// - parameters:
    ///     - sender: the button pressed
    @IBAction func errorPressed(sender: AnyObject) {
        
        // Define an error
        let fakeError = NSError(domain: "",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey :  NSLocalizedString("Generated Error", value: "Nothing really wrong", comment: "")]);
        
        // If the delegate has been provided, and that delegate implemented the method, call it
        self.delegate?.failedCompletionOfViewControllerTask?(self, error: fakeError)
    }
}

