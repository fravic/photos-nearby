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

- (CAGradientLayer*)blackGradientTop:(BOOL)top {
    UIColor *c1 = [UIColor colorWithWhite:0 alpha:0.0];
    UIColor *c2 = [UIColor colorWithWhite:0 alpha:0.5];
    NSArray *c =  [NSArray arrayWithObjects:(id)c1.CGColor, c2.CGColor, nil];
    
    NSNumber *l1 = [NSNumber numberWithFloat:0.0];
    NSNumber *l2 = [NSNumber numberWithFloat:0.6];

    NSArray *l = [NSArray arrayWithObjects:l1, l2, nil];

    CAGradientLayer *g = [CAGradientLayer layer];
    g.colors = c;
    g.locations = l;
    if (!top) {
        g.startPoint = CGPointMake(0,0);
        g.endPoint = CGPointMake(0,1.0);
    } else {
        g.startPoint = CGPointMake(0,1.0);
        g.endPoint = CGPointMake(0,0.0);
    }
    return g;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topBar = [[UIView alloc] init];
        [_topBar.layer addSublayer:[self blackGradientTop:YES]];

        _bottomBar = [[UIView alloc] init];
        [_bottomBar.layer addSublayer:[self blackGradientTop:NO]];

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
        _timeLabel.textAlignment = NSTextAlignmentRight;

        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        
        [_topBar addSubview:_mapButton];
        [_topBar addSubview:_timeLabel];
        [_topBar addSubview:_dateLabel];
        [_bottomBar addSubview:_apertureLabel];
        [_bottomBar addSubview:_isoLabel];
        [_bottomBar addSubview:_shutterSpeedLabel];
        [_bottomBar addSubview:_focalLengthLabel];
        [self addSubview:_topBar];
        [self addSubview:_bottomBar];
    }
    return self;
}

- (void)layoutSubviews {
    _topBar.frame = CGRectMake(0, 0, self.bounds.size.width, 50);
    [_topBar.layer.sublayers.firstObject setFrame:_topBar.bounds];

    _bottomBar.frame = CGRectMake(0, self.bounds.size.height - 50, self.bounds.size.width, 50);
    [_bottomBar.layer.sublayers.firstObject setFrame:_bottomBar.bounds];

    _mapButton.frame = CGRectMake(self.bounds.size.width - 40.0 -PN_PHOTO_AUX_DATA_EDGE_PADDING,
                                  PN_PHOTO_AUX_DATA_EDGE_PADDING,
                                  40, 35.0);
    _timeLabel.frame = CGRectMake(CGRectGetMinX(_mapButton.frame) - 100.0 - 10.0,
                                  CGRectGetMinY(_mapButton.frame) + 2.0,
                                  100, 15.0);
    _dateLabel.frame = CGRectMake(CGRectGetMinX(_timeLabel.frame),
                                  CGRectGetMaxY(_timeLabel.frame),
                                  100, 15.0);
}

- (void)updateFromPhoto:(PNPhoto*)photo {
    [self setISO:photo.iso];
    [self setAperture:photo.aperture];
    [self setShutterSpeed:photo.shutterSpeed];
    [self setFocalLength:photo.focalLength];
    [self setDate:photo.takenAt];
    [self setTime:photo.takenAt];
    [self setNeedsDisplay];
}

- (void)setISO:(NSString*)iso {
    
}

- (void)setAperture:(NSString*)aperture {
    
}

- (void)setShutterSpeed:(NSString*)shutterSpeed {
    
}

- (void)setFocalLength:(NSString*)focalLength {
    
}

- (void)setDate:(NSDate*)date {
    _dateLabel.hidden = (date == NULL);
    if (date == NULL) {
        return;
    }

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMM dd";
    NSMutableAttributedString *dateText = [[NSMutableAttributedString alloc] initWithString:[df stringFromDate:date]];

    [dateText addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont xSmallFont], NSFontAttributeName,
                             [UIColor whiteAlphaColor], NSForegroundColorAttributeName,
                             nil]
                      range:NSMakeRange(0, dateText.length)];

    _dateLabel.attributedText = dateText;
}

- (void)setTime:(NSDate*)time {
    _timeLabel.hidden = (time == NULL);
    if (time == NULL) {
        return;
    }

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"h:mma";
    NSString *timeString = [[df stringFromDate:time] lowercaseString];
    NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:timeString];

    [timeText addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont smallBoldFont], NSFontAttributeName,
                             [UIColor whiteColor], NSForegroundColorAttributeName,
                             nil]
                      range:NSMakeRange(0, timeString.length - 2)];
    [timeText addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont smallFont], NSFontAttributeName,
                             [UIColor whiteColor], NSForegroundColorAttributeName,
                             nil]
                      range:NSMakeRange(timeString.length - 2, 2)];

    _timeLabel.attributedText = timeText;
}

@end
