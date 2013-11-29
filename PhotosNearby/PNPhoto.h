//
//  PNPhoto.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNPhoto : NSObject

@property (nonatomic, retain, setter=setImage:) UIImage *image;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) float lat;
@property (nonatomic) float lng;

@end
