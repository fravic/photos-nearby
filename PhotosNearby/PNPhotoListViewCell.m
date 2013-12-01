//
//  PNPhotoView.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoListViewCell.h"
#import "PNPhotoAuxDataView.h"

@implementation PNPhotoListViewCell {
    PNPhoto *_photo;
    PNPhotoAuxDataView *_auxDataView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _auxDataView = [[PNPhotoAuxDataView alloc] init];
        _auxDataView.alpha = 0.0f;
        [self addSubview:_auxDataView];
    }
    return self;
}

- (void)setPhoto:(PNPhoto*)photo {
    _photo = photo;
    if (photo.image) {
        [self.imageView setImage:photo.image];
    }
    [_auxDataView updateFromPhoto:photo];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeImage:) name:@"imageChanged" object:photo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeAuxData:) name:@"auxDataChanged" object:photo];
}

- (void)didChangeImage:(NSNotification*)notification {
    [self.imageView setImage:_photo.image];
    [self layoutSubviews];
}

- (void)didChangeAuxData:(NSNotification*)notification {
    [_auxDataView updateFromPhoto:_photo];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageWidth = self.bounds.size.width - PN_PHOTO_LIST_VIEW_CELL_H_PAD;
    CGRect imageFrame = CGRectMake(PN_PHOTO_LIST_VIEW_CELL_H_PAD/2, PN_PHOTO_LIST_VIEW_CELL_V_PAD/2, imageWidth,
        _photo.height/_photo.width * imageWidth);
    self.imageView.frame = imageFrame;
    _auxDataView.frame = imageFrame;
}

- (void)setActive:(BOOL)active {
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDefaultState];
    }
}

- (void)animateToActiveState {
    [UIView animateWithDuration:0.25f
                     animations:^{
                         _auxDataView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                     }
     ];
}

- (void)animateToDefaultState {
    [UIView animateWithDuration:0.25f
                     animations:^{
                         _auxDataView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                     }
     ];
}

@end
