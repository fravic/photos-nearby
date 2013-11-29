//
//  PNPhoto.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhoto.h"

@implementation PNPhoto {
    UIImage *_image;
}

@synthesize width, height, lat, lng, imageURL, image=_image;

- (void)setImage:(UIImage *)image {
    _image = image;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageChanged" object:self];
}

@end
