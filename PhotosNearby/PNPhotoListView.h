//
//  PNPhotoListView.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPhotoView.h"

@interface PNPhotoListView : UITableView

- (void)appendPhoto:(PNPhotoView*)photo;

@end
