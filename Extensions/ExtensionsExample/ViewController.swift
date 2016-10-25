//
//  ViewController.swift
//  ExtensionsExample
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

    /// Just run the load to print to the console
    override func viewDidLoad() {
        super.viewDidLoad()

        // Note that we cannot derive Fish since it is final
        //var surfPerch = SurfPerch()
        
        // So, let's take a look at the extension of Fish as a solution in FishExtension.swift
        let fishy = Fish(length: 56, skin: .Rough)
        
        print("I once caught a \(fishy.skin!) fish \"this (\(fishy.length!) inches) big\"!")
        
        // Then we can look at example of the wrapper pattern, whereby
        // we wrap a Dictionary, since it is a struct and cannot be derived, and cannot have associated objects,
        // so will not allow us to store additional information on the object
        let fishyDictionaryWrapper = FishDictionaryWrapper(properties: ["eyeColor", "hasBackFin"])
        fishyDictionaryWrapper.eyeColor = UIColor.redColor()
        
        print("I also caught one with \"\(fishyDictionaryWrapper.eyeColor ?? UIColor.blackColor())\" colored eyes")
        
        // Finally, take a look at a direct Dictionary extension, which would have the problem of extending all the 
        // Dictionary objects with the matching generics, so probably not the best fit for most situations
        var fishyDictionaryExtension = Dictionary<String, Any>()
        fishyDictionaryExtension.skinColor = UIColor.redColor()

        print("...with a beautiful \"\(fishyDictionaryExtension.skinColor!)\" colored skin")
    }
}

