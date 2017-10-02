//
//  APIHelper.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import "APIHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "JSONResponseSerializer.h"

@implementation APIHelper

+ (void)getPhotosForSearch:(NSString *)searchText
                    onPage:(NSNumber *)page
            withCompletion:(APIPhotoCallResultBlock)completion
{
    if (![AppData isConnected]) {
        if (completion) {
            NSError *unreachableError = [NSError errorWithDomain:APP_ERROR_DOMAIN
                                                            code:-1001
                                                        userInfo:@{ NSLocalizedDescriptionKey : @"No network connection" }];
            completion(nil, unreachableError);
            // Do not pop message here.
        }
        return ;
    }
    
    // Connected so continue
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // Don't complete on the main queue
    manager.completionQueue = dispatch_default_queue;
    
    // Setup the allowed types
    manager.responseSerializer = [JSONResponseSerializer serializer];
    ((AFHTTPResponseSerializer <AFURLResponseSerialization> *)manager.responseSerializer).acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", nil];
    
    // Prepare the API URL
    NSString *escapedSearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&per_page=99&text=%@&page=%@",
                     escapedSearchText, page];
    
    // Create the request with the post data and the the API url
    NSError *createRequestError = nil;
    
    NSMutableURLRequest *request =
    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                  URLString:url
                                                 parameters:nil
                                                      error:&createRequestError];
    
    // Timeout after x seconds
    request.timeoutInterval = 30.0;
    
    if (createRequestError) {
        // There was an error creating the request
        if (completion) {
            completion(nil, createRequestError);
        }
    }
    else {
        // Execute the command
        NSURLSessionDataTask *dataTask =
        [manager dataTaskWithRequest:request
                   completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                       dispatch_async(dispatch_default_queue, ^{
                           // Make callback with results
                           if (completion) {
                               NSError *serverError = nil;
                               if (!error) {
                                   if ([responseObject isKindOfClass:[NSString class]]) {
                                       // HTML is being returned, possibly because user is on a guest network
                                       serverError = [NSError errorWithDomain:APP_ERROR_DOMAIN
                                                                         code:-1002
                                                                     userInfo:@{ NSLocalizedDescriptionKey : @"Network is connected but may not be authorized" }];
                                   }
                                   else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                       NSString *status = [responseObject valueForKey:@"stat"];
                                       
                                       // You have to check to see if there is a message. 200 is error, 100 is success
                                       if (![status isEqualToString:@"ok"]) {
                                           serverError = [NSError errorWithDomain:APP_ERROR_DOMAIN
                                                                             code:-1003
                                                                         userInfo:@{ NSLocalizedDescriptionKey : status }];
                                       }
                                   }
                               }
                               
                               dispatch_async(dispatch_main_queue, ^{
                                   completion([APIPhotoCallResult resultFromDictionary:responseObject], error ?: serverError);
                               });
                           }
                       });
                   }];
        
        [dataTask resume];
    }
}

@end
