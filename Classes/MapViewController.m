//
//  MapViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/10.
//  Copyright 2009 waj3. All rights reserved.
//

#import "MapViewController.h"

#define MAP_LAT_INITIAL     45.515963
#define MAP_LON_INITIAL   -122.656525
#define MAP_SCALE_INITIAL    3.0

@implementation MapViewController

@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:MAP_LAT_INITIAL longitude:MAP_LON_INITIAL];
    RMMapContents *mapContents = [[self mapView] contents];
    [mapContents setMapCenter:location.coordinate];
    [mapContents setScale:MAP_SCALE_INITIAL];
    [mapContents setZoomBounds:0.5 maxZoom:125000];
    [mapView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end
