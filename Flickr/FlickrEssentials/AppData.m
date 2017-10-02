//
//  AppData.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import "AppData.h"

@implementation AppData

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Singleton
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+(AppData *)shared {
    if (_singleton == nil) {
        _singleton = [[AppData alloc] init];
    }
    return (AppData *)_singleton;
}
static id _singleton;
+ (id)singleton{
    return _singleton;
}

+ (void) setSingleton:(id)singleton{
    if (_singleton != singleton)
    {
        _singleton = singleton;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Singleton Properties
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize reachability = _reachability;
- (Reachability *) reachability {
    if (!_reachability) {
        _reachability = [Reachability reachabilityWithHostname:@"www.doordatasolutions.com"];
    }
    return _reachability;
}

- (void)setReachability:(Reachability *)reachability {
    _reachability = reachability;
}

+ (BOOL)isConnected {
    return [self shared].reachability ? [[self shared].reachability isReachable] : NO;
}

+ (NSError *)displayErrorWithTitle:(NSString *)title
                             error:(NSError *)error
{
    NSError *newError = [RZErrorMessenger errorWithDisplayTitle:title detail:nil error:error];
    return [RZErrorMessenger displayError:newError withStrength:kRZMessageStrengthWeakAutoDismiss animated:YES];
}


@end
