//
//  Associated.swift
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

import Foundation

// Use this wrapper class to make sure that ALL structures (and enums) can be cast to AnyObject
// even in the case of copy-on-write structs; if not for copy-on-write implementations, 
// we would be able to wrap structures in NSValue for storage as an associated object
//
// A good blog entry for implementing copy-on-write for your own structures: 
// http://chris.eidhof.nl/post/struct-semantics-in-swift/
// 
// And for more on associated objects: http://nshipster.com/associated-objects/

public final class Associated<T>: NSObject, NSCopying {
    public typealias Type = T
    public let value: Type
    
    public init(_ value: Type) { self.value = value }
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init(value)
    }
}

extension Associated where T: NSCopying {
    public func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init(value.copyWithZone(zone) as! Type)
    }
}