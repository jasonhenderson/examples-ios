//
//  UIButtonExtension
//  UITableViewExample
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
    static var IndexPath = "tve_IndexPath"
    
}

extension UIButton {
    
    /// Add the index path to the button so we can track which row was clicked in a table view
    var indexPath:NSIndexPath? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.IndexPath) as? NSIndexPath
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.IndexPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}