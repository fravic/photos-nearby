//
//  PNPhotoAuxDataView.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/30/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoAuxDataView.h"

#define PN_PHOTO_AUX_DATA_EDGE_PADDING 5.0f

@implementation PNPhotoAuxDataView {
    UIView *_topBar;
    UIButton *_mapButton;
    UILabel *_timeLabel;
    UILabel *_dateLabel;
    
    UIView *_bottomBar;
    UILabel *_apertureLabel;
    UILabel *_isoLabel;
    UILabel *_shutterSpeedLabel;
    UILabel *_focalLengthLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topBar = [[UIView alloc] init];
        _bottomBar = [[UIView alloc] init];

        _mapButton = [[UIButton alloc] init];
        [_mapButton setImage:[UIImage imageNamed:@"assets/icon_map.png"] forState:UIControlStateNormal];
        _mapButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _mapButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        [_mapButton setBackgroundColor:[[UIColor pnDarkGrayColor] colorWithAlphaComponent:0.7f]];
        _mapButton.layer.cornerRadius = 2.0f;

        _apertureLabel = [[UILabel alloc] init];
        _isoLabel = [[UILabel alloc] init];
        _shutterSpeedLabel = [[UILabel alloc] init];
        _focalLengthLabel = [[UILabel alloc] init];
        _timeLabel = [[UILabel alloc] init];
        _dateLabel = [[UILabel alloc] init];
        
        [_topBar addSubview:_mapButton];
        [_bottomBar addSubview:_apertureLabel];
        [_bottomBar addSubview:_isoLabel];
        [_bottomBar addSubview:_shutterSpeedLabel];
        [_bottomBar addSubview:_focalLengthLabel];
        [_topBar addSubview:_timeLabel];
        [_topBar addSubview:_dateLabel];
        [self addSubview:_topBar];
        [self addSubview:_bottomBar];
    }
    return self;
}

- (void)layoutSubviews {
    _topBar.frame = CGRectMake(0, 0, self.bounds.size.width, 50);
    _bottomBar.frame = CGRectMake(0, self.bounds.size.height - 50, self.bounds.size.width, 50);

    [_mapButton setFrame:CGRectMake(self.bounds.size.width - 40.0 - PN_PHOTO_AUX_DATA_EDGE_PADDING, PN_PHOTO_AUX_DATA_EDGE_PADDING, 40, 35.0)];
}

- (void)updateFromPhoto:(PNPhoto*)photo {
    
}

@end
