//
//  ViewController.swift
//  Settings
//
//  Created by Jason Henderson on 10/23/17.
//  Copyright © 2017 Jason Henderson. All rights reserved.
//

import UIKit
import Toast_Swift
import JPSVolumeButtonHandler

class ViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var favoriteNumberLabel: UILabel!
    
    var volumeButtonHandler: JPSVolumeButtonHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        favoriteNumberLabel.text = Preferences.shared.favoriteNumber
        
        if let phone = Preferences.shared.phone {
            print("\(phone)")
            phoneTextField.text = phone
        }
        
        if Preferences.shared.useVolumeButtons {
            self.volumeButtonHandler = JPSVolumeButtonHandler(up: {
                self.onVolumeButtonTouched(.up)
            }, downBlock: {
                self.onVolumeButtonTouched(.down)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Called when the volume button on the side of the device is pressed
     
     - Parameter button: which button
     */
    func onVolumeButtonTouched(_ button : VolumeButton) {
        print("volume button touched")
    }
    
    /**
     Save the phone number entered into the text field
     This saves into user defaults, accessible inside the preferences singleton
     
     - Parameter sender: the view sending the touched event
     */
    @IBAction func savePhoneTouched(_ sender: Any) {
        Preferences.shared.phone = self.phoneTextField.text
    }
}

enum VolumeButton {
    case up
    case down
}

