//
//  PNPhotoFetcher.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PNPhotoFetcherDelegate <NSObject>
- (void)didReceivePhotos:(NSArray*)photos;
@end

@interface PNPhotoFetcher : NSObject

- (void)fetchForDelegate:(id<PNPhotoFetcherDelegate>)delegate;

@end
