//
//  Place.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize address1;
@synthesize address2;
@synthesize altitude;
@synthesize city;
@synthesize country_iso;
@synthesize country_name;
@synthesize distance;
@synthesize distance_unit;
@synthesize key = places_key;
@synthesize latitude;
@synthesize longitude;
@synthesize name = places_name;
@synthesize phone;
@synthesize state_iso;
@synthesize state_name;
@synthesize website;
@synthesize zip;

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
    [address1 release];
    [address2 release];
    [altitude release];
    [city release];
    [country_iso release];
    [country_name release];
    [distance release];
    [distance_unit release];
    [places_key release];
    [latitude release];
    [longitude release];
    [places_name release];
    [phone release];
    [state_iso release];
    [state_name release];
    [website release];
    [zip release];
    [super dealloc];
}

- (id) initFromDict:(NSDictionary *)placeDict {
    [self setValuesForKeysWithDictionary:placeDict];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Place setValue:%@ forUndefinedKey:%@", value, key);
}

- (BOOL) isFavorite {
    return ([is_favorite integerValue] == 1);
}

@end
