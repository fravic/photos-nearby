//
//  PNViewController.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/26/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPhotoFetcher.h"
#import "PNPhotoListView.h"

@interface PNViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet PNPhotoListView *tableView;

@end
