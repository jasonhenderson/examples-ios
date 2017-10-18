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
    static func fetchImages(search term:String?, completion: @escaping ([ApiDictionary]?, Error?) -> Void) {
        guard
            let searchTerm = term,
            let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else {
                completion(nil, ApiError.badInputs)
                return
        }
        
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&per_page=99&text=\(encodedSearchTerm)&page=1"
        
        // Make sure the response jumps off the main queue too
        let requestQueue = DispatchQueue(label: "com.test.api", qos: .default, attributes: .concurrent)
        
        Alamofire.request(
            url,
            method: .get,
            encoding: JSONEncoding.default)
            .validate()
            .responseJSON(queue: requestQueue) { (response) -> Void in
                guard response.result.isSuccess else {
                    completion(nil, ApiError.serverError)
                    return
                }
                
                guard
                    let data = response.result.value as? ApiDictionary,
                    let container = data["photos"] as? ApiDictionary,
                    let photos = container["photo"] as? [ApiDictionary]
                    else {
                        completion(nil, ApiError.badDataReturned)
                    return
                }
                
                completion(photos, nil)
        }
    }
}

enum ApiError: Error {
    case noConnection
    case lowBandwidth
    case fileNotFound
    case badInputs
    case serverError
    case noDataReturned
    case badDataReturned
}

