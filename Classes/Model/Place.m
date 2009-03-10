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
@synthesize is_favorite;
@synthesize key = places_key;
@synthesize latitude;
@synthesize longitude;
@synthesize name = places_name;
@synthesize phone;
@synthesize state_iso;
@synthesize state_name;
@synthesize website;
@synthesize zip;

- (id) initFromDict:(NSDictionary *)placeDict {
//    address1 = [placeDict objectForKey:@"address1"];
//    NSLog(@"attribute keys: %@", [self attributeKeys]);
    [self setValuesForKeysWithDictionary:placeDict];
//    [self setValue:[placeDict objectForKey:@"address1"] forKey:@"address1"];
//    [self setValue:[placeDict objectForKey:@"address2"] forKey:@"address2"];
//    [self setValue:[placeDict objectForKey:@"city"] forKey:@"city"];
//    [self setValue:[placeDict objectForKey:@"country_iso"] forKey:@"country_iso"];
//    [self setValue:[placeDict objectForKey:@"country_name"] forKey:@"country_name"];
//    [self setValue:[placeDict objectForKey:@"distance"] forKey:@"distance"];
//    [self setValue:[placeDict objectForKey:@"is_favorite"] forKey:@"is_favorite"];
//    [self setValue:[placeDict objectForKey:@"latitude"] forKey:@"latitude"];
//    [self setValue:[placeDict objectForKey:@"longitude"] forKey:@"longitude"];
//    [self setValue:[placeDict objectForKey:@"phone"] forKey:@"phone"];
//    [self setValue:[placeDict objectForKey:@"places_key"] forKey:@"places_key"];
//    [self setValue:[placeDict objectForKey:@"places_name"] forKey:@"places_name"];
//    [self setValue:[placeDict objectForKey:@"state_iso"] forKey:@"state_iso"];
//    [self setValue:[placeDict objectForKey:@"state_name"] forKey:@"state_name"];
//    [self setValue:[placeDict objectForKey:@"website"] forKey:@"website"];
//    [self setValue:[placeDict objectForKey:@"zip"] forKey:@"zip"];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Place setValue:%@ forUndefinedKey:%@", value, key);
}

@end
