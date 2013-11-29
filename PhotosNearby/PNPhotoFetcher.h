//
//  PNPhotoFetcher.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNPhoto.h"

@interface PNPhotoFetcher : NSObject

- (void)fetch;
- (void)downloadImageForPhoto:(PNPhoto*)url;

@property (nonatomic, retain) NSArray* results;

@end
