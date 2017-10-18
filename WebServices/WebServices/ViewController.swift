//
//  ViewController.swift
//  WebServices
//
//  Created by Jason Henderson on 10/15/17.
//  Copyright © 2017 Jason Henderson. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController {
    
    @IBOutlet weak var resultTextView: UITextView!
    
    var result = (data: [ApiDictionary](), errors: [ErrorWithLevel]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCallWebServiceTouched(_ sender: Any) {
        
        // Reset call result data
        self.result.data.removeAll()
        self.result.errors.removeAll()
        
        // Must be called on main
        self.view.makeToastActivity(.center)
        
        // Manufacture data
        let searchTerms = ["california fire", "hurricane", "tornado", "earthquake"]
        
        // Dispatch entire process off main so we don't lock anything
        DispatchQueue.global(qos: .default).async {
            
            // This defer block executes at the end of the default QOS queue context
            defer {
                
                // Do UI stuff on main thread
                DispatchQueue.main.async {
                    // Always hide activity indicator
                    self.view.hideToastActivity()
                    
                    // If there are errors, present them
                    if self.result.errors.count > 0 {
                        guard let error = self.result.errors.highestPriority else {
                            return
                        }
                        
                        // Present the user with the error information
                        
                        // Prepare the styling of the toast
                        var style = ToastStyle()
                        style.titleAlignment = .center
                        style.messageAlignment = .center
                        style.backgroundColor = error.color
                        
                        // Display the toast
                        self.view.makeToast("\(error)", duration: 3.0, position: .center, title: "\(error.level)", image: nil, style: style)
                    }
                    else {
                        // Otherwise show the results
                        let description =
                            self.result.data
                                .map({ (imageInfo) -> String in
                                    return imageInfo["title"] as? String ?? ""
                                })
                                .reduce("") {description, title in "\(description)\n\(title)"}
                        
                        self.resultTextView.text = description
                    }
                }
            }
            
            ////////////////////////////////////////////////////////////////////////////////
            // Process the group of requests together
            ////////////////////////////////////////////////////////////////////////////////
            
            let groupQueue = DispatchQueue(label: "edu.csumb.cst.jahenderson", attributes: .concurrent, target: .global(qos: .default))
            let group = DispatchGroup()
            
            for (_, searchTerm) in searchTerms.enumerated() {
                
                group.enter()
                groupQueue.async(group: group) {
                    
                    ApiHelper.fetchImages(search: searchTerm) { fetched, error in
                        defer {
                            // But we must always signal we are done
                            group.leave()
                        }
                        
                        // Check for error first
                        if let foundError = error {
                            self.result.errors.append(foundError)
                            return
                        }
                        
                        // Then make sure we have data
                        guard let newImageInfos = fetched else {
                            return
                        }
                        
                        // Add the images found
                        self.result.data.append(contentsOf: newImageInfos)
                    }
                }
            }
            
            // Wait for all the calls to end or timeout
            let _ = group.wait(timeout: .now() + 60)
        }
    }
}

