//
//  ShoutPlaceController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutPlaceController.h"

#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"
#import "Place.h"
#import "PlaceManager.h"
#import "PlacesDataSource.h"
#import "ShizzupAppDelegate.h"
#import "ShizzupConstants.h"
#import "ShoutMessageController.h"

@implementation ShoutPlaceController

@synthesize locationLabel;
@synthesize spinnerView;
@synthesize tableView;
@synthesize mapView;

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
    [locationLabel release];
    [spinnerView release];
    [tableView release];
    [mapView release];
    [super dealloc];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    placeManager = [[[PlaceManager alloc] init] retain];
    PlacesDataSource *placesDataSource = [PlacesDataSource initWithManager:placeManager controller:self];
    [placeManager setDelegate:placesDataSource];
    [tableView setDataSource:placesDataSource];
    [tableView setDelegate:placesDataSource];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"ShoutPlaceController starting location updates...");
    [LocationManager setDelegate:self];
    [LocationManager startUpdating];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"ShoutPlaceController stopping location updates...");
    [LocationManager stopUpdating];
    [super viewWillDisappear:animated];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"ShoutPlaceController locationManager: didUpdateToLocation: fromLocation:");
    //NSLog(@"  - oldLocation: %@", oldLocation);
    //NSLog(@"  - newLocation: %@", newLocation);
    @synchronized(self) {
        if (nextLocation != nil) {
            [nextLocation release];
            nextLocation = nil;
        }
        nextLocation = [newLocation retain];
        [self updateLocation];
    }
}

- (void) updateLocation {
    NSLog(@"ShoutPlaceController updateLocation");
    NSLog(@"  - thread: %@", [NSThread currentThread]);
    @synchronized(self) {
        if (updating) {
            NSLog(@"  - another update is active, rescheduling...");
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLocation) userInfo:nil repeats:NO];
        } else {
            NSLog(@"  - done waiting.");
            updating = YES;
            [spinnerView startAnimating];
            NSLog(@"   - new location: %@", nextLocation);
            if (nextLocation == nil) {
                nextLocation = [LocationManager location];
                NSLog(@"   - new location (retrieved directly): %@", nextLocation);
            }
            CLLocationCoordinate2D coordinate = nextLocation.coordinate;
            NSString *locationText = [NSString stringWithFormat:@"%1.6f°, %1.6f°", coordinate.latitude, coordinate.longitude];
            if (nextLocation.horizontalAccuracy != 0) {
                locationText = [locationText stringByAppendingFormat:@" (±%1.0fm)", nextLocation.horizontalAccuracy];
            }
            locationLabel.text = locationText;
            placeManager.center = nextLocation;
            [placeManager findPlaces];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) dataLoaded {
    NSLog(@"ShoutPlaceController dataLoaded (initial) - thread %@", [NSThread currentThread]);
    @synchronized(self) {
        NSLog(@"ShoutPlaceController dataLoaded (synchronized) - thread %@", [NSThread currentThread]);
        NSLog(@"  - thread: %@", [NSThread currentThread]);
        NSLog(@"  - loading new data");
        [tableView setHidden:NO];
        [tableView reloadData];
        [spinnerView stopAnimating];
        updating = NO;
    }
}

- (void) userSelectedPlace:(Place *)place {
    NSLog(@"ShoutPlaceController userSelectedPlace: %@", place);
    ShoutMessageController *shoutMessageController = [[ShoutMessageController alloc] initWithNibName:@"ShoutMessage" bundle:nil];
    //NSLog(@"   - shoutMessageController: %@", shoutMessageController);
    [shoutMessageController setPlace:place];
    //[[[ShizzupAppDelegate singleton] navController] pushViewController:shoutMessageController animated:YES];
    [(UINavigationController *)[self parentViewController] pushViewController:shoutMessageController animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [shoutMessageController release];
}

- (IBAction) exitShoutView {
    NSLog(@"ShoutPlaceController exitShoutView");
    [[ShizzupAppDelegate singleton] exitCurrentView];
}

- (IBAction) refreshLocation {
    NSLog(@"ShoutPlaceController refreshLocation");
    [LocationManager stopUpdating];
    [LocationManager startUpdating];
}

@end
