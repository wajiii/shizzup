//
//  Shout.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "Shout.h"

@implementation Shout

@synthesize message;
@synthesize shoutId;
@synthesize icon;

+ (Shout*) init:(long)historyId {
    Shout* shout = [Shout alloc];
    shout.shoutId = historyId;
    shout.message = @"";
    return shout;
}

@end
