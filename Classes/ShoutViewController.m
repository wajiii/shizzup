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
#import "ShizzowConstants.h"
#import "LocationManager.h"


@implementation ShoutViewController


@synthesize locationLabel;
@synthesize spinnerView;
@synthesize tableView;
@synthesize mapView;

- (void) viewDidLoad {
    [super viewDidLoad];
    placeManager = [[PlaceManager alloc] init];
    PlacesDataSource *placesDataSource = [PlacesDataSource initWithManager:placeManager controller:self];
    [placeManager setDelegate:placesDataSource];
    [tableView setDataSource:placesDataSource];
    [tableView setDelegate:placesDataSource];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"ShoutViewController starting location updates...");
    [LocationManager setDelegate:self];
    [LocationManager startUpdating];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"ShoutViewController stopping location updates...");
    [LocationManager stopUpdating];
    [super viewWillDisappear:animated];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    @synchronized(self) {
        newLocation = [LocationManager location];
        NSLog(@"New location: %@", newLocation);
        // If we are in the simulator, override with MAP_*_INITIAL values; One Infinite Loop is of no use to us!
//#if (TARGET_IPHONE_SIMULATOR)
//        newLocation = [[CLLocation alloc] initWithLatitude:MAP_LAT_INITIAL longitude:MAP_LON_INITIAL];
//#endif
        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        NSString *locationText = [NSString stringWithFormat:@"%1.6f°, %1.6f°", coordinate.latitude, coordinate.longitude];
        if (newLocation.horizontalAccuracy != 0) {
            locationText = [locationText stringByAppendingFormat:@" (±%1.0fm)", newLocation.horizontalAccuracy];
        }
        locationLabel.text = locationText;
        placeManager.center = newLocation;
        [placeManager findPlaces];
        // For exception handler testing only!
        //@throw [NSException exceptionWithName:@"WhoopsieGoldberg" reason:@"Whoopsie Daisy!" userInfo:nil];
    }
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

- (IBAction) exitShoutView {
    NSLog(@"MainTabBarController exitShoutView");
    [(UINavigationController *)[self parentViewController] popViewControllerAnimated:YES];
}


@end
