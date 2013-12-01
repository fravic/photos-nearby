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
    UIColor *c2 = [UIColor colorWithWhite:0 alpha:0.05];
    UIColor *c3 = [UIColor colorWithWhite:0 alpha:0.5];
    UIColor *c4 = [UIColor colorWithWhite:0 alpha:0.6];
    NSArray *c =  [NSArray arrayWithObjects:(id)c1.CGColor, c2.CGColor, c3.CGColor, c4.CGColor, nil];
    
    NSNumber *l1 = [NSNumber numberWithFloat:0.0];
    NSNumber *l2 = [NSNumber numberWithFloat:0.1];
    NSNumber *l3 = [NSNumber numberWithFloat:0.6];
    NSNumber *l4 = [NSNumber numberWithFloat:0.8];
    NSArray *l = [NSArray arrayWithObjects:l1, l2, l3, l4, nil];

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

- (CGFloat)widthOfVariedAttributedLabel:(UILabel*)label dividerIndex:(int)div {
    if (label.text.length <= div) {
        // Label likely has no content
        return 0;
    }
    CGSize s1 = [[label.text substringWithRange:NSMakeRange(0, div)] sizeWithAttributes:[label.attributedText attributesAtIndex:0 effectiveRange:NULL]];
    CGSize s2 = [[label.text substringWithRange:NSMakeRange(div, label.text.length-div)] sizeWithAttributes:[label.attributedText attributesAtIndex:div effectiveRange:NULL]];
    return s1.width + s2.width;
}

- (void)layoutSubviews {
    _topBar.frame = CGRectMake(0, 0, self.bounds.size.width, 50);
    [_topBar.layer.sublayers.firstObject setFrame:_topBar.bounds];

    _bottomBar.frame = CGRectMake(0, self.bounds.size.height - 50, self.bounds.size.width, 50);
    [_bottomBar.layer.sublayers.firstObject setFrame:_bottomBar.bounds];

    _mapButton.frame = CGRectMake(self.bounds.size.width - 40.0 - PN_PHOTO_AUX_DATA_EDGE_PADDING,
                                  PN_PHOTO_AUX_DATA_EDGE_PADDING,
                                  40, 35.0);
    _timeLabel.frame = CGRectMake(CGRectGetMinX(_mapButton.frame) - 100.0 - PN_PHOTO_AUX_DATA_EDGE_PADDING,
                                  CGRectGetMinY(_mapButton.frame) + 2.0,
                                  100, 15.0);
    _dateLabel.frame = CGRectMake(CGRectGetMinX(_timeLabel.frame),
                                  CGRectGetMaxY(_timeLabel.frame),
                                  100, 15.0);
    
    CGFloat apertureW = [self widthOfVariedAttributedLabel:_apertureLabel dividerIndex:2];
    CGFloat isoW = [self widthOfVariedAttributedLabel:_isoLabel dividerIndex:4];
    CGFloat shutterSpeedW = [self widthOfVariedAttributedLabel:_shutterSpeedLabel dividerIndex:_shutterSpeedLabel.text.length-1];
    CGFloat focalLengthW = [self widthOfVariedAttributedLabel:_focalLengthLabel dividerIndex:_focalLengthLabel.text.length-2];
    CGFloat bottomLabelY = _bottomBar.bounds.size.height - 25.0 - PN_PHOTO_AUX_DATA_EDGE_PADDING;
    int numNonZero = (apertureW ? 1 : 0) + (isoW ? 1 : 0) + (shutterSpeedW ? 1 : 0) + (focalLengthW ? 1 : 0);
    CGFloat bottomLabelSpacing = (self.bounds.size.width - PN_PHOTO_AUX_DATA_EDGE_PADDING*2 - apertureW - isoW - shutterSpeedW - focalLengthW)/(numNonZero - 1);
    
    _apertureLabel.frame = CGRectMake(PN_PHOTO_AUX_DATA_EDGE_PADDING,
                                      bottomLabelY, apertureW, 25.0);
    _isoLabel.frame = CGRectMake(PN_PHOTO_AUX_DATA_EDGE_PADDING + apertureW + (apertureW ? bottomLabelSpacing : 0),
                                 bottomLabelY, isoW, 25.0);
    _shutterSpeedLabel.frame = CGRectMake(PN_PHOTO_AUX_DATA_EDGE_PADDING + apertureW + isoW + (apertureW ? bottomLabelSpacing : 0) + (isoW ? bottomLabelSpacing : 0),
                                          bottomLabelY, shutterSpeedW, 25.0);
    _focalLengthLabel.frame = CGRectMake(PN_PHOTO_AUX_DATA_EDGE_PADDING + apertureW + isoW + shutterSpeedW + + (apertureW ? bottomLabelSpacing : 0) + (isoW ? bottomLabelSpacing : 0) + (shutterSpeedW ? bottomLabelSpacing : 0),
                                         bottomLabelY, focalLengthW, 25.0);
}

- (void)updateFromPhoto:(PNPhoto*)photo {
    [self setISO:photo.iso];
    [self setAperture:photo.aperture];
    [self setShutterSpeed:photo.shutterSpeed];
    [self setFocalLength:photo.focalLength];
    [self setDate:photo.takenAt];
    [self setTime:photo.takenAt];
    
    _bottomBar.hidden = !photo.aperture && !photo.shutterSpeed && !photo.focalLength && !photo.iso;
    
    [self layoutSubviews];
}

- (void)setISO:(NSString*)iso {
    if (iso == nil) {
        _isoLabel.text = nil;
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"ISO %@", iso];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont smallFont], NSFontAttributeName,
                         [UIColor whiteColor], NSForegroundColorAttributeName,
                         nil]
                  range:NSMakeRange(0, 4)];
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont smallBoldFont], NSFontAttributeName,
                         [UIColor whiteColor], NSForegroundColorAttributeName,
                         nil]
                  range:NSMakeRange(4, string.length-4)];
    
    _isoLabel.attributedText = text;
}

- (void)setAperture:(NSString*)aperture {
    if (aperture == nil) {
        _apertureLabel.text = nil;
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"f/%@", aperture];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                           [UIFont smallFont], NSFontAttributeName,
                           [UIColor whiteColor], NSForegroundColorAttributeName,
                           nil]
                    range:NSMakeRange(0, 2)];
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                           [UIFont smallBoldFont], NSFontAttributeName,
                           [UIColor whiteColor], NSForegroundColorAttributeName,
                           nil]
                    range:NSMakeRange(2, string.length-2)];
    
    _apertureLabel.attributedText = text;
}

- (void)setShutterSpeed:(NSString*)shutterSpeed {
    if (shutterSpeed == nil) {
        _shutterSpeedLabel.text = nil;
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@s", shutterSpeed];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont smallBoldFont], NSFontAttributeName,
                         [UIColor whiteColor], NSForegroundColorAttributeName,
                         nil]
                  range:NSMakeRange(0, string.length-1)];
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont smallFont], NSFontAttributeName,
                         [UIColor whiteColor], NSForegroundColorAttributeName,
                         nil]
                  range:NSMakeRange(string.length-1, 1)];
    
    _shutterSpeedLabel.attributedText = text;
}

- (void)setFocalLength:(NSString*)focalLength {
    if (focalLength == nil) {
        _focalLengthLabel.text = nil;
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@mm", focalLength];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];

    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont smallBoldFont], NSFontAttributeName,
                             [UIColor whiteColor], NSForegroundColorAttributeName,
                             nil]
                      range:NSMakeRange(0, string.length - 2)];
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont smallFont], NSFontAttributeName,
                             [UIColor whiteColor], NSForegroundColorAttributeName,
                             nil]
                      range:NSMakeRange(string.length - 2, 2)];

    _focalLengthLabel.attributedText = text;
}

- (void)setDate:(NSDate*)date {
    if (date == nil) {
        _dateLabel.text = nil;
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
    if (time == nil) {
        _timeLabel.text = nil;
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
