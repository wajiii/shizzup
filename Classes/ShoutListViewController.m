//
//  FirstViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import "ShoutListViewController.h"
#import "ShoutManager.h"
#import "ShoutsDataSource.h"
#import "ShizzowConstants.h"
#import <RMMarkerManager.h>
#import <RMMarkerStyle.h>
#import "LocationManager.h"

@implementation ShoutListViewController

@synthesize spinnerView;
@synthesize tableView;
@synthesize mapButton;

- (void) viewDidLoad {
    [super viewDidLoad];
    [[[self parentViewController] navigationItem] setLeftBarButtonItem:mapButton animated:NO];
    viewIsMap = NO;
    
    // Set up data source
    shoutManager = [ShoutManager alloc];
    ShoutsDataSource *shoutsDataSource = [ShoutsDataSource initWithManager:shoutManager controller:self];
    
    NSLog(@"Setting up list view...");
    // Set up list view
    nonMapView = [[self view] retain];
    [tableView setDataSource:shoutsDataSource];
    [tableView setDelegate:shoutsDataSource];
    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    NSLog(@"Setting up map view...");
    // Set up map view
    mapView = [[RMMapView alloc] initWithFrame:[[self view] frame]];
    RMMapContents *mapContents = [mapView contents];
    CLLocation *location = [LocationManager location];
    NSLog(@"Setting location: %f, %f", location.coordinate.latitude, location.coordinate.longitude);
    [mapContents setMapCenter:location.coordinate];
    [mapContents setScale:MAP_SCALE_INITIAL];
    [mapContents setZoomBounds:0.5 maxZoom:125000];
    [mapView setDelegate:self];
    
    NSLog(@"Starting shout retrieval...");
    // Start data retrieval
    [shoutManager findShouts];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"ShoutListViewController viewWillAppear");
    [super viewWillAppear:animated];
    NSLog(@"   - ShoutListViewController setting location manager delegate: %@", self);
    [LocationManager setDelegate:self];
    NSLog(@"   - ShoutListViewController starting location updates...");
    [LocationManager startUpdating];
    
    NSLog(@"Starting shout retrieval...");
    // Start data retrieval
    [shoutManager findShouts];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"ShoutListViewController stopping location updates...");
    [LocationManager stopUpdating];
    [super viewWillDisappear:animated];
}

- (void) dataLoaded:(NSArray *)shouts {
    // Update list view table
    [tableView setHidden:NO];
    [tableView reloadData];
    // Update map view markers
    [self updateMarkersWithShouts:shouts];
    NSUInteger shoutCount = 0;
    if (shouts != nil) {
        shoutCount = [shouts count];
    }
    NSString *shoutCountS = [NSString stringWithFormat:@"%u", shoutCount];
    [[self tabBarItem] setBadgeValue:shoutCountS];
    //[[self tabBarItem] setBadgeValue:[[shouts count] stringValue]];
    [spinnerView stopAnimating];
}

- (void) updateMarkersWithShouts:(NSArray *)shouts {
    RMMarkerManager *manager = [mapView markerManager];
    for (Shout *shout in shouts) {
        //Shout *shout = [[shouts objectEnumerator] nextObject];
        RMMarker *marker = [RMMarker alloc];
        [marker initWithNamedStyle:RMMarkerBlueKey];
        //[marker setTextLabel:[NSString stringWithFormat:@"%@\n%@", [shout username], [shout placeName]]];
        [marker setTextLabel:[NSString stringWithFormat:@"%@", [shout username]]];
        UIView *labelView = [marker labelView];
        //NSLog(@"marker labelView: %@", label);
        if (labelView != nil) {
            BOOL isLabel = [labelView isMemberOfClass:[UILabel class]];
            //NSLog(@"marker labelView isLabel: %d", isLabel);
            if (isLabel) {
                //NSLog(@"Alright!");
                UILabel *label = (UILabel *)labelView;
                //[label setShadowColor:[UIColor whiteColor]];
                //[label setNumberOfLines:2];
                //CGRect frame = [label frame];
                //frame.size.height *= 2;
                //[label setFrame:frame];
                [label setTextAlignment:UITextAlignmentCenter];
                [label setFont:[UIFont systemFontOfSize:14]];
                [label setAlpha:1.0];
                //[label setBackgroundColor:[UIColor lightGrayColor]];
                [label setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
            } else {
                NSLog(@"Whoops, marker labelView %@ is not a UILabel.  Oh well!", labelView);
            }
        }
        //[marker setOpacity:0.5];
        CLLocation *location = [CLLocation alloc];
        CLLocationDegrees lat = [[shout latitude] doubleValue];
        CLLocationDegrees lon = [[shout longitude] doubleValue];
        [location initWithLatitude:lat longitude:lon];
        //[location initWithLatitude:MAP_LAT_INITIAL longitude:MAP_LON_INITIAL];
        [manager addMarker:marker AtLatLong:location.coordinate];
    }
}

- (IBAction) mapButtonPressed {
    //    NSLog(@"ShoutListViewController mapButtonPressed");
    //    NSLog(@"   - viewIsMap: %d", viewIsMap);
    //    NSLog(@"   - mapButton.title: %@", [mapButton title]);
    if (viewIsMap) {
        [self setView:nonMapView];
        [mapButton setTitle:@"Map"];
        viewIsMap = NO;
    } else {
        [self setView:mapView];
        [mapButton setTitle:@"List"];
        viewIsMap = YES;
    }
    // Make sure the spinner comes along :)
    [[self view] addSubview:spinnerView];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"ShoutListViewController received new location: %@", newLocation);
    @synchronized(self) {
        newLocation = [LocationManager location];
        // If we are in the simulator, override with MAP_*_INITIAL values; One Infinite Loop is of no use to us!
//#if (TARGET_IPHONE_SIMULATOR)
//        newLocation = [[CLLocation alloc] initWithLatitude:MAP_LAT_INITIAL longitude:MAP_LON_INITIAL];
//#endif
        NSLog(@"ShoutListViewController updating with location: %@", newLocation);
        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        [[mapView contents] setMapCenter:coordinate];
        
        NSLog(@"Starting shout retrieval...");
        // Start data retrieval
        [shoutManager findShouts];
        //    NSString *locationText = [NSString stringWithFormat:@"%1.6f°, %1.6f°", coordinate.latitude, coordinate.longitude];
        //    if (newLocation.horizontalAccuracy != 0) {
        //        locationText = [locationText stringByAppendingFormat:@" (±%1.0fm)", newLocation.horizontalAccuracy];
        //    }
        //    locationLabel.text = locationText;
        //    altitudeLabel.text = [NSString stringWithFormat:@"%1.1fm (±%1.0fm)", newLocation.altitude, newLocation.verticalAccuracy];
        //    if (newLocation.altitude != 0) {
        //        [altitudeLabelLabel setHidden:NO];
        //        [altitudeLabel setHidden:NO];
        //    }
        //    placeManager.center = newLocation;
        //    [placeManager findPlaces];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[self view] setAutoresizesSubviews:YES];
    return YES;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) dealloc {
    [super dealloc];
}

@end
