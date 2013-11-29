//
//  PNPhotoFetcher.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNPhotoFetcher : NSObject

- (void)fetch;

@property (nonatomic, retain) NSArray* results;

@end
