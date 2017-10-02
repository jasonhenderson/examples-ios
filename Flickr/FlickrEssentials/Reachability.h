/*
 Copyright (c) 2011, Tony Million.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

//! Project version number for MacOSReachability.
FOUNDATION_EXPORT double ReachabilityVersionNumber;

//! Project version string for MacOSReachability.
FOUNDATION_EXPORT const unsigned char ReachabilityVersionString[];

/**
 * Create NS_ENUM macro if it does not exist on the targeted version of iOS or OS X.
 *
 * @see http://nshipster.com/ns_enum-ns_options/
 **/
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

extern NSString *const kReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class Reachability;

typedef void (^NetworkReachable)(Reachability * reachability);
typedef void (^NetworkUnreachable)(Reachability * reachability);
typedef void (^NetworkReachability)(Reachability * reachability, SCNetworkConnectionFlags flags);


@interface Reachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;
@property (nonatomic, copy) NetworkReachability reachabilityBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(instancetype)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(instancetype)reachabilityWithHostName:(NSString*)hostname;
+(instancetype)reachabilityForInternetConnection;
+(instancetype)reachabilityWithAddress:(void *)hostAddress;
+(instancetype)reachabilityForLocalWiFi;

-(instancetype)init NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL startNotifier;
-(void)stopNotifier;

@property (NS_NONATOMIC_IOSONLY, getter=isReachable, readonly) BOOL reachable;
@property (NS_NONATOMIC_IOSONLY, getter=isReachableViaWWAN, readonly) BOOL reachableViaWWAN;
@property (NS_NONATOMIC_IOSONLY, getter=isReachableViaWiFi, readonly) BOOL reachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
@property (NS_NONATOMIC_IOSONLY, getter=isConnectionRequired, readonly) BOOL connectionRequired; // Identical DDG variant.
//@property (NS_NONATOMIC_IOSONLY, readonly) BOOL connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
@property (NS_NONATOMIC_IOSONLY, getter=isConnectionOnDemand, readonly) BOOL connectionOnDemand;
// Is user intervention required?
@property (NS_NONATOMIC_IOSONLY, getter=isInterventionRequired, readonly) BOOL interventionRequired;

@property (NS_NONATOMIC_IOSONLY, readonly) NetworkStatus currentReachabilityStatus;
@property (NS_NONATOMIC_IOSONLY, readonly) SCNetworkReachabilityFlags reachabilityFlags;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *currentReachabilityString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *currentReachabilityFlags;

@end
