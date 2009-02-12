//
//  FirstViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import "EveryoneViewController.h"
#import "ShoutManager.h"
#import "ShoutsDataSource.h"
#import <RMMarkerManager.h>
#import <RMMarkerStyle.h>

#define MAP_LAT_INITIAL     45.515963
#define MAP_LON_INITIAL   -122.656525
#define MAP_SCALE_INITIAL    3.0

@implementation EveryoneViewController

@synthesize spinnerView;
@synthesize tableView;
@synthesize mapButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[[self parentViewController] navigationItem] setLeftBarButtonItem:mapButton animated:NO];
    [[[self parentViewController] navigationItem] setLeftBarButtonItem:mapButton animated:NO];
    viewIsMap = NO;
    
    // Set up data source
    ShoutManager *shoutManager = [ShoutManager alloc];
    ShoutsDataSource *shoutsDataSource = [ShoutsDataSource initWithManager:shoutManager controller:self];
    
    // Set up list view
    nonMapView = [[self view] retain];
    [tableView setDataSource:shoutsDataSource];
    [tableView setDelegate:shoutsDataSource];
    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    // Set up map view
    mapView = [[RMMapView alloc] initWithFrame:[[self view] frame]];
    CLLocation *location = [[CLLocation alloc] initWithLatitude: MAP_LAT_INITIAL longitude:MAP_LON_INITIAL];
    RMMapContents *mapContents = [mapView contents];
    [mapContents setMapCenter:location.coordinate];
    [mapContents setScale:MAP_SCALE_INITIAL];
    [mapContents setZoomBounds:0.5 maxZoom:125000];
    [mapView setDelegate:self];
    
    // Start data retrieval
    [shoutManager findShouts];
}

- (void) dataLoaded:(NSArray *)shouts {
    // Update list view table
    [tableView setHidden:NO];
    [tableView reloadData];
    // Update map view markers
    [self updateMarkersWithShouts:shouts];
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
                //[label setBackgroundColor:[UIColor lightGrayColor]];
                //[label setNumberOfLines:2];
                CGRect frame = [label frame];
                //frame.size.height *= 2;
                [label setFrame:frame];
                [label setTextAlignment:UITextAlignmentCenter];
                [label setFont:[UIFont systemFontOfSize:14]];
                [label setAlpha:0.25];
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
    //    NSLog(@"EveryoneViewController mapButtonPressed");
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[self view] setAutoresizesSubviews:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end
