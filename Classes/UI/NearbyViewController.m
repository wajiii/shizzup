//
//  NearbyViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import "NearbyViewController.h"

#import <RMMarkerManager.h>
#import <RMMarkerStyle.h>
#import "LocationManager.h"
#import "NearbyDataSource.h"
#import "ShizzupConstants.h"
#import "ShoutManager.h"

@implementation NearbyViewController

@synthesize refreshImage;
@synthesize spinnerView;

- (void) viewDidLoad {
    [super viewDidLoad];

    // Set up data source
    shoutManager = [[ShoutManager alloc] init];
    nearbyDataSource = [NearbyDataSource initWithManager:shoutManager controller:self];

    // Set up map view
    NSLog(@"Setting up map view...");
    mapView = [self view];
    RMMapContents *mapContents = [mapView contents];
    CLLocation *location = [LocationManager location];
    NSLog(@"Setting location: %f, %f", location.coordinate.latitude, location.coordinate.longitude);
    [mapContents setMapCenter:location.coordinate];
    [mapContents setScale: MAP_SCALE_INITIAL];
    [mapContents setZoomBounds:0.5 maxZoom:125000];
    [mapView setDelegate:self];
    [self setView:mapView];

    // Start data retrieval
    NSLog(@"Starting shout retrieval...");
    [shoutManager findShoutsForLocation:[LocationManager location]];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"NearbyViewController viewWillAppear");
    [super viewWillAppear:animated];
    NSLog(@"   - NearbyViewController setting location manager delegate: %@", self);
    [LocationManager setDelegate:self];
    NSLog(@"   - NearbyViewController starting location updates...");
    [LocationManager startUpdating];

    // Start data retrieval
    NSLog(@"Starting shout retrieval...");
    [spinnerView startAnimating];
    [shoutManager findShoutsForLocation:[LocationManager location]];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"NearbyViewController stopping location updates...");
    [LocationManager stopUpdating];
    [super viewWillDisappear:animated];
}

- (void) dataLoaded:(NSArray *)shouts {
    NSLog(@"NearbyViewController dataLoaded:");
    @synchronized(self) {
        // Update map view markers
        NSUInteger shoutCount = [self updateMarkersWithShouts: shouts];
        NSString *shoutCountS = [NSString stringWithFormat:@"%u", shoutCount];
        [[self tabBarItem] setBadgeValue:shoutCountS];
        [spinnerView stopAnimating];
    }
}

/*
 Derived from code posted by Nathan Vander Wilt:
 http://www.cocoabuilder.com/archive/message/cocoa/2008/3/18/201578
 */
- (NSDate *) dateFromISO8601:(NSString *) str {
    static NSDateFormatter* sISO8601 = nil;
    if (!sISO8601) {
        sISO8601 = [[NSDateFormatter alloc] init];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];    // NOTE: problem!
    }
    if ([str hasSuffix:@"Z"]) {
        str = [[str substringToIndex:(str.length-1)] stringByAppendingString:@"GMT"];
    }
    return [sISO8601 dateFromString:str];
}

- (NSUInteger) updateMarkersWithShouts:(NSArray *)shouts {
    NSLog(@"NearbyViewController updateMarkersWithShouts:");
    NSUInteger shoutCount = 0;
    if (shouts != nil) {
        shoutCount = [shouts count];
    }
    @synchronized(self) {
        RMMarkerManager *manager = [mapView markerManager];
        [manager removeMarkers];
        NSMutableSet *people = [[NSMutableSet alloc] init];
        NSDate *now = [NSDate date];
        for (Shout *shout in shouts) {
            if ([people containsObject:[shout username]]) {
                NSLog(@"Already have a marker for user %@, discarding shout %@.", [shout username], [shout modified]);
                shoutCount--;
            } else {
                [people addObject:[shout username]];
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
                float markerOpacity = 1;
                //float shoutAgeWeight = [shout
                NSLog(@"   - shout.username: %@; shout.modified: %@", [shout username], [shout modified]);
                //NSCalendarDate calModified = [NSCalendarDate calendarDateWithString:[shout modified]];
                NSDate *dateModified = [self dateFromISO8601:[shout modified]];
                NSLog(@"   - modified as NSDate: %@", dateModified);
                NSTimeInterval timeInterval = [now timeIntervalSinceDate:dateModified];
                if (timeInterval > 3600) {
                    if (timeInterval > (60*60*8)) {
                        markerOpacity = 0.5;
                    } else {
                        NSTimeInterval base = (timeInterval - 3600);
                        NSLog(@"   - base: %f", base);
                        NSTimeInterval diff = (60*60*8) - base;
                        NSLog(@"   - diff: %f", diff);
                        diff /= (60*60*8);
                        NSLog(@"   - diff: %f", diff);
                        diff *= 0.25;
                        NSLog(@"   - diff: %f", diff);
                        diff += 0.75;
                        NSLog(@"   - diff: %f", diff);
                        markerOpacity = diff;
                    }
                }
                [marker setOpacity:markerOpacity];
                [manager addMarker:marker AtLatLong:location.coordinate];
            }
        }
    }
    return shoutCount;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"NearbyViewController received new location: %@", newLocation);
    @synchronized(self) {
        newLocation = [LocationManager location];
        NSLog(@"NearbyViewController updating with location: %@", newLocation);
        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        [[mapView contents] setMapCenter:coordinate];

        NSLog(@"Starting shout retrieval...");
        // Start data retrieval
        [spinnerView startAnimating];
        [shoutManager findShoutsForLocation:[LocationManager location]];
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
    [spinnerView startAnimating];
    [shoutManager findShoutsForLocation:[LocationManager location]];
}

@end
