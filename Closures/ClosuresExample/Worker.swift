//
//  Worker.swift
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

class Worker: NSObject {

    /// This function simulates a long running function on a remote server, calling `callback` when done.
    ///
    /// - parameters:
    ///     - callback: the block to call when done
    ///
    /// - returns: no return value.
    func doSomethingOnServer(callback: ((Int, Float) -> Int)?) {
        
        // Set the priority to run on the background, so less important
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        // Run the block on the background queue, which will select it's thread
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            // Do it 100 times to simulate something "long"
            let limit = 100
            for counter in 0...limit {
                
                // Use microsections to sleep the thread
                usleep(50000)
                
                print("running")
                
                // Now make a callback onto the main queue to do something to update the UI
                // The callback expects an integer status and the percentage complete
                dispatch_async(dispatch_get_main_queue()) {
                    if callback != nil {
                        let returnCode = callback?(0, counter / limit)
                        print("return something from the callback itself: \(returnCode)")
                    }
                }
            }
            
            print("done")
        }
    }
}
	