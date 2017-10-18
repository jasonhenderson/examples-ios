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
    
    var imageInfos = Array<ApiDictionary>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCallWebServiceTouched(_ sender: Any) {
        
        // Must be called on main
        self.view.makeToastActivity(.center)
        
        // Manufacture data
        let searchTerms = ["california fire", "hurricane", "tornado", "earthquake"]
        
        // Dispatch entire process off main so we don't lock anything
        DispatchQueue.global(qos: .default).async {
            
            defer {
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                    let description =
                        self.imageInfos
                            .map({ (imageInfo) -> String in
                                return imageInfo["title"] as? String ?? ""
                            })
                            .reduce("") {description, title in "\(description)\n\(title)"}
                    
                    self.resultTextView.text = description
                }
            }
            
            let groupQueue = DispatchQueue(label: "edu.csumb.cst.jahenderson", attributes: .concurrent, target: .global(qos: .default))
            let group = DispatchGroup()
            
            for (_, searchTerm) in searchTerms.enumerated() {
                
                group.enter()
                groupQueue.async(group: group) {
                    ApiHelper.fetchImages(search: searchTerm, completion: { (fetched: [ApiDictionary]?, error: Error?) in
                        defer {
                            // Must signal we are done
                            group.leave()
                        }
                        
                        guard let newImageInfos = fetched else {
                            return
                        }
                        
                        if error != nil {
                            return
                        }
                        
                        self.imageInfos.append(contentsOf: newImageInfos)
                        
                    })
                }
            }
            
            let _ = group.wait(timeout: .now() + 60)
        }
    }
}

