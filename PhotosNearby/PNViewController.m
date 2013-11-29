//
//  PNViewController.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/26/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNViewController.h"
#import "PNPhotoListView.h"

#import <SDWebImage/UIImageView+WebCache.h>


@implementation PNViewController {
    PNPhotoFetcher *_fetcher;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fetcher = [[PNPhotoFetcher alloc] init];
    [_fetcher fetch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePhotos) name:@"fetchedPhotos" object:_fetcher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - Photo Fetcher Delegate

- (void)didReceivePhotos {
    [self.tableView reloadData];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Image #%d", indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSDictionary *photoData = [_fetcher.results objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[photoData objectForKey:@"image_url"]];
    
    [cell.imageView setImageWithURL:imageURL
                   placeholderImage:[UIImage imageNamed:@"placeholder"]
                            options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
