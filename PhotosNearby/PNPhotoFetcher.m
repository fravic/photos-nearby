//
//  PNPhotoFetcher.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoFetcher.h"
#import <SDWebImage/SDWebImageManager.h>

#define API_URL_PHOTO_SEARCH @"https://api.500px.com/v1/photos/search"
#define CONSUMER_KEY @"76rxNyJUalSRN318CBMHZLOxaCkQmberYDd9tGrN"

#define IMAGE_SIZE 4
#define SORT_BY @"rating"
#define CATEGORIES @"Landscapes,City%20and%20Architecture"

@implementation PNPhotoFetcher

@synthesize results;

- (NSURL*)getPhotoSearchURL {
    float lat = 37.7862f;
    float lng = -122.4371f;
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
    NSLog(@"Downloading %@", photo.imageURL);
    [manager downloadWithURL:[NSURL URLWithString:photo.imageURL]
                     options:0
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       if (image) {
                           photo.image = image;

                           [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchedPhoto" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:photo, @"photo", nil]];
                       }
                   }
     ];
}

- (void)didReceivePhotoSearchData:(NSData*)data {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    self.results = [json objectForKey:@"photos"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchedPhotoList" object:self];
    
    [self.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary*)obj;
        
        PNPhoto *photo = [[PNPhoto alloc] init];
        photo.imageURL = [dict objectForKey:@"image_url"];
        
        [self downloadImageForPhoto:photo];
    }];
}

- (void)fetch {
    NSURLRequest *request = [NSURLRequest requestWithURL:[self getPhotoSearchURL]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // Perform request and get JSON back as a NSData object
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            [self didReceivePhotoSearchData:data];
        }
    ];
}


@end
