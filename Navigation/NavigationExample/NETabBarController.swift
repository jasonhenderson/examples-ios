//
//  NETabBarController.swift
//  NavigationExample
//
//  Created by Jason Henderson on 9/25/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import Foundation
import UIKit

class NETabBarController : UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return false
    }
    
}
