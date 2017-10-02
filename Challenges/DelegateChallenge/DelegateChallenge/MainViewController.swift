//
//  ViewController.swift
//  DelegateChallenge
//
//  Created by Jason Henderson on 9/25/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ModifyImageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Global.shared.rotation = 3.7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openPressed(_ sender: AnyObject) {
        let childVC = self.storyboard?.instantiateViewController(withIdentifier: "ChildVC") as! ModifyImageViewController
        
        // Try commenting out the following to see what happens...does the allDoneWithViewController method get called below?
        
        // Assign the delegate so that the child view controller can get back to the
        childVC.delegate = self
        childVC.dataSource = Global.shared
        
        // Present
        self.present(childVC, animated:true, completion:nil)
    }
    
    // MARK: - ModifyImageViewControllerDelegate
    
    /// The child controller called back with a message after completing its work successfully
    func successfullyModifiedImage(_ viewController: ModifyImageViewController, message: String?) {
        viewController.dismiss(animated: true) {
            if let text = message {
                print("\(text)")
            }
        }
    }
    
    /// The child controller called back with an optional error after not completing its work
    func failedToModifyImage(_ viewController: ModifyImageViewController, error: NSError?) {
        viewController.dismiss(animated: true) {
            if let problem = error {
                print("\(problem)")
            }
            else {
                print("No problems")
            }
        }
    }
}

