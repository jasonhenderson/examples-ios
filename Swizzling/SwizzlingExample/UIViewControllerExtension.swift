//
//  SwizzledSwiftUIViewController.swift
//  Swizzling
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
import UIKit
import ObjectiveC

/// Courtesy, with some updates, of http://nshipster.com/swift-objc-runtime/
extension UIViewController {

    /// Used with associated objects to store additional AnyObjects in extended class
    private struct AssociatedKeys {
        static var DescriptiveName = "se_DescriptiveName"
    }
    
    /// Some contrived property for use in this example
    var descriptiveName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? String
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    newValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    /// Swizzle in initialize since it is guaranteed to be executed, and load is never executed by Swift
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        
        // Always wrap in dispatch_once since the swizzle is executed at the global scope
        dispatch_once(&Static.token) {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(sss_viewWillAppear(_:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }

    /// This is called whenever viewWillAppear is called, since we swapped them above
    func sss_viewWillAppear(animated: Bool) {
        
        // Does not actually call this method, but the normal viewWillAppear, since we switched them in initialize
        self.sss_viewWillAppear(animated)
        
        // Just a demo of associated objects, not really pertinent to the swizzling example
        if let name = descriptiveName {
            print("viewWillAppear was swizzled in Swift and had a descriptiveName! (\(name))")
        } else {
            print("viewWillAppear was swizzled in Swift with no descriptiveName!")
        }
    }
}

