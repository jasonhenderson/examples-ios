//
//  APIHelper.h
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIHelper : NSObject

+ (void)getPhotosForSearch:(NSString *)searchText
                    onPage:(NSNumber *)page
            withCompletion:(APIPhotoCallResultBlock)completion;

@end
