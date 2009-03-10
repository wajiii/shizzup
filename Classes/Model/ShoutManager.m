//
//  Shouts.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutManager.h"

#import "LocationManager.h"
#import "ShizzupAppDelegate.h"
#import "ShizzupConstants.h"
#import "Shout.h"
#import "ShoutListReceiver.h"

@implementation ShoutManager

@synthesize delegate;
@synthesize limit;
@synthesize radius;
@synthesize who;

- (id) init {
    [super init];
    api = nil;
    limit = SHIZZOW_API_SHOUTS_LIMIT_DEFAULT;
    radius = SHIZZOW_API_SHOUTS_RADIUS_DEFAULT;
    who = @"everyone";
    return self;
}

- (void) findShoutsForLocation:(CLLocation *)location {
    NSString *apiUriStub = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&radius=%f&radius_unit=%@&limit=%d", SHIZZOW_API_PATH_SHOUTS, location.coordinate.latitude, location.coordinate.longitude, radius, SHIZZOW_API_SHOUTS_RADIUSUNIT_DEFAULT, limit ];
    NSLog(@"   apiUriStub: %@", apiUriStub);
//    if (api != nil) {
//        [api abort];
//    }
    api = [[ShizzowApiConnection alloc] init];
    ShoutListReceiver *receiver = [[ShoutListReceiver alloc] init];
    [receiver setDelegate: delegate];
    [api callUri:apiUriStub delegate:self];
}

- (void) findShouts {
    NSString *apiUriStub = [NSString stringWithFormat:@"%@?who=listening&limit=%d", SHIZZOW_API_PATH_SHOUTS, SHIZZOW_API_SHOUTS_LIMIT_DEFAULT];
    NSLog(@"   apiUriStub: %@", apiUriStub);
//    if (api != nil) {
//        [api abort];
//    }
    api = [[ShizzowApiConnection alloc] init];
    ShoutListReceiver *receiver = [[ShoutListReceiver alloc] init];
    [receiver setDelegate: delegate];
    [api callUri: apiUriStub delegate: receiver];
}

- (void) sendShoutFromPlace:(NSString *)placeKey withMessage:(NSString *)message{
    NSString *apiUriStub = [NSString stringWithFormat:@"/places/%@/shout"];
    NSString *body = [NSString stringWithFormat:@"shouts_message=%@", message];
    api = [[ShizzowApiConnection alloc] init];
    ShoutListReceiver *receiver = [[ShoutListReceiver alloc] init];
    [receiver setDelegate: delegate];
    [api callUri: apiUriStub usingMethod:@"PUT" withDelegate:receiver withBody:body];
}

@end

// This lets us bypass the certificate error on the API server:
//@implementation NSURLRequest(DataController)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
//	return YES;
//}
//@end