//
//  Preferences.swift
//  Settings
//
//  Created by Jason Henderson on 10/23/17.
//  Copyright © 2017 Jason Henderson. All rights reserved.
//

import Foundation
import KeychainAccess

class Preferences : NSObject {
    static let shared: Preferences = {
        let instance = Preferences()
        // setup code
        return instance
    }()
    
    // From user defaults
    var useVolumeButtons:Bool {
        get {
            return Preferences.getBoolPreference("vol_buttons")
        }
        
        set {
            return Preferences.setBoolPreference("vol_buttons", newValue: newValue)
        }
    }
    
    // From user defaults
    var phone:String? {
        get {
            return UserDefaults.standard.value(forKey: "phone") as? String
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "phone")
        }
    }
    
    /// From user settings
    var favoriteNumber:String? {
        get {
            // Match the identifier in Root.plist
            return UserDefaults.standard.value(forKey: "fav_num") as? String
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "fav_num")
        }
    }
    
    // From keychain
    var passwordPhrase:String? {
        get {
            // https://github.com/kishikawakatsumi/KeychainAccess
            let keychain = Keychain(service: "edu.csumb.jahenderson.cst495.Settings")
            return keychain["pass_phrase"]
        }
        
        set {
            let keychain = Keychain(service: "edu.csumb.jahenderson.cst495.Settings")
            keychain["pass_phrase"] = newValue
        }
        // TDB: are accessors atomic (synchronized) in Swift 3+
}
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    // MARK: - Common
    static func getBoolPreference(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func setBoolPreference(_ key: String, newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: key)
        //NotificationCenter.default.post(name: .didUpdatePreferences, object: nil)
    }
    
    // MARK: - Defaults
    static func registerDefaults() {
        // First get custom defaults plist to get defaults for any user default
        let path = Bundle.main.path(forResource: "DefaultPreferences", ofType: "plist")!
        let defaultPrefs = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        
        UserDefaults.standard.register(defaults: defaultPrefs)

        // Then override with any defaults set in the Root.plist file
        if let settingsURL = Bundle.main.url(forResource: "Root", withExtension: "plist", subdirectory: "Settings.bundle"),
            let settingsPlist = NSDictionary(contentsOf: settingsURL),
            let preferences = settingsPlist["PreferenceSpecifiers"] as? [NSDictionary] {
            
            // Loop through the preferences, setting each default
            for prefSpecification in preferences {
                if let key = prefSpecification["Key"] as? String, let value = prefSpecification["DefaultValue"] {
                    //If key doesn't exists in userDefaults then register it, else keep original value
                    if UserDefaults.standard.value(forKey: key) == nil {
                        UserDefaults.standard.set(value, forKey: key)
                        print("registerDefaultsFromSettingsBundle: Set following to UserDefaults - (key: \(key), value: \(value), type: \(type(of: value)))")
                    }
                }
            }
        } else {
            print("registerDefaultsFromSettingsBundle: Could not find Settings.bundle")
        }
    }
    
    static func resetDefaults() {
        let appDomain = Bundle.main.bundleIdentifier!
        let defaults = UserDefaults.standard
        defaults.removePersistentDomain(forName: appDomain)
    }

}
