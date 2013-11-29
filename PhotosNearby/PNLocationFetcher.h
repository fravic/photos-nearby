//
//  PNLocationFetcher.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PNLocationFetcher : NSObject <CLLocationManagerDelegate>

@property (nonatomic) float lat;
@property (nonatomic) float lng;

@end
