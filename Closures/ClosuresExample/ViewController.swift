//
//  ViewController.swift
//  ClosuresExample
//
//  Created by Jason Henderson on 9/22/15.
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

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    /// This function is meant to demonstrate how to "hang the UI" by running something long on the main thread.
    /// Notice how even the button does not look like it was released.
    /// - parameters: 
    ///     - sender: the button clicked in the UI
    @IBAction func runTest1(sender: UIButton) {
        progressView.setProgress(0, animated: false)
        
        let limit = 100
        for counter in 0...limit {
            
            // Use microsections to sleep the thread instead of seconds
            usleep(50000)
            
            // Attempt to update the progress...good luck
            self.progressView.setProgress(counter / limit, animated: true)
        }
    }
    
    /// This function is meant to demonstrate one way fix the problem from Test 1 by first
    /// executing the doing of something on a background queue, receiving updates from the 
    /// worker as it makes progress.
    /// - parameters:
    ///     - sender: the button clicked in the UI
    @IBAction func runTest2(sender: UIButton) {

        // Reset the progress indicator
        progressView.setProgress(0, animated: false)
        
        // Do something long and asynchronous
        let doer = Worker()
        doer.doSomethingOnServer { (status: Int, progress: Float) -> Int in

            // Update the progress; we must of course be on the main queue to update the UI
            // Given how we are wrapping the execution on the background queue, then back to 
            // the main queue, we probably need to make sure the documentation for the method is clear
            // that it is executing this block on main
            self.progressView.setProgress(progress, animated: true)

            // Return something. In this case, return doesn't make a whole lot of sense,
            // but if you needed something back in the calling context, you can pass it
            return 0
        }
        
        // Try this out, too:
        // Given this is an optional parameter, we don't have to provide anything, in which
        // case we just move on with whatever else we are doing
        
        //doer.doSomethingOnServer(nil)
    }
    
    /// Runs the Test 3 worker
    /// - parameters:
    ///     - sender: the button clicked in the UI
    @IBAction func runTest3A(sender: UIButton) {
        runTest3(sender)
    }
    
    /// Runs the Test 3 worker
    /// - parameters:
    ///     - sender: the button clicked in the UI
    @IBAction func runTest3B(sender: UIButton) {
        runTest3(sender)
    }
    
    /// This function is meant to demonstrate how multiple non-UI queues may compete and conflict
    /// when interacting back with the main queue
    /// - parameters:
    ///     - sender: the button clicked in the UI
    private func runTest3(sender: UIButton) {
        
        // TODO: Pull from user settings instead creating randomly to demonstrate that as well
        let showIncrements = (arc4random() % 2) == 0 ? true : false
        
        // Initialize the progress
        progressView.setProgress(0, animated: false)
        
        // Define a block inline! (Much nicer than Obj-C syntax!)
        var updateProgressLabel:(Float, Float)->Void
        
        // Then initialize the block based on whether or not we are showing increments
        if !showIncrements {
            updateProgressLabel = {
                (progress:Float, step:Float) -> Void in
                
                self.progressView.setProgress(progress, animated: true)
            }
        }
        else {
            updateProgressLabel = {
                (progress:Float, step:Float) -> Void in
                
                if progress % step == 0 {
                    self.progressView.setProgress(progress, animated: true)
                }
            }
        }
        
        // Dispatch to background queue for processing
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            // Loop through 100 times to emulate long running operation
            let limit = 100
            for counter in 0...limit {
                
                // Use microsections to sleep the thread
                usleep(50000)
                
                // Execute back on the main queue to allow for UI updating
                dispatch_async(dispatch_get_main_queue()) {
                    switch sender.tag {
                    case 1:
                        // Call the named block we created above
                        updateProgressLabel(counter / limit, 0.10)
                    case 2:
                        // Call the named block we created above
                        updateProgressLabel(counter / limit, 0.01)
                    default:
                        print("No Tag...This is a Problem!")
                        //updateProgressLabel(counter / limit, 0.0)
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the progress view to 0 (normally 50 out of 100)
        progressView.setProgress(0, animated: true)
    }
}

