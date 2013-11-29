//
//  PNPhotoFetcher.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoFetcher.h"

#define API_URL_PHOTO_SEARCH @"https://api.500px.com/v1/photos/search"
#define CONSUMER_KEY @"76rxNyJUalSRN318CBMHZLOxaCkQmberYDd9tGrN"

#define IMAGE_SIZE 4
#define SORT_BY @"rating"

@implementation PNPhotoFetcher {
    id<PNPhotoFetcherDelegate> _delegate;
}

- (NSURL*)getPhotoSearchURL {
    float lat = 37.7862f;
    float lng = -122.4371f;
    float range = 0.5f;

    NSMutableString *url = [NSMutableString stringWithString:API_URL_PHOTO_SEARCH];
    [url appendString:[NSString stringWithFormat:@"?geo=%f,%f,%fmi", lat, lng, range]];
    [url appendString:[NSString stringWithFormat:@"&image_size=%d", IMAGE_SIZE]];
    [url appendString:[NSString stringWithFormat:@"&sort=%@", SORT_BY]];
    [url appendString:[NSString stringWithFormat:@"&consumer_key=%@", CONSUMER_KEY]];

    return [NSURL URLWithString:url];
}

- (void)didReceivePhotoSearchData:(NSData*)data {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    NSArray *photos = [json objectForKey:@"photos"];
    [_delegate didReceivePhotos:photos];
}

- (void)fetchForDelegate:(id<PNPhotoFetcherDelegate>)delegate {
    _delegate = delegate;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self getPhotoSearchURL]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // Perform request and get JSON back as a NSData object
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            [self didReceivePhotoSearchData:data];
        }
    ];
}


@end
