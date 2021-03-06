//
//  PlaceManager.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//@class Place;
@class PlaceListReceiver;
@class PlaceManager;
@class ShizzowApiConnection;

@protocol PlaceManagerDelegate
- (void) managerLoadedPlaces:(NSArray *) places;
- (void) placeManager:(PlaceManager *) manager loadError:(NSError *) error;
@end

@interface PlaceManager : NSObject {
    CLLocation *center;
    id<PlaceManagerDelegate> delegate;
    PlaceListReceiver *receiver;
    NSString *responseText;
    ShizzowApiConnection *api;
}

@property (nonatomic, retain) CLLocation *center;
@property (nonatomic, retain) id<PlaceManagerDelegate> delegate;

- (void) findPlaces;

@end
