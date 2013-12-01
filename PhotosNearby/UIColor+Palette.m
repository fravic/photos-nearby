//
//  UIColor+Palette.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/29/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "UIColor+Palette.h"

@implementation UIColor (Palette)

+ (UIColor*)pnDarkGrayColor {
    return [UIColor colorWithRed:(40.0/255.0) green:(45.0/255.0) blue:(55.0/255.0) alpha:1.0f];
}

+ (UIColor*)pnDarkGrayAlphaColor {
    return [[UIColor pnDarkGrayColor] colorWithAlphaComponent:0.7f];
}

+ (UIColor*)whiteAlphaColor {
    return [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
}

@end
