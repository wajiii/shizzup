//
//  Place.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Place : NSObject {
    NSString * address1;
    NSString * address2;
    NSString * city;
    NSString * country_iso;
    NSString * country_name;
    NSString * distance;
    NSString * is_favorite;
    NSString * latitude;
    NSString * longitude;
    NSString * phone;
    NSString * places_key;
    NSString * places_name;
    NSString * state_iso;
    NSString * state_name;
    NSString * website;
    NSString * zip;
}

@property (nonatomic, retain) NSString *address1;
@property (nonatomic, retain) NSString *address2;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country_iso;
@property (nonatomic, retain) NSString *country_name;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *is_favorite;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *places_key;
@property (nonatomic, retain) NSString *places_name;
@property (nonatomic, retain) NSString *state_iso;
@property (nonatomic, retain) NSString *state_name;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *zip;

- (id) initFromDict:(NSDictionary *)placeDict;

@end
