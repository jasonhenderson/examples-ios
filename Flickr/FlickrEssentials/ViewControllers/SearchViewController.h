//
//  FirstViewController.h
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerBase.h"

@interface SearchViewController : UIViewControllerBase

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

