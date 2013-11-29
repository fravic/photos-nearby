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
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _fetcher = [[PNPhotoFetcher alloc] init];
    [_fetcher fetch];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchPhotoList:) name:@"fetchedPhotoList" object:_fetcher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - Photo Fetcher

- (void)didFetchPhotoList:(NSNotification*)notification {
    // Data needs to be reloaded on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        NSLog(@"SIZE %f,%f", self.tableView.contentSize.width, self.tableView.contentSize.height);
    });
}

# pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fetcher.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    PNPhotoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PNPhotoListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    PNPhoto *photo = [_fetcher.results objectAtIndex:indexPath.row];
    [cell setPhoto:photo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.bounds.size.width;
    PNPhoto *photo = [_fetcher.results objectAtIndex:indexPath.row];
    return (photo.height/photo.width) * width + PN_PHOTO_LIST_VIEW_CELL_V_PAD;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
