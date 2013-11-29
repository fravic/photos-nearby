//
//  PNPhotoView.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoView.h"

@implementation PNPhotoView {
    UIImageView *_imgView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage*)image {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    [_imgView setImage:image];
}

@end
