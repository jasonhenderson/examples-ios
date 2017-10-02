//
//  JSONResponseSerializer.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/22/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import "JSONResponseSerializer.h"

@interface JSONResponseSerializer ()
{
    NSString *_responseText;
}

@end

@implementation JSONResponseSerializer

- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError * __autoreleasing *)error
{
    BOOL responseIsValid = [super validateResponse:response data:data error:error];
    
    if (!responseIsValid) {
        NSError *errorPointer = *error;
        NSData *responseErrorData = errorPointer.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *responseErrorString = nil;
        if (responseErrorData) {
            responseErrorString = [[NSJSONSerialization JSONObjectWithData:responseErrorData options:0 error:nil] description];
        }
        
        NSMutableDictionary *mutableUserInfo = [errorPointer.userInfo mutableCopy];
        if (responseErrorString) {
            mutableUserInfo[@"com.doordata.error"] = responseErrorString;
        }
        *error = [NSError errorWithDomain:errorPointer.domain code:errorPointer.code userInfo:[mutableUserInfo copy]];
    }
    
    // Always populate the response text
    if (data.length) {
        _responseText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return responseIsValid;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    
    // If there is an error, make sure the response text is included in it
    NSError *errorPointer = *error;
    if (errorPointer) {
        responseObject = _responseText;
    }
    
    return responseObject;
}

@end
