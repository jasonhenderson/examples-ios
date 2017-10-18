//
//  ApiError.swift
//  WebServices
//
//  Created by Jason Henderson on 10/18/17.
//  Copyright © 2017 Jason Henderson. All rights reserved.
//

import Foundation
import UIKit

// Fancier way to manage our errors using enum and associated values
enum ApiError: ErrorWithLevel, CustomStringConvertible {
    case unknown(ErrorLevel)
    case noConnection(ErrorLevel)
    case lowBandwidth(ErrorLevel)
    case fileNotFound(ErrorLevel)
    case badInputs(ErrorLevel)
    case serverError(ErrorLevel)
    case noDataReturned(ErrorLevel)
    case badDataReturned(ErrorLevel)
    
    ////////////////////////////////////////
    // ErrorWithLevel Protocol
    ////////////////////////////////////////
    var level : ErrorLevel {
        switch (self) {
        case .unknown(let level):
            return level
        case .noConnection(let level):
            return level
        case .lowBandwidth(let level):
            return level
        case .fileNotFound(let level):
            return level
        case .badInputs(let level):
            return level
        case .serverError(let level):
            return level
        case .noDataReturned(let level):
            return level
        case .badDataReturned(let level):
            return level
        }
    }
    
    var priority: Int {
        return self.level.priority
    }
    
    var color : UIColor {
        return self.level.color
    }

    ////////////////////////////////////////
    // CustomStringConvertible Protocol
    ////////////////////////////////////////
    var description: String {
        switch (self) {
        case .unknown:
            return "\(self.level): unknown error"
        case .noConnection:
            return "\(self.level): there is no connection"
        case .lowBandwidth:
            return "\(self.level): connection is bad"
        case .fileNotFound:
            return "\(self.level): couldn't find resource requested"
        case .badInputs:
            return "\(self.level): parameters passed in were bad"
        case .serverError:
            return "\(self.level): error on the server"
        case .noDataReturned:
            return "\(self.level): no data found on the server"
        case .badDataReturned:
            return "\(self.level): data returned by the server was bad"
        }
    }
}

