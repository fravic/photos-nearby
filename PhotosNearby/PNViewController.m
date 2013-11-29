//
//  PNViewController.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/26/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNViewController.h"
#import "PNPhotoListView.h"

@interface PNViewController ()

@end

@implementation PNViewController {
    PNPhotoFetcher *_fetcher;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fetcher = [[PNPhotoFetcher alloc] init];
    [_fetcher fetchForDelegate:self];
}

- (void)didReceivePhotos:(NSArray *)photos {
    NSLog(@"%@", photos);
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary*)obj;

        /*PNPhotoView *photo = [[PNPhotoView alloc] init];
        photo.image = [dict objectForKey:@"image_url"];
        photo.shutter = [dict objectForKey:@"shutter_speed"];
        photo.aperture = [dict objectForKey:@"aperture"];
        photo.iso = [dict objectForKey:@"iso"];
        photo.lat = [[dict objectForKey:@"latitude"] floatValue];
        photo.lng = [[dict objectForKey:@"longitude"] floatValue];*/
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
