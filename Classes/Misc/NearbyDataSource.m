//
//  NearbyDataSource.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "NearbyDataSource.h"

#import "ShizzupConstants.h"
#import "ShizzupAppDelegate.h"

#define CELL_REUSE_ID @"ShoutCell"
#define TAG_ICON 10
#define TAG_LABEL 20
#define CELL_HEIGHT_MIN (ICON_HEIGHT + (ICON_MARGIN_VERTICAL * 2))

@implementation NearbyDataSource

@synthesize controller;
@synthesize shouts;

- (id) init {
    [super init];
    return self;
}

+ (NearbyDataSource *) initWithManager:(ShoutManager *)manager controller:(NearbyViewController *)controller{
    NearbyDataSource *source = [[NearbyDataSource alloc] init];
    [source setController: controller];
    [manager setDelegate: source];
    return source;
}

- (void) managerLoadedShouts:(NSArray *)newShouts {
    NSLog(@"NearbyDataSource managerLoadedShouts:");
    [self setShouts: newShouts];
    [controller dataLoaded:newShouts];
}

@end
