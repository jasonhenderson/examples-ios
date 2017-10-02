//
//  PicturesViewController.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) APIPhotoCallResult *apiResult;

@end

@implementation PhotosViewController

////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Controller Life Cycle
////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Make sure the table element itself can be tested, but only in debug
    // so we don't annoy users who actually use the Accessibility API
#if DEBUG
    [self.collectionView setAccessibilityLabel:@"Photo Collection"];
    [self.collectionView setIsAccessibilityElement:YES];
#endif
    
    self.navigationItem.title = self.searchText;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // If we don't have a result (in the tab for the first time), load it
    if (!self.apiResult) {
        self.apiResult = [[APIPhotoCallResult alloc] init];
        
        // Initialize the results
        [self loadDataForPage:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Data Management
////////////////////////////////////////////////////////////////////////////////

- (void)loadDataForPage:(NSNumber *)page {
    // Turn off indicator
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Make the API call
    [APIHelper getPhotosForSearch:self.searchText onPage:page
                   withCompletion:^(APIPhotoCallResult *result, NSError *error)
     {
         // Turn off indicator
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if (error) {
             [AppData displayErrorWithTitle:@"Could not get photos from Flickr" error:error];
         }
         else {
             
             // Add to the pbotos, don't remove the photos we already have
             [self.apiResult addPhotoCallResults:result];
             
             // Refresh the collection view
             [self.collectionView reloadData];
         }
     }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.apiResult.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    NSDictionary *photoData = (self.apiResult.photos)[indexPath.row];
    NSString *farm = photoData[@"farm"];
    NSString *server = photoData[@"server"];
    NSString *photoId = photoData[@"id"];
    NSString *secret = photoData[@"secret"];
    
    NSString *url = [NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@.jpg", farm, server, photoId, secret];
    
    // Populate the picture once it gets back
    __block typeof(cell.photoImageView) blockImageView = cell.photoImageView;
    [cell.photoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                               placeholderImage:[UIImage imageNamed:@"missing-image.png"]
                                        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                            
                                            blockImageView.image = image;
                                            
                                        } failure:nil]; // TODO: consider doing something here
    
    
    // POOR MAN'S INFINITE SCROLL
    // If this is the last cell, go get more if there is any
    if (indexPath.row == self.apiResult.photos.count - 1 && [self.apiResult hasMoreData]) {
        [self loadDataForPage:self.apiResult.nextPage];
    }
    
    return cell;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDelegateFlowLayout
////////////////////////////////////////////////////////////////////////////////
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.2; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.collectionView reloadData];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Infinite Scroll
////////////////////////////////////////////////////////////////////////////////

// TODO: Consider Converting Infinite Scroll
// This is a probably a better approach than checking in cellForItemAtIndexPath
// (responsive to user input rather than just getting to the end)
// Need to play more with the triggering condition, factoring content offset, etc to make sure it is
// only triggered at the bottom with a reasonable acceration

//- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView.contentSize.height > self.collectionView.frame.size.height && apiResult.page < apiResult.pages) {
//        [self.collectionView performBatchUpdates:^{
//            NSUInteger startIndex = apiResult.photos.count;
//
//            [self loadDataForPage:apiResult.nextPage];
//
//            NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
//
//            for (NSUInteger i = startIndex; i < apiResult.photos.count; i++)
//                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//
//            [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
//
//        } completion:^(BOOL finished){
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath
//                                                          indexPathForRow:(apiResult.photos.count - 1)
//                                                          inSection:0]
//                                        atScrollPosition:UICollectionViewScrollPositionBottom
//                                                animated:YES];
//        }];
//    }
//}

@end
