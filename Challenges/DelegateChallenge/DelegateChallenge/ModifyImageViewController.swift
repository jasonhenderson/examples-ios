//
//  ViewController.swift
//  DelegateChallenge
//
//  Created by Jason Henderson on 9/25/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import UIKit

@objc protocol ModifyImageViewControllerDelegate {
    func successfullyModifiedImage(_ viewController: ModifyImageViewController, message: String?)
    @objc optional func failedToModifyImage(_ viewController: ModifyImageViewController, error: NSError?)
}

@objc protocol TransformationDataSource {
    func needRotationTransformation(_ viewController: ModifyImageViewController) -> CGFloat
}

class ModifyImageViewController: UIViewController {

    weak var delegate:ModifyImageViewControllerDelegate?
    weak var dataSource:TransformationDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark - Transform Image
    @IBAction func transformPressed(_ sender: AnyObject) {
        if let transformation = dataSource?.needRotationTransformation(self) {
            //ImageView.transform = ImageView.transform.rotated(by: transformation)
        }
    }


}

