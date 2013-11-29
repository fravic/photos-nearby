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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
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
    
    CGRect imageFrame = self.bounds;
    imageFrame.size.height = _photo.height/_photo.width * imageFrame.size.width;
    self.imageView.frame = imageFrame;
}

@end
