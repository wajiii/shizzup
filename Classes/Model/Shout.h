//
//  Shout.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShoutManager;

@interface Shout : NSObject {
    NSDictionary *raw;
    NSNumber *shoutId;
    //NSString *username;
    //NSString *placeName;
    //NSString *relativeShoutTime;
    UIImage *icon;
    
    // Start dictionary keys
    NSString *address1;
    NSString *address2;
    NSString *altitude;
    NSString *arrived;
    NSString *city;
    NSString *country_iso;
    NSString *country_name;
    NSString *distance;
    NSString *distance_unit;
    NSString *latitude;
    NSString *longitude;
    NSString *message;
    BOOL      message_checked;
    NSString *modified;
    NSString *people_name;
    NSDictionary *people_images;
    NSString *phone;
    NSString *places_key;
    NSString *places_name;
    NSString *profiles_name;
    NSString *public;
    NSString *shout_time;
    NSString *shouts_history_id;
    NSDictionary *shouts_messages;
    NSString *state_iso;
    NSString *status;
    NSString *website;
    NSString *state_name;
    NSString *zip;
}

@property (readonly, retain) NSNumber *shoutId;
@property (readonly, retain) UIImage *icon;

@property (readonly, retain) NSString *latitude;
@property (readonly, retain) NSString *longitude;
@property (readonly)         NSString *message;
@property (readonly, retain) NSString *modified;
@property (readonly, retain) NSString *placeName;
@property (readonly, retain) NSString *relativeShoutTime;
@property (readonly, retain) NSString *username;

+ (Shout *) initWithDict:(NSDictionary *)shoutDict fromManager:(ShoutManager *)manager;
- (Shout *) initWithDict:(NSDictionary *)shoutDict fromManager:(ShoutManager *)manager;

@end
