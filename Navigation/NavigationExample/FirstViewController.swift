//
//  FirstViewController.swift
//  NavigationExample
//
//  Created by Jason Henderson on 9/25/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, SecondViewControllerDelegate {

    @IBOutlet weak var infoBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var helpLabel: UILabel!
    var helpLabelTapGestureRecognizer = UITapGestureRecognizer()
    var nextButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup the custom button for navigation to the next screen
        self.nextButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fastForward, target: self, action: #selector(nextButtonPressed(_:)))
        self.navigationItem.rightBarButtonItems?.append(nextButton)
        
        // This line requires an EXACT method signature match
        self.helpLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(helpLabelTapped(_:)))
        self.helpLabelTapGestureRecognizer.numberOfTapsRequired = 1
        self.helpLabelTapGestureRecognizer.numberOfTouchesRequired = 1
        self.helpLabel.addGestureRecognizer(self.helpLabelTapGestureRecognizer)
        self.helpLabel.isUserInteractionEnabled = true
        
        helpLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navToFirstPressed() {
        self.performSegue(withIdentifier: "FirstToSecond", sender: self)
    }
    
    // Mark - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "FirstToSecond" {
            return true
        }
        
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SecondViewController {
            destVC.delegate = self
        }
    }
    
    @IBAction func infoPressed(_ sender: Any) {
        helpLabel.isHidden = false
        
    }

    func helpLabelTapped(_ recognizer: UITapGestureRecognizer) {
        helpLabel.isHidden = true
    }

    func nextButtonPressed(_ button: UIBarButtonItem) {
        self.performSegue(withIdentifier: "FirstToSecond", sender: self)
    }
    
    func done(_ viewController: SecondViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
    
}

