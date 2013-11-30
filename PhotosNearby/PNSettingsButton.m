//
//  PNSettingsButton.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/30/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNSettingsButton.h"

@implementation PNSettingsButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgImage = [UIImage imageNamed:@"assets/bottom_left_button.png"];
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
        
        [self setImage:[UIImage imageNamed:@"assets/icon_radius.png"] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageEdgeInsets = UIEdgeInsetsMake(5, -3, 5, 2);
        self.titleEdgeInsets = UIEdgeInsetsMake(4, -3, 2, 5);
    }
    return self;
}

- (void)setRadius:(float)radius {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1fmi", radius]];
    [attrStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont largeDemiBoldFont], NSFontAttributeName, nil] range:NSMakeRange(0, 3)];
    [attrStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UIColor whiteColor] colorWithAlphaComponent:0.5f], NSForegroundColorAttributeName, [UIFont largeFont], NSFontAttributeName, nil] range:NSMakeRange(3, 2)];
    [self setAttributedTitle:attrStr forState:UIControlStateNormal];
}

@end
