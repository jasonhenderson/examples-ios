//
//  Global.swift
//  DelegateChallenge
//
//  Created by Jason Henderson on 9/25/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import Foundation
import UIKit

class Global: NSObject, TransformationDataSource {
    
    // MARK: - Shared Instance
    
    static let shared: Global = {
        let instance = Global()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }

    // MARK: - Properties
    var rotation : CGFloat
    {
        get {
            return 8.3
        }
        set(newRotation) {
            // Do something with it
        }
    }
    
    // MARK: - TransformationDataSource Methods
    
    func needRotationTransformation(_ viewController: ModifyImageViewController) -> CGFloat {
        
        return rotation
    }

}
