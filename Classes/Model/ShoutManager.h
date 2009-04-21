//
//  Shouts.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "IconCache.h"
#import "ShizzowApiConnection.h"
#import "Shout.h"

@protocol ShoutManagerDelegate
- (void) managerLoadedShouts:(NSArray *) shouts;
@end

@interface ShoutManager : NSObject {
    ShizzowApiConnection *api;
    id<ShoutManagerDelegate> delegate;
    long limit;
    float radius;
    NSString *who;
    IconCache *iconCache;
}

@property (nonatomic, retain) id<ShoutManagerDelegate> delegate;
@property (nonatomic) long limit;
@property (nonatomic) float radius;
@property (nonatomic, retain) NSString *who;
@property (nonatomic, retain, readonly) IconCache *iconCache;

- (void) findShouts;
- (void) loadCachedShouts;
- (void) findShoutsForLocation:(CLLocation *)location;
- (void) sendShoutFromPlace:(NSString *)placeKey withMessage:(NSString *)message;

@end
