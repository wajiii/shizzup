//
//  PlaceManager.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import "PlaceManager.h"

#import "LocationManager.h"
#import "Place.h"
#import "PlaceListReceiver.h"
#import "ShizzowApiConnection.h"
#import "ShizzupConstants.h"

@implementation PlaceManager

@synthesize center;
@synthesize delegate;

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
    [center release];
    [delegate release];
    [super dealloc];
}

- (id) init {
    [super init];
    //center = [[CLLocation alloc] initWithLatitude:MAP_LAT_INITIAL longitude:MAP_LON_INITIAL];
    center = [LocationManager location];
    return self;
}

- (void) findPlaces {
    NSLog(@"PlaceManager findPlaces");
    // Clean up any outstanding requests.
    if (receiver != nil) {
        NSLog(@"  - discarding old receiver");
        [receiver setDelegate:nil];
        receiver = nil;
    }
    if (api != nil) {
        NSLog(@"  - discarding old API connection");
        [api abort];
        [api release];
        api = nil;
    }

    // Create a new receiver, set delegate
    receiver = [[[PlaceListReceiver alloc] init] retain];
    [receiver setDelegate:delegate];
    [receiver setManager:self];

    // Create a new API connection, send request
    NSString *apiUriStub = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&radius=%f&radiusUnit=%@&limit=%d", SHIZZOW_API_PATH_PLACES, center.coordinate.latitude, center.coordinate.longitude, SHIZZOW_API_PLACES_RADIUS_DEFAULT, SHIZZOW_API_PLACES_RADIUSUNIT_DEFAULT, SHIZZOW_API_PLACES_LIMIT_DEFAULT ];
    //NSLog(@"   - apiUriStub: %@", apiUriStub);
    api = [[[ShizzowApiConnection alloc] init] retain];
    [receiver setApi:api];
    [api callUri:apiUriStub delegate:receiver];
}


@end
