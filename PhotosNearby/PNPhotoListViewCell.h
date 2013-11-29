//
//  PNPhotoView.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPhoto.h"

#define PN_PHOTO_LIST_VIEW_CELL_V_PAD 10

@interface PNPhotoListViewCell : UITableViewCell
    
- (void)setPhoto:(PNPhoto*)photo;

@end
