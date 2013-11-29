//
//  PNPhotoView.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoListViewCell.h"

@implementation PNPhotoListViewCell {
    UIImageView *_imgView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    [self.imageView setImage:image];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageFrame = self.bounds;
    UIImage *image = self.imageView.image;
    imageFrame.size.height = image.size.height / image.size.width * imageFrame.size.width;
    self.imageView.frame = imageFrame;
}

@end
