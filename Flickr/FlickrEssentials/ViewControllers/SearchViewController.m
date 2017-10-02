//
//  FirstViewController.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import "SearchViewController.h"
#import "PhotosViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Controller Life Cycle
////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moveUpForKeyboard = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////////////

- (IBAction)searchPressed:(id)sender {
    
    if (!(self.searchTextField.text).length) {
        [AppData displayErrorWithTitle:@"You must provide text" error:nil];
        return;
    }
    
    // First, log the history in the database
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        History *history = [History MR_createEntityInContext:localContext];
        history.searchText = self.searchTextField.text;
        history.date = [NSDate date];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (error) {
            [AppData displayErrorWithTitle:@"Could not save the search" error:error];
        }
        else {
            // Now segue to the photos view controller to see the photos
            [self performSegueWithIdentifier:@"SearchToPhotosSegue" sender:nil];
        }
    }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Navigation
////////////////////////////////////////////////////////////////////////////////

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchToPhotosSegue"]) {
        PhotosViewController *destination = segue.destinationViewController;
        
        // Set the search text
        destination.searchText = self.searchTextField.text;
    }
}

@end
