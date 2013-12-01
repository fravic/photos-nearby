//
//  PNMapViewController.h
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/30/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPhoto.h"

@protocol PNMapViewControllerDelegate
- (void)mapViewControllerDidSelectBack;
@end

@interface PNMapViewController : UIViewController

- (void)animateInitialPhotoPosition:(CGRect)rect;
- (void)setPhoto:(PNPhoto*)photo;
- (void)setDelegate:(id<PNMapViewControllerDelegate>)delegate;

@end
