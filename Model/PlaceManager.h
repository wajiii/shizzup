//
//  PlaceManager.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Place.h"

@protocol PlaceManagerDelegate
- (void) managerLoadedPlaces:(NSArray *) places;
@end

@interface PlaceManager : NSObject {
    CLLocation *center;
    id<PlaceManagerDelegate> delegate;
    NSString *responseText;
}

@property (nonatomic, retain) CLLocation *center;
@property (nonatomic, retain) id<PlaceManagerDelegate> delegate;

- (void) findPlaces;

@end
