//
//  LocationManager.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/24.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface LocationManager : NSObject {
}

+ (void) setDelegate:(id<CLLocationManagerDelegate>) delegate;
+ (void) startUpdating;
+ (void) stopUpdating;
+ (CLLocation *) location;
//+ (BOOL) getLocationServicesEnabled;
//+ (CLLocationDistance) getDistanceFilter;
//+ (void) setDistanceFilter:(CLLocationDistance) filter;

@end
