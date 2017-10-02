//
//  APIPhotoCallResult.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/22/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import "APIPhotoCallResult.h"

@implementation APIPhotoCallResult

+ (APIPhotoCallResult *)resultFromDictionary:(NSDictionary *)jsonData {
    return [[APIPhotoCallResult alloc] initWithDictionary:jsonData];
}

- (instancetype)init {
    return [super init];
}

- (instancetype)initWithDictionary:(NSDictionary *)jsonData {
    self = [super init];
    if (self) {
        NSDictionary *photos = jsonData[@"photos"];
        self.page = photos[@"page"];
        self.pages = photos[@"pages"];
        self.perPage = photos[@"perpage"];
        self.total = photos[@"total"];
        self.photos = photos[@"photo"];
    }
    return self;
}

- (void)addPhotoCallResults:(APIPhotoCallResult *)nextResult {
    self.page = nextResult.page;
    self.pages = nextResult.pages;
    self.perPage = nextResult.perPage;
    self.total = nextResult.total;
    if (nextResult.photos.count) {
        NSMutableArray *newPhotos = [NSMutableArray arrayWithArray:self.photos];
        [newPhotos addObjectsFromArray:nextResult.photos];
        self.photos = [newPhotos copy];
    }
}

- (NSNumber *)nextPage {
    return @((self.page).integerValue + 1);
}

- (BOOL)hasMoreData {
    return ((self.page).integerValue < (self.pages).integerValue);
}

@end
