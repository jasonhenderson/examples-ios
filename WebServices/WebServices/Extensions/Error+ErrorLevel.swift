//
//  Error+Level.swift
//  WebServices
//
//  Created by Jason Henderson on 10/18/17.
//  Copyright © 2017 Jason Henderson. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorWithLevel : Error {
    var level: ErrorLevel { get }
    var color: UIColor { get }
    var priority: Int { get }
}

enum ErrorLevel : CustomStringConvertible {
    case error
    case warning
    case info
    
    var description: String {
        switch self {
        case .error:
            return "Error"
        case .warning:
            return "Warning"
        case .info:
            return "Info"
        }
    }
    
    var color : UIColor {
        switch (self) {
        case .error:
            return UIColor.red
        case .warning:
            return UIColor.red
        case .info:
            return UIColor.red
        }
    }
    
    var priority : Int {
        switch (self) {
        case .error:
            return 3
        case .warning:
            return 2
        case .info:
            return 1
        }
    }
}

