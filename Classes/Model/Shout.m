//
//  Shout.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "Shout.h"
#import "ImageManipulator.h"
#import "ShoutManager.h"

@implementation Shout

// Real separate fields
@synthesize shoutId;
@synthesize icon;

// Maps to dictionary
@synthesize latitude;
@synthesize longitude;
@synthesize modified;
@synthesize placeName = places_name;
@synthesize relativeShoutTime = shout_time;
@synthesize username = people_name;

+ (Shout *) initWithDict:(NSDictionary *) shoutDict fromManager:(ShoutManager *)manager {
    Shout *shout = [Shout alloc];
    [shout initWithDict:shoutDict fromManager:manager];
    return shout;
}

- (Shout *) initWithDict:(NSDictionary *) shoutDict fromManager:(ShoutManager *)manager {
    //NSLog(@"Shout initWithDict:%@", shoutDict);
    //NSLog(@"Shout initWithDict");
    raw = shoutDict;
    [self setValuesForKeysWithDictionary:raw];
    shoutId = [[NSNumber alloc] initWithLongLong:[shouts_history_id longLongValue]];
    
    NSDictionary *iconAddresses = [raw valueForKey:@"people_images"];
    //NSLog(@"   iconAddresses: %@: %@", [iconAddresses class], placeName);
    NSString *iconAddress = [iconAddresses valueForKey:@"people_image_48"];
    //NSLog(@"   iconAddress: %@: %@", [iconAddress class], iconAddress);
    UIImage *roundedIcon;
    if ([iconAddress compare:@"/images/people/people_48.jpg"] == 0) {
        roundedIcon = nil;
    } else {
        NSURL *iconUrl = [NSURL URLWithString:iconAddress];
        roundedIcon = [ImageManipulator getIconForUrl:iconUrl];
    }
    icon = [roundedIcon retain];
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Shout setValue:%@ forUndefinedKey:%@", value, key);
}

@end
