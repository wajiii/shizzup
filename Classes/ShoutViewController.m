//
//  ShoutViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PlaceManager.h"
#import "PlacesDataSource.h"

@implementation ShoutViewController

@synthesize altitudeLabel;
@synthesize altitudeLabelLabel;
@synthesize locationLabel;
@synthesize spinnerView;
@synthesize tableView;
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    placeManager = [[PlaceManager alloc] init];
    PlacesDataSource *placesDataSource = [PlacesDataSource initWithManager:placeManager controller:self];
    [placeManager setDelegate:placesDataSource];
    [tableView setDataSource:placesDataSource];
    [tableView setDelegate:placesDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Starting location updates...");
    [locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"Stopping location updates...");
    [locationManager stopUpdatingLocation];
    [super viewDidDisappear:animated];
}

// At this point, our view orientation is set to the new orientation.
//- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
//    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"New location: %@", newLocation);
    newLocation = [[CLLocation alloc] initWithLatitude:45.515963 longitude:-122.656525];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    NSString *locationText = [NSString stringWithFormat:@"%1.6f°, %1.6f°", coordinate.latitude, coordinate.longitude];
    if (newLocation.horizontalAccuracy != 0) {
        locationText = [locationText stringByAppendingFormat:@" (±%1.0fm)", newLocation.horizontalAccuracy];
    }
    locationLabel.text = locationText;
    altitudeLabel.text = [NSString stringWithFormat:@"%1.1fm (±%1.0fm)", newLocation.altitude, newLocation.verticalAccuracy];
    if (newLocation.altitude != 0) {
        [altitudeLabelLabel setHidden:NO];
        [altitudeLabel setHidden:NO];
    }
    placeManager.center = newLocation;
    [placeManager findPlaces];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
    [super dealloc];
}

- (void) dataLoaded {
    NSLog(@"ShoutViewController dataLoaded");
    [spinnerView stopAnimating];
    [tableView setHidden:NO];
    [tableView reloadData];
}

@end
