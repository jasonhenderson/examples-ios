//
//  ApiDictionary.swift
//  WebServices
//
//  Created by Jason Henderson on 10/16/17.
//  Copyright © 2017 Jason Henderson. All rights reserved.
//

import Foundation

typealias ApiDictionary = Dictionary<String, Any>

public protocol ApiDictionaryProperties {
    var name : String {
        get
    }
    
    var id : UInt64 {
        get
    }
}

extension Dictionary : ApiDictionaryProperties {
    public var name: String {
        get {
            return self["name" as! Key] as? String ?? ""
        }
    }
    
    public var id: UInt64 {
        get {
            return self["id" as! Key] as? UInt64 ?? 0
        }
    }
}
