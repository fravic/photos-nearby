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

#define API_URL_PHOTO_SEARCH @"https://api.500px.com/v1/photos/search"
#define CONSUMER_KEY @"76rxNyJUalSRN318CBMHZLOxaCkQmberYDd9tGrN"

#define IMAGE_SIZE 4
#define SORT_BY @"rating"
#define CATEGORIES @"Landscapes,City%20and%20Architecture"

@implementation PNPhotoFetcher {
    PNLocationFetcher *_locationFetcher;
}

@synthesize results;

- (id)init {
    if (self = [super init]) {
        _locationFetcher = [[PNLocationFetcher alloc] init];
        self.results = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSURL*)getPhotoSearchURL {
    float lat = _locationFetcher.lat;
    float lng = _locationFetcher.lng;
    float range = 0.5f;

    NSMutableString *url = [NSMutableString stringWithString:API_URL_PHOTO_SEARCH];
    [url appendString:[NSString stringWithFormat:@"?geo=%f,%f,%fmi", lat, lng, range]];
    [url appendString:[NSString stringWithFormat:@"&image_size=%d", IMAGE_SIZE]];
    [url appendString:[NSString stringWithFormat:@"&sort=%@", SORT_BY]];
    [url appendString:[NSString stringWithFormat:@"&only=%@", CATEGORIES]];
    [url appendString:[NSString stringWithFormat:@"&consumer_key=%@", CONSUMER_KEY]];

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
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    NSArray *photos = [json objectForKey:@"photos"];
    
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary*)obj;
        
        PNPhoto *photo = [[PNPhoto alloc] init];
        photo.imageURL = [dict objectForKey:@"image_url"];
        photo.width = [[dict objectForKey:@"width"] floatValue];
        photo.height = [[dict objectForKey:@"height"] floatValue];
        photo.lat = [[dict objectForKey:@"latitude"] floatValue];
        photo.lng = [[dict objectForKey:@"longitude"] floatValue];
        [self.results addObject:photo];
        
        [self downloadImageForPhoto:photo];
    }];
    
    //
    // TODO: SORT RESULTS HERE
    //
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchedPhotoList" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.results, @"photos", nil]];
    
    [self.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self downloadImageForPhoto:obj];
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
            [self didReceivePhotoSearchData:data];
        }
    ];
}


@end
