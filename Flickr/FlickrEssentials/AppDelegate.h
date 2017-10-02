//
//  AppDelegate.h
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RZMessagingWindow;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RZMessagingWindow *errorWindow;

@end
