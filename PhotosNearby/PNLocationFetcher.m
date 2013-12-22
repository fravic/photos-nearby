//
//  PNLocationFetcher.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNLocationFetcher.h"

#define SIMULATOR_LAT 42.9837f
#define SIMULATOR_LNG -81.2497f

@implementation PNLocationFetcher {
    CLLocationManager *_locationManager;
}

- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 300; // meters
        [_locationManager startUpdatingLocation];
        
        #if TARGET_IPHONE_SIMULATOR
        CLLocation *location = [[CLLocation alloc] initWithLatitude:SIMULATOR_LAT longitude:SIMULATOR_LNG];
        [self locationManager:_locationManager didUpdateLocations:[NSArray arrayWithObject:location]];
        #endif
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        self.lat = location.coordinate.latitude;
        self.lng = location.coordinate.longitude;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchedLocation" object:self];
    }
}

@end
