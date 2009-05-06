//
//  LocationManager.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/24.
//  Copyright 2009 waj3. All rights reserved.
//

#import "LocationManager.h"
#import "ShizzupConstants.h"

@implementation LocationManager

LocationManager *singleton;
CLLocationManager *wrapped;
CLLocation *defaultLocation;
id<CLLocationManagerDelegate> delegate;

void ensureInit() {
    @synchronized([LocationManager class]) {
        if (wrapped == nil) {
            wrapped = [[CLLocationManager alloc] init];
            singleton = [[LocationManager alloc] init];
            CLLocationDegrees defaultLatitude = MAP_LAT_INITIAL;
            //NSLog(@"MAP_LAT_INITIAL: %f", MAP_LAT_INITIAL);
            //float latJiggle = (arc4random() % 100000);
            //NSLog(@"latJiggle.1: %f", latJiggle);
            //latJiggle -= 50000;
            //NSLog(@"latJiggle.2: %f", latJiggle);
            //latJiggle /= 1000000;
            //NSLog(@"latJiggle.3: %f", latJiggle);
            //defaultLatitude += latJiggle;
            NSLog(@"defaultLatitude: %f", defaultLatitude);
            defaultLocation = [[CLLocation alloc] initWithLatitude:defaultLatitude longitude:MAP_LON_INITIAL];
            //[wrapped setLocation:defaultLocation];
            [wrapped setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
            [wrapped setDelegate:singleton];
        }
    }
}

+ (void) setDelegate:(id<CLLocationManagerDelegate>) newDelegate {
    ensureInit();
    delegate = newDelegate;
}

+ (void) startUpdating {
    ensureInit();
    [wrapped startUpdatingLocation];
}

+ (void) stopUpdating {
    ensureInit();
    [wrapped stopUpdatingLocation];
}

+ (CLLocation *) defaultLocation {
    return defaultLocation;
}

+ (CLLocation *) location {
    NSLog(@"********** LocationManager location **********");
    ensureInit();
    if (![wrapped locationServicesEnabled]) {
        NSLog(@"  - location services are disabled, returning default location.");
        return defaultLocation;
    }
#if (TARGET_IPHONE_SIMULATOR)
    NSLog(@"  - TARGET_IPHONE_SIMULATOR is set, returning default location.");
    return defaultLocation;
#endif
    CLLocation *loc = [wrapped location];
    if (loc == nil) {
        //NSLog(@"  - loc is nil, returning default location.");
        //loc = defaultLocation;
        //NSLog(@"  - loc is nil, returning nil.");
    }
    if (loc != nil) {
        NSLog(@"  - returning location %f, %f", loc.coordinate.latitude, loc.coordinate.longitude);
    } else {
        NSLog(@"  - returning location (nil)");
    }
    return loc;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"LocationManager locationManager: didUpdateToLocation: fromLocation:");
    //NSLog(@"  - oldLocation: %@", oldLocation);
    //NSLog(@"  - newLocation: %@", newLocation);
    [delegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
}

@end
