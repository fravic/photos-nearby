//
//  PNPhoto.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNPhoto : NSObject

- (void)setFocalLength:(NSString*)focalLength iso:(NSString*)iso shutterSpeed:(NSString*)shutterSpeed aperture:(NSString*)aperture takenAt:(NSDate*)takenAt;

// Base Data
@property (nonatomic) int photoId;
@property (nonatomic, retain, setter=setImage:) UIImage *image;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) float lat;
@property (nonatomic) float lng;

// Aux Data
@property (nonatomic) NSString *focalLength;
@property (nonatomic) NSString *iso;
@property (nonatomic) NSString *shutterSpeed;
@property (nonatomic) NSString *aperture;
@property (nonatomic) NSDate *takenAt;

@end
