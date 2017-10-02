//
//  AppData.h
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import <Foundation/Foundation.h>

// Combine constants, typedefs here for simplicity...normally separate files

// Types
@class APIPhotoCallResult;

typedef void (^ResultObjectArgBlock)(id result, NSError *error);
typedef void (^APIPhotoCallResultBlock)(APIPhotoCallResult *result, NSError *error);

// Queues
#define dispatch_default_queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define dispatch_main_queue dispatch_get_main_queue()

#define APP_ERROR_DOMAIN @"com.hensys.FlickrEssentials"

@interface AppData : NSObject

// Static properties and methods

+ (AppData *)shared;

// Properties of the singleton

@property (atomic, strong) Reachability *reachability;

+ (BOOL)isConnected;

+ (NSError *)displayErrorWithTitle:(NSString *)title
                             error:(NSError *)error;

@end
