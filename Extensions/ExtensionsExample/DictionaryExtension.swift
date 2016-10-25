//
//  DictionaryExtension.swift
//  ExtensionsExample
//
//  Created by Jason Henderson on 10/24/16.
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

/// Must use the where clause to further define what generic we are specifically extending
extension Dictionary where Key: StringLiteralConvertible {
    /// Color of the skin of the fish, stored in the dictionary
    var skinColor:UIColor? {
        get {
            return self["skinColor"] as? UIColor
        }
        set {
            // Have to cast to get this to work
            self["skinColor"] = (newValue as? Value)
        }
    }
    
    /// Initialize with skin color...it is logically convenience, but for structs, no such thing
    /// - parameters:
    ///     - skinColor: color of the skin of the fish
    init(skinColor: UIColor?) {
        self.init()
        self.skinColor = skinColor
    }
    
    /// Custom sorter that ranks the skin color by some who-knows algorithm
    func sortBySkinColor() {
        // Implement the specific sort
    }
}
