//
//  PicturesViewController.h
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotosViewController;

@protocol PhotosViewControllerDelegate <NSObject>

- (void)photosViewControllerDidClose:(PhotosViewController *)viewController;

@end

@interface PhotosViewController : UIViewController

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, weak) id<PhotosViewControllerDelegate> delegate;

@end
