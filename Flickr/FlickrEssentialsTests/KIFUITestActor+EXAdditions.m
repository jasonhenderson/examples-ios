//
//  KIFUITestActor+EXAdditions.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 5/3/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import <KIF/KIF.h>

@implementation KIFUITestActor (EXAdditions)

- (void)navigateToSearchPage
{
    [self tapViewWithAccessibilityLabel:@"Search"];
    [self waitForViewWithAccessibilityLabel:@"Search"];
}

- (void)navigateToHistoryPage
{
    [self tapViewWithAccessibilityLabel:@"History"];
    [self waitForViewWithAccessibilityLabel:@"History"];
}

- (void)returnToLoggedOutHomeScreen
{
    //        [self tapViewWithAccessibilityLabel:@"Logout"];
    //        [self tapViewWithAccessibilityLabel:@"Logout"]; // Dismiss alert.
}

@end
