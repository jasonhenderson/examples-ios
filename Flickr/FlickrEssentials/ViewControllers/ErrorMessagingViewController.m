//
//  DDErrorMessagingViewController.m
//  Inspector
//
//  Created by Jason Henderson on 3/31/16.
//  Copyright © 2016 DoorData Solutions. All rights reserved.
//

#import "ErrorMessagingViewController.h"

@implementation ErrorMessagingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // If you want a different look, then just make a new nib!!!
    self = [super initWithNibName:@"ErrorMessagingViewController" bundle:nibBundleOrNil];
    if (self) {
        self.colorForLevelDictionary = @{
                                         kRZLevelError :[UIColor redColor],
                                         kRZLevelInfo : [UIColor blueColor],
                                         kRZLevelWarning : [UIColor orangeColor],
                                         kRZLevelPositive : [UIColor colorWithRed:0.13333333333333 green:0.54509803921569 blue:0.13333333333333 alpha:1.0] // forest green
                                         };
        self.errorMessagingViewVerticalPadding = -200.0f;
    }
    return self;
}

@end
