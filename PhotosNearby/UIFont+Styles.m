//
//  UIFont+Styles.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/30/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "UIFont+Styles.h"

@implementation UIFont (Styles)

+ (UIFont*)largeDemiBoldFont {
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0f];
}

+ (UIFont*)largeFont {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:19.0f];
}

+ (UIFont*)smallBoldFont {
    return [UIFont fontWithName:@"AvenirNext-Bold" size:14.0f];
}

+ (UIFont*)smallFont {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
}

+ (UIFont*)xSmallFont {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:11.0f];
}

@end
