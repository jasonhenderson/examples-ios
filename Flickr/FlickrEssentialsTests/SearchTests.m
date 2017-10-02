//
//  SearchTests.m
//  UberFlickrTestJHTests
//
//  Created by Jason Henderson on 5/3/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import "KIFUITestActor+EXAdditions.m"

@interface SearchTests : KIFTestCase

@end

@implementation SearchTests

- (void)beforeEach
    {
    }
    
- (void)afterEach
    {
        // Do nothing
    }
    
- (void)testSuccessfulSearch
    {
        [tester navigateToSearchPage];
        [tester enterText:@"cats" intoViewWithAccessibilityLabel:@"Enter Search Text"];
        [tester tapViewWithAccessibilityLabel:@"Search"];
        [tester waitForViewWithAccessibilityLabel:@"Search"];

        // Verify that the search returned results succeeded
        //[tester waitForTappableViewWithAccessibilityLabel:@"Welcome"];
    }

@end

