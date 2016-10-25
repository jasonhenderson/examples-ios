//
//  FishExtension.swift
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

import UIKit
import ObjectiveC

// Keep this as a private structure: 1) allows easily to extend to multiple properties, 2) keeps us out of global mess
private struct AssociatedKeys {
    static var Length = "f_length"
    static var Skin = "f_skin"
}

/// Option 1. Extension
/// This is an example of an extension, for simple data types, for normal copy-on-write
/// structures (variables derived from Any), and for any objects that are AnyObjects

extension Fish {
    
    /// How we can take ANY structure or enum and force it into the AnyObject-needing associated object
    var length:Double? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.Length) as? Associated<Double>).map { $0.value }

            // Yes, this next line works--sort of. We get the free cast to NSNumber, but that is not
            // something we want to rely on for this example, because no other structs will be handled that way
            //return objc_getAssociatedObject(self, &AssociatedKeys.SizeOfNose) as? Double ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.Length, newValue.map { Associated<Double>($0) }, .OBJC_ASSOCIATION_RETAIN)
            
            // Same comment as in getter...this will work because we get free NSNumber
            //objc_setAssociatedObject(self, &AssociatedKeys.SizeOfNose, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// `struct` example of associated object in an extension
    var skin:SkinType? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.Skin) as? Associated<SkinType>).map { $0.value }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.Skin, newValue.map { Associated<SkinType>($0) }, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// Need `convenience` because we cannot have a designated initializer in an extension
    convenience init(length: Double?, skin:SkinType?) {
        self.init()
        self.length = length;
        self.skin = skin;
    }
}

/// Option 2. Wrapper pattern.