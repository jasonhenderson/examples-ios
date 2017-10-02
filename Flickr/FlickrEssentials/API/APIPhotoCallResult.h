//
//  APIPhotoCallResult.h
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/22/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIPhotoCallResult : NSObject

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *pages;
@property (nonatomic, strong) NSNumber *perPage;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSArray *photos;

// Class initializers
+ (APIPhotoCallResult *)resultFromDictionary:(NSDictionary *)jsonData;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(NSDictionary *)jsonData NS_DESIGNATED_INITIALIZER;

// Allow next page to be added to the existing results
- (void)addPhotoCallResults:(APIPhotoCallResult *)nextResult;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSNumber *nextPage;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL hasMoreData;

@end
