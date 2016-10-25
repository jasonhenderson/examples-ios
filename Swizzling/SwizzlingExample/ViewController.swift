//
//  ViewController.swift
//  SwizzlingExample
//
//  Created by Jason Henderson on 10/20/16.
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

    // Don't do anything here, just run and let the life-cycle occur normally. 
    // The swizzling will occur if the extension works, and we should see it in the console.

    // NOTE: we are swizzling in 2 places, and dangerous becomes doubly dangerous. 
    // Quesions: Which one is first? Is it always first? What happens to the built in viewWillAppear? 
    // Is it called twice? Lots to think about when taking the swizzling risk.
    
    /// override to allow for setting of additional information in the associated object property
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Optionally set the descriptiveName
        self.descriptiveName = "Swizzling is fun"
    }
    
}

