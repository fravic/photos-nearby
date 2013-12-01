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

- (void)setFocalLength:(NSString*)focalLength iso:(NSString*)iso shutterSpeed:(NSString*)shutterSpeed aperture:(NSString*)aperture takenAt:(NSDate *)takenAt {
    self.focalLength = focalLength;
    self.iso = iso;
    self.shutterSpeed = shutterSpeed;
    self.aperture = aperture;
    self.takenAt = takenAt;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"auxDataChanged" object:self];
}

@end
