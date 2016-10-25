//
//  FishDictionaryWrapper.swift
//  ExtensionsExample
//
//  Created by Jason Henderson on 10/7/16.
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

import Foundation
import UIKit

/// Dictionary is particularly important because we use it when converting to and from JSON,
/// and as a thread-safe vehicle in Core Data; so, sometimes, we like data in this convenient form,
/// but still like some syntactical convenience retained.
class FishDictionaryWrapper {

    /// The base data storage
    var fishDictionary = Dictionary<String, AnyObject>()

    /// Custom properties that interact directly with the underlying data storage
    var eyeColor:UIColor? {
        get {
            return fishDictionary["eyeColor"] as? UIColor
        }
        set {
            fishDictionary["eyeColor"] = newValue
        }
    }
    
    // Add other methods or store other things here, that are not necessarily something you want in the dictionary,
    // rather, things ABOUT the dictionary itself which we cannot do in an extension
    
    /// A silly example
    var allowedProperties = [Selector]()
    
    init(properties:[String]) {
        for property in properties {
            let selector = Selector(property)
            allowedProperties.append(selector)
        }
    }
}

