//
//  UIViewControllerBase.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/23/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import "UIViewControllerBase.h"

@interface UIViewControllerBase ()

    @property (nonatomic, assign) UIEdgeInsets preKeyboardContentInset;

@end

@implementation UIViewControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup the notification for when the keyboard pops up and down
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Keyboard
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)keyboardShown:(NSNotification *)notification
{
    if (self.moveUpForKeyboard && [(id)self scrollView]) {
        NSDictionary *info = notification.userInfo;
        CGRect keyboardRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        
        UIEdgeInsets contentInset = [(id)self scrollView].contentInset;
        contentInset.bottom = keyboardRect.size.height;
        [(id)self scrollView].contentInset = contentInset;
    }
}

- (void)keyboardHidden:(NSNotification *)notification
{
    if (self.moveUpForKeyboard && [(id)self scrollView]) {
        NSDictionary *info = notification.userInfo;
        CGRect keyboardRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        
        UIEdgeInsets contentInset = [(id)self scrollView].contentInset;
        contentInset.bottom = contentInset.bottom - keyboardRect.size.height;
        [(id)self scrollView].contentInset = contentInset;
    }
}

@end
