//
//  UIViewController+SwizzledObjC.m
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

#import "UIViewController+SwizzledObjC.h"
#import <objc/runtime.h>

@implementation UIViewController (SwizzledObjC)

/// Swizzle in load since it is the only method guaranteed to be executed before initialization
/// (initialize may not be run at all)
+ (void)load {
    
    // Always wrap in dispatch_once since the swizzle is executed at the global scope
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(ooo_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

/// This is called whenever viewWillAppear is called, since we swapped them above
- (void)ooo_viewWillAppear:(BOOL)animated {

    // Does not actually call this method, but the normal viewWillAppear, since we switched them in initialize
    [self ooo_viewWillAppear:animated];
    
    NSLog(@"viewWillAppear was swizzled in Obj-C!");
}

@end
