//
//  ViewController.swift
//  CodePathPlus
//
//  Created by Jason Henderson on 4/11/18.
//  Copyright © 2018 Jason Henderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var updateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(onWatchTicked(notification:)), name: .watchTicked, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .watchTicked, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onWatchTicked(notification: Notification) {
        print("this is the \(notification)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        let dateString = dateFormatter.string(from: notification.object as! Date) // Jan 2, 2001
        
        DispatchQueue.main.async {
            self.updateLabel.text = dateString
        }
    }
    
    


}

