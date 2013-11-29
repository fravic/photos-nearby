//
//  PNPhotoView.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoListViewCell.h"

@implementation PNPhotoListViewCell {
    PNPhoto *_photo;
}

- (void)setPhoto:(PNPhoto*)photo {
    _photo = photo;
    if (photo.image) {
        [self.imageView setImage:photo.image];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeImage:) name:@"imageChanged" object:photo];
}

- (void)didChangeImage:(NSNotification*)notification {
    [self.imageView setImage:_photo.image];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageWidth = self.bounds.size.width - PN_PHOTO_LIST_VIEW_CELL_H_PAD;
    CGRect imageFrame = CGRectMake(PN_PHOTO_LIST_VIEW_CELL_H_PAD/2, PN_PHOTO_LIST_VIEW_CELL_V_PAD/2, imageWidth,
        _photo.height/_photo.width * imageWidth);
    self.imageView.frame = imageFrame;
}

- (void)setActive:(BOOL)active {
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDefaultState];
    }
}

- (void)animateToActiveState {
    
}

- (void)animateToDefaultState {
    
}

@end
