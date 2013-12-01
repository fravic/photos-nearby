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
#import "PNSettingsButton.h"

#import <SDWebImage/UIImageView+WebCache.h>


@implementation PNViewController {
    PNPhotoFetcher *_fetcher;
    PNPhotoListViewCell *_activeCell;
    PNSettingsButton *_settingsBtn;
    PNMapViewController *_mapVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _fetcher = [[PNPhotoFetcher alloc] init];
    [_fetcher fetch];
    
    CGRect settingsBtnFrame = CGRectMake(0, self.view.bounds.size.height-37.5, 110.0, 37.5);
    _settingsBtn = [[PNSettingsButton alloc] initWithFrame:settingsBtnFrame];
    _settingsBtn.radius = 0.5;
    [self.view addSubview:_settingsBtn];

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
        [cell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    PNPhoto *photo = [_fetcher.results objectAtIndex:indexPath.row];
    [cell setPhoto:photo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.bounds.size.width - PN_PHOTO_LIST_VIEW_CELL_H_PAD;
    PNPhoto *photo = [_fetcher.results objectAtIndex:indexPath.row];
    return (photo.height/photo.width) * width;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22.0f)];
    headerView.backgroundColor = [UIColor pnDarkGrayColor];
    return headerView;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_activeCell) {
        [_activeCell setActive:NO];
    }
    PNPhotoListViewCell *newActiveCell = (PNPhotoListViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (_activeCell != newActiveCell) {
        _activeCell = newActiveCell;
        [_activeCell setActive:YES];
    } else {
        _activeCell = NULL;
    }
}

- (void)didTapMapButtonInCell:(PNPhotoListViewCell*)cell {
    _mapVC = [[PNMapViewController alloc] init];
    [_mapVC setDelegate:self];
    [_mapVC setPhoto:cell.photo];
    [_activeCell setPhotoHidden:YES];
    
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:cell]];
    CGRect imgRect = CGRectMake(cellRect.origin.x + cell.imageView.frame.origin.x,
                                cellRect.origin.y + cell.imageView.frame.origin.y,
                                cell.imageView.frame.size.width, cell.imageView.frame.size.height);
    CGRect imgRectInView = [self.tableView convertRect:imgRect toView:self.view];
    
    [self.view addSubview:_mapVC.view];
    [_mapVC animateInitialPhotoPosition:imgRectInView];
}

- (void)mapViewControllerDidSelectBack {
    [_mapVC.view removeFromSuperview];
    [_activeCell setPhotoHidden:NO];
}

@end
