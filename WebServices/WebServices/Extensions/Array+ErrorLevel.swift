//
//  Array+ErrorLevel.swift
//  WebServices
//
//  Created by Jason Henderson on 10/18/17.
//  Copyright © 2017 Jason Henderson. All rights reserved.
//

import Foundation

extension Array where Element == ErrorWithLevel {
    var highestPriority : Element? {
        var highest : Element?
        for (_, current) in self.enumerated() {
            if let currentHighest = highest {
                highest =  current.priority > currentHighest.priority ? current : highest
            }
            else {
                highest = current
            }
        }
        return highest
    }
}

