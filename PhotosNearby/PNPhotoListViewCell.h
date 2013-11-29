//
//  PNPhotoView.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/28/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNPhotoListViewCell : UITableViewCell
    
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSDate *takenAt;
@property (nonatomic, retain) NSString *shutter;
@property (nonatomic, retain) NSString *aperture;
@property (nonatomic, retain) NSString *iso;
@property (nonatomic) float lat;
@property (nonatomic) float lng;

@end
