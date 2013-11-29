//
//  PNViewController.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/26/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNViewController.h"
#import "PNPhotoListView.h"
#import "PNPhoto.h"

#import <SDWebImage/UIImageView+WebCache.h>


@implementation PNViewController {
    PNPhotoFetcher *_fetcher;
    NSMutableArray *_photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _photos = [[NSMutableArray alloc] init];
    _fetcher = [[PNPhotoFetcher alloc] init];
    [_fetcher fetch];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePhoto:) name:@"fetchedPhoto" object:_fetcher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - Photo Fetcher Delegate

- (void)didReceivePhoto:(NSNotification*)notification {
    [_photos addObject:[notification.userInfo objectForKey:@"photo"]];
    [self.tableView reloadData];
}

# pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    PNPhotoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PNPhotoListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    PNPhoto *photo = [_photos objectAtIndex:indexPath.row];
    [cell setImage:photo.image];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.bounds.size.width;
    PNPhoto *photo = [_photos objectAtIndex:indexPath.row];
    return photo.image.size.height / photo.image.size.width * width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
