//
//  SecondViewController.swift
//  NavigationExample
//
//  Created by Jason Henderson on 9/25/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import UIKit

@objc protocol SecondViewControllerDelegate {
    func done(_ viewController: SecondViewController)
}

class SecondViewController: UIViewController {

    weak var delegate:SecondViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.delegate?.done(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

