//
//  Timer.swift
//  CodePathPlus
//
//  Created by Jason Henderson on 4/11/18.
//  Copyright © 2018 Jason Henderson. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Watcher : CLLocationManagerDelegate {
    static let shared: Watcher = {
        let instance = Watcher()
        // setup code
        instance.timer = Timer.scheduledTimer(timeInterval: 1, target: instance,   selector: (#selector(processTimer)), userInfo: nil, repeats: true)
        return instance
    }()
    
    var timer : Timer!
    
    func setup() {
        
    }
    
    @objc func processTimer(timer: Timer) {
        DispatchQueue.global(qos: .background).async {
            NotificationCenter.default.post(name: .watchTicked, object: Date())
        }
    }

}

extension Notification.Name {
    static let watchTicked = Notification.Name("watch.ticked")
}
