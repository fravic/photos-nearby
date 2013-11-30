//
//  PNPhotoView.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoListViewCell.h"
#import <MapKit/MapKit.h>

@implementation PNPhotoListViewCell {
    PNPhoto *_photo;
    MKMapView *_mapView;
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
    
    if (_mapView) {
        CGRect mapFrame = CGRectMake(PN_PHOTO_LIST_VIEW_CELL_H_PAD/2, PN_PHOTO_LIST_VIEW_CELL_V_PAD/2, imageWidth,
            _photo.height/_photo.width * imageWidth);
        _mapView.frame = mapFrame;
    }
}

- (void)setActive:(BOOL)active {
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDefaultState];
    }
}

- (void)addMapView {
    _mapView = [[MKMapView alloc] init];
    _mapView.alpha = 0.0f;
    [self addSubview:_mapView];
    [self layoutSubviews];
}

- (void)removeMapView {
    [_mapView removeFromSuperview];
}

- (void)animateToActiveState {
    [self addMapView];
    
    CGFloat imageWidth = self.bounds.size.width - PN_PHOTO_LIST_VIEW_CELL_H_PAD;
    CGRect activeFrame = CGRectMake(0, PN_PHOTO_LIST_VIEW_CELL_V_PAD/2, imageWidth,
                                    _photo.height/_photo.width * imageWidth);

    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.imageView.frame = activeFrame;
                         _mapView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                     }
     ];
    
    [UIView beginAnimations:@"reposition" context:NULL];

    [UIView commitAnimations];
}

- (void)animateToDefaultState {
    CGFloat imageWidth = self.bounds.size.width - PN_PHOTO_LIST_VIEW_CELL_H_PAD;
    CGRect inactiveFrame = CGRectMake(PN_PHOTO_LIST_VIEW_CELL_H_PAD/2, PN_PHOTO_LIST_VIEW_CELL_V_PAD/2, imageWidth,
                                    _photo.height/_photo.width * imageWidth);

    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.imageView.frame = inactiveFrame;
                         _mapView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [self removeMapView];
                     }
     ];
}

@end
