//
//  PNPhotoView.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPhoto.h"

#define PN_PHOTO_LIST_VIEW_CELL_H_PAD 10
#define PN_PHOTO_LIST_VIEW_CELL_V_PAD 10

@class PNPhotoListViewCell;

@protocol PNPhotoListViewCellDelegate <NSObject>
- (void)didTapMapButtonInCell:(PNPhotoListViewCell*)cell;
@end

@interface PNPhotoListViewCell : UITableViewCell

- (void)setActive:(BOOL)active;
- (void)setDelegate:(id<PNPhotoListViewCellDelegate>)active;
- (void)setPhotoHidden:(BOOL)hidden;

@property (nonatomic, retain, setter=setPhoto:) PNPhoto* photo;

@end
