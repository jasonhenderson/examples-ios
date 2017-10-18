//
//  ApiHelper.swift
//  WebServices
//
//  Created by Jason Henderson on 10/16/17.
//  Copyright © 2017 Jason Henderson. All rights reserved.
//

import Foundation
import Alamofire

class ApiHelper {
    
    /**
        Gets the images from Flickr that match the search term
     
        - parameter search: the string for which the search is being made
        - parameter completion: block to execute upon completion
        - parameter data: the data returned, if there is no error
        - parameter error: the error that may have occurred during processing
    */
    static func fetchImages(search term:String?, completion: @escaping ([ApiDictionary]?, ApiError?) -> Void) {
        // Make sure we have a search term AND...
        // Make sure it is URL encoded (to handle spaces amongst other offenders)
        guard
            let searchTerm = term,
            let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else {
                completion(nil, ApiError.badInputs(.error))
                return
        }
        
        // Use hard-coded URL, for now...
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&per_page=99&text=\(encodedSearchTerm)&page=1"
        
        // Make sure the response jumps off the main queue too
        let requestQueue = DispatchQueue(label: "com.test.api", qos: .default, attributes: .concurrent)
        
        // Request the code
        Alamofire.request(
            url,
            method: .get,
            encoding: JSONEncoding.default)
            .validate()
            
            // Checkout the function declaration and how we reduced closure syntax
            // @discardableResult
            // public func responseJSON(
            //   queue: DispatchQueue? = nil,
            //   options: JSONSerialization.ReadingOptions = .allowFragments,
            //   completionHandler: @escaping (DataResponse<Any>) -> Void)
            //   -> Self
            .responseJSON(queue: requestQueue) { response in
                
                // Make sure we had success
                guard response.result.isSuccess else {
                    completion(nil, ApiError.serverError(.error))
                    return
                }
                
                // Now make sure data looks good
                guard
                    let data = response.result.value as? ApiDictionary,
                    let container = data["photos"] as? ApiDictionary,
                    let photos = container["photo"] as? [ApiDictionary]
                    else {
                        completion(nil, ApiError.badDataReturned(.error))
                        return
                }
                
                // We are in good shape
                completion(photos, nil)
        }
    }
}
