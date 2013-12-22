//
//  PNPhotoListView.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNPhotoListView.h"

@implementation PNPhotoListView

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor pnDarkGrayColor];
        self.separatorColor = [UIColor clearColor];
    }
    return self;
}

@end
