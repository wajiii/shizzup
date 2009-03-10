//
//  ListeningViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import "ListeningViewController.h"
#import "ShoutManager.h"
#import "ListeningDataSource.h"
#import "ShizzupConstants.h"
#import <RMMarkerManager.h>
#import <RMMarkerStyle.h>
#import "LocationManager.h"

@implementation ListeningViewController

@synthesize refreshButtonCell;
@synthesize spinnerView;
@synthesize tableView;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Set up data source
    shoutManager = [ShoutManager alloc];
    ListeningDataSource *shoutsDataSource = [ListeningDataSource initWithManager:shoutManager controller:self];
    
    NSLog(@"Setting up list view...");
    // Set up list view
    //    nonMapView = [[self view] retain];
    [tableView setDataSource:shoutsDataSource];
    [tableView setDelegate:shoutsDataSource];
    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    NSLog(@"Starting shout retrieval...");
    // Start data retrieval
    [shoutManager setWho:@"listening"];
    [shoutManager findShouts];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"ListeningViewController viewWillAppear");
    [super viewWillAppear:animated];
    NSLog(@"   - ListeningViewController setting location manager delegate: %@", self);
    [LocationManager setDelegate:self];
    NSLog(@"   - ListeningViewController starting location updates...");
    [LocationManager startUpdating];
    
    NSLog(@"Starting shout retrieval...");
    // Start data retrieval
    [shoutManager findShouts];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"ListeningViewController stopping location updates...");
    [LocationManager stopUpdating];
    [super viewWillDisappear:animated];
}

- (void) dataLoaded:(NSArray *)shouts {
    NSLog(@"ListeningViewController dataLoaded:");
    // Update list view table
    [tableView setHidden:NO];
    [tableView reloadData];
    // Update tab bar item badge
    NSUInteger shoutCount = 0;
    if (shouts != nil) {
        shoutCount = [shouts count];
    }
    NSString *shoutCountS = [NSString stringWithFormat:@"%u", shoutCount];
    [[self tabBarItem] setBadgeValue:shoutCountS];
    // Scroll to first shout
    if ([shouts count] > 0) {
        NSUInteger indexes[2] = { 0, 1 };
        NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    [spinnerView stopAnimating];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"ListeningViewController received new location: %@", newLocation);
    @synchronized(self) {
        newLocation = [LocationManager location];
        NSLog(@"ListeningViewController updating with location: %@", newLocation);
        //        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        //        [[mapView contents] setMapCenter:coordinate];
        
        NSLog(@"Starting shout retrieval...");
        // Start data retrieval
        [shoutManager findShouts];
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

- (IBAction) refreshShoutList {
    [shoutManager findShouts];
}

@end
