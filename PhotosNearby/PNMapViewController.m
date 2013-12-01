//
//  PNMapViewController.m
//  PhotosNearby
//
//  Created by Fravic Fernando on 11/30/13.
//  Copyright (c) 2013 Fravic Fernando. All rights reserved.
//

#import "PNMapViewController.h"
#import "PNPhotoAuxDataView.h"
#import <MapKit/MapKit.h>

#define PN_MAP_VIEW_CONTROLLER_IMAGE_HEIGHT 110

@implementation PNMapViewController {
    UIButton *_backButton;
    UIImageView *_imageView;
    UIView *_imageViewOverlay;
    MKMapView *_mapView;
    UIImageView *_backIndicator;
    PNPhotoAuxDataView *_auxDataView;
    id<PNMapViewControllerDelegate> _delegate;
    
    CGRect _imageInitialPos;
}

- (id)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];

        _imageView = [[UIImageView alloc] init];
        [self.view addSubview:_imageView];
        
        _mapView = [[MKMapView alloc] init];
        [self.view addSubview:_mapView];
        
        _imageViewOverlay = [[UIView alloc] init];
        _imageViewOverlay.backgroundColor = [UIColor blackColor];
        _imageViewOverlay.alpha = 0.0f;
        [_imageView addSubview:_imageViewOverlay];
        
        _auxDataView = [[PNPhotoAuxDataView alloc] init];
        _auxDataView.alpha = 0.0f;
        _auxDataView.mapButton.hidden = YES;
        [_auxDataView setGradientsHidden:YES];
        [_imageView addSubview:_auxDataView];
        
        _backIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"assets/icon_back.png"]];
        [_auxDataView addSubview:_backIndicator];
        
        _backButton = [[UIButton alloc] init];
        _backButton.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backButton];
    }
    return self;
}

- (void)setDelegate:(id<PNMapViewControllerDelegate>)delegate {
    _delegate = delegate;
    [_backButton addTarget:self action:@selector(animateOut) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setPhoto:(PNPhoto *)photo {
    [_imageView setImage:photo.image];
    [_auxDataView updateFromPhoto:photo];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(photo.lat, photo.lng);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.035f, 0.035f);
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
    [_mapView setRegion:region animated:NO];
    _mapView.showsUserLocation = YES;
    
    MKPointAnnotation *annote = [[MKPointAnnotation alloc] init];
    [annote setCoordinate:coord];
    [annote setTitle:@"Approximate Location"];
    [_mapView addAnnotation:annote];
}

- (void)animateInitialPhotoPosition:(CGRect)rect {
    _imageInitialPos = rect;

    CGRect topRect = CGRectMake(0, -rect.size.height + PN_MAP_VIEW_CONTROLLER_IMAGE_HEIGHT, self.view.bounds.size.width, rect.size.height);
    _imageView.frame = rect;
    
    _imageViewOverlay.frame = CGRectMake(0, 0, topRect.size.width, topRect.size.height);
    _auxDataView.frame = CGRectMake(0, topRect.size.height-PN_MAP_VIEW_CONTROLLER_IMAGE_HEIGHT+22, self.view.bounds.size.width, PN_MAP_VIEW_CONTROLLER_IMAGE_HEIGHT-22);
    _backButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, PN_MAP_VIEW_CONTROLLER_IMAGE_HEIGHT);
    _backIndicator.frame = CGRectMake(8.0f, 8.0f, 15.0, 25.5);
    
    CGRect mapFrame = CGRectMake(0, PN_MAP_VIEW_CONTROLLER_IMAGE_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height-PN_MAP_VIEW_CONTROLLER_IMAGE_HEIGHT);
    _mapView.frame = CGRectMake(0, self.view.bounds.size.height, mapFrame.size.width, mapFrame.size.height);

    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _imageView.frame = topRect;
                         _imageViewOverlay.alpha = 0.7f;
                         _auxDataView.alpha = 1.0f;
                         _mapView.frame = mapFrame;
                     }
                     completion:^(BOOL finished){
                     }
    ];
}

- (void)animateOut {
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _imageView.frame = _imageInitialPos;
                         _imageViewOverlay.alpha = 0.0f;
                         _auxDataView.alpha = 0.0f;
                         _mapView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                         [_delegate mapViewControllerDidSelectBack];
                     }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
