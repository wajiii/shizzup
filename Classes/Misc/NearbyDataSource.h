//
//  NearbyDataSource.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearbyViewController.h"
#import "ShoutManager.h"

@interface NearbyDataSource : NSMutableArray <ShoutManagerDelegate> {
    NSArray* shouts;
    NearbyViewController *controller;
}

@property (nonatomic, retain) NSArray *shouts;
@property (nonatomic, retain) NearbyViewController* controller;

+ (NearbyDataSource *) initWithManager:(ShoutManager *)manager controller:(NearbyViewController *)controller;

@end
