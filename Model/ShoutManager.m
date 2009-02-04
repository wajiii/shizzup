//
//  Shouts.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutManager.h"
#import "Shout.h"

@implementation ShoutManager

@synthesize limit;

- (Shout *) createShout:(long)shoutId {
  Shout *dummy = [[Shout alloc] autorelease];
    dummy.shoutId = shoutId;
    dummy.message = [NSString stringWithFormat:@"Hello Shizzow %d!", shoutId];
    NSLog([NSString stringWithFormat:@"Shout %d: %s", dummy.shoutId, dummy.message]);
    return dummy;
}

- (NSArray*) getList {
    NSURLConnection *connection = [[NSURLConnection alloc] autorelease];
    //printf("connection: %s\n", connection);
    NSURLRequest *request = [[[NSURLRequest alloc] autorelease] init];
    //printf("request: %s\n", request);
    [connection initWithRequest:request delegate:self];
    NSMutableArray *list = [[[NSMutableArray alloc] autorelease] init];
    Shout *dummy = [self createShout:1];
    [list addObject:dummy];
    dummy = [self createShout:2];
    [list addObject:dummy];
    dummy = [self createShout:3];
    [list addObject:dummy];
    dummy = [self createShout:4];
    [list addObject:dummy];
    dummy = [self createShout:5];
    dummy.icon = [UIImage imageNamed:@"DefaultPersonIcon.png"];
    [list addObject:dummy];
    return list;
}

@end
