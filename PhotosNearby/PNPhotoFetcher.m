//
//  PNPhotoFetcher.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoFetcher.h"
#import "PNLocationFetcher.h"
#import <SDWebImage/SDWebImageManager.h>

#if TARGET_IPHONE_SIMULATOR
#define API_URL_PHOTO_SEARCH @"http://localhost:8080"
#define API_URL_PHOTO_DATA @"http://localhost:8080/data"
#else
#define API_URL_PHOTO_SEARCH @"http://54.202.155.62:8080"
#define API_URL_PHOTO_DATA @"http://54.202.155.62:8080/data"
#endif

@implementation PNPhotoFetcher {
    PNLocationFetcher *_locationFetcher;
    NSMutableDictionary *_photosById;
}

@synthesize results;

- (id)init {
    if (self = [super init]) {
        _locationFetcher = [[PNLocationFetcher alloc] init];
        _photosById = [[NSMutableDictionary alloc] init];
        self.results = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSURL*)getPhotoSearchURL {
    float lat = _locationFetcher.lat;
    float lng = _locationFetcher.lng;
    NSString *radius = @"0.5mi";

    NSMutableString *url = [NSMutableString stringWithString:API_URL_PHOTO_SEARCH];
    [url appendString:[NSString stringWithFormat:@"?lat=%f&lng=%f&radius=%@", lat, lng, radius]];

    return [NSURL URLWithString:url];
}

- (NSURL*)getDataURLForPhotos:(NSArray*)photos {
    NSMutableString *photoIds = [[NSMutableString alloc] init];
    [photos enumerateObjectsUsingBlock:^(PNPhoto* obj, NSUInteger idx, BOOL *stop) {
        [photoIds appendString:[NSString stringWithFormat:@"%d,", obj.photoId]];
    }];
    NSMutableString *url = [NSMutableString stringWithString:API_URL_PHOTO_DATA];
    [url appendString:[NSString stringWithFormat:@"?photos=%@", photoIds]];
    
    return [NSURL URLWithString:url];
}

- (void)downloadImageForPhoto:(PNPhoto *)photo {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:photo.imageURL]
                     options:0
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       if (image) {
                           photo.image = image;
                       }
                   }
     ];
}

- (void)didReceivePhotoSearchData:(NSData*)data {
    NSError *error;
    NSArray *photos = [NSJSONSerialization JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary*)obj;
        
        PNPhoto *photo = [[PNPhoto alloc] init];
        photo.photoId = [[dict objectForKey:@"id"] integerValue];
        photo.imageURL = [dict objectForKey:@"image_url"];
        photo.width = [[dict objectForKey:@"width"] floatValue];
        photo.height = [[dict objectForKey:@"height"] floatValue];
        photo.lat = [[dict objectForKey:@"latitude"] floatValue];
        photo.lng = [[dict objectForKey:@"longitude"] floatValue];

        [self.results addObject:photo];
        [_photosById setObject:photo forKey:[NSNumber numberWithInt:photo.photoId]];

        [self downloadImageForPhoto:photo];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchedPhotoList" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.results, @"photos", nil]];
    
    [self fetchDataForPhotos:self.results];
}

- (BOOL)isEffectivelyNull:(NSString*)obj {
    return [obj isKindOfClass:NSNull.class] || [obj isEqualToString:@""];
}

- (void)didReceivePhotoAuxData:(NSData*)data {
    NSError *error;
    NSArray *photos = [NSJSONSerialization JSONObjectWithData:data
                                                      options:kNilOptions
                                                        error:&error];
    
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary*)obj;
        
        PNPhoto *photo = [_photosById objectForKey:[NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]]];

        NSString *takenAtStr = [dict objectForKey:@"taken_at"];
        NSDate *takenAt = NULL;
        if (![takenAtStr isKindOfClass:NSNull.class]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"];
            takenAt = [dateFormat dateFromString:takenAtStr];
        }
        
        NSString *focalLength = [dict objectForKey:@"focal_length"];
        NSString *iso = [dict objectForKey:@"iso"];
        NSString *shutterSpeed = [dict objectForKey:@"shutter_speed"];
        NSString *aperture = [dict objectForKey:@"aperture"];

        [photo setFocalLength:(![self isEffectivelyNull:focalLength] ? focalLength : NULL)
                          iso:(![self isEffectivelyNull:iso] ? iso : NULL)
                 shutterSpeed:(![self isEffectivelyNull:shutterSpeed] ? shutterSpeed : NULL)
                     aperture:(![self isEffectivelyNull:aperture] ? aperture : NULL)
                      takenAt:takenAt];
    }];
}

- (void)fetch {
    if (_locationFetcher.lat && _locationFetcher.lng) {
        [self _fetch];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_fetch) name:@"fetchedLocation" object:_locationFetcher];
    }
}

- (void)_fetch {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSURLRequest *request = [NSURLRequest requestWithURL:[self getPhotoSearchURL]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // Perform request and get JSON back as a NSData object
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (!data) {
                NSLog(@"%@", error);
            } else {
                [self didReceivePhotoSearchData:data];
            }
        }
    ];
}

- (void)fetchDataForPhotos:(NSArray*)photos {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self getDataURLForPhotos:photos]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // Perform request and get JSON back as a NSData object
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (!data) {
            NSLog(@"%@", error);
        } else {
            [self didReceivePhotoAuxData:data];
        }
    }];
}

@end
