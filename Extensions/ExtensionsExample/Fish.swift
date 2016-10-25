//
//  Fish.swift
//  ExtensionsExample
//
//  Created by Jason Henderson on 10/6/16.
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

/// Example class that has `final` specified so it cannot just be derived. "Pretend" this is code you either (a) cannot 
/// access because it is final, or (b) do not want to derive for lack of knowledge or time for a proper implementation
final class Fish {
    
    /// The type of skin the fish sports. Supports custom printing.
    /// - Slimy: fish is nice and slippery
    /// - Rough: is coarse to the touch
    /// - Abnormal: is something else
    enum SkinType : CustomStringConvertible {
        case Slimy
        case Rough
        case Abnormal
        
        var description : String {
            get {
                switch self {
                case Slimy:
                    return "slippery"
                case Rough:
                    return "tough-to-touch"
                case Abnormal:
                    return "wow-looking"
                }
            }
        }
    }
}
