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

CLLocationManager *wrapped;
CLLocation *defaultLocation;

void ensureInit() {
    if (wrapped == nil) {
        NSLog(@"Oh crap, wrapped is nil, we're all going to die!");
        wrapped = [[CLLocationManager alloc] init];
        NSLog(@"MAP_LAT_INITIAL: %f", MAP_LAT_INITIAL);
        float latJiggle = (arc4random() % 100000);
        NSLog(@"latJiggle.1: %f", latJiggle);
        latJiggle -= 50000;
        NSLog(@"latJiggle.2: %f", latJiggle);
        latJiggle /= 1000000;
        NSLog(@"latJiggle.3: %f", latJiggle);
//        CLLocationDegrees defaultLatitude = MAP_LAT_INITIAL + latJiggle;
        CLLocationDegrees defaultLatitude = MAP_LAT_INITIAL;
        NSLog(@"defaultLatitude: %f", defaultLatitude);
        defaultLocation = [[CLLocation alloc] initWithLatitude:defaultLatitude longitude:MAP_LON_INITIAL];
        //[wrapped setLocation:defaultLocation];
        [wrapped setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    }
}

+ (void) setDelegate:(id<CLLocationManagerDelegate>) delegate {
    ensureInit();
    [wrapped setDelegate: delegate];
}

+ (void) startUpdating {
    ensureInit();
    [wrapped startUpdatingLocation];
}

+ (void) stopUpdating {
    ensureInit();
    [wrapped stopUpdatingLocation];
}

+ (CLLocation *) location {
    ensureInit();
    if (![wrapped locationServicesEnabled]) {
        return defaultLocation;
    }
#if (TARGET_IPHONE_SIMULATOR)
    return defaultLocation;
#endif
    CLLocation *loc = [wrapped location];
    if (loc == nil) {
        loc = defaultLocation;
    }
    return loc;
}

//+ (BOOL) locationServicesEnabled {
//    ensureInit();
//    return [wrapped locationServicesEnabled];
//}
//
//+ (CLLocationDistance) distanceFilter {
//    ensureInit();
//    return [wrapped distanceFilter];
//}
//
//+ (void) setDistanceFilter:(CLLocationDistance) filter {
//    ensureInit();
//    [wrapped setDistanceFilter:filter];
//}

@end
