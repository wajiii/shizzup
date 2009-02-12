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
    NSString *placeName;
    NSString *relativeShoutTime;
    UIImage *icon;

    // Start dictionary keys
    NSString *people_name;
    NSString *places_name;
    NSString *shout_time;
    NSDictionary *people_images;
    NSString *phone;
    NSDictionary *shouts_messages;
    NSString *status;
    NSString *website;
    NSString *country_iso;
    NSString *public;
    NSString *arrived;
    NSString *profiles_name;
    NSString *places_key;
    NSString *address1;
    NSString *address2;
    NSString *state_name;
    NSString *zip;
    NSString *country_name;
    NSString *latitude;
    NSString *longitude;
    NSString *shouts_history_id;
    NSString *modified;
    NSString *city;
    NSString *state_iso;
}

@property (readonly, retain) NSNumber *shoutId;
@property (readonly, retain) NSString *username;
@property (readonly, retain) NSString *placeName;
@property (readonly, retain) NSString *relativeShoutTime;
@property (readonly, retain) NSString *latitude;
@property (readonly, retain) NSString *longitude;
@property (readonly, retain) UIImage *icon;

+ (Shout *) initWithDict:(NSDictionary *)shoutDict fromManager:(ShoutManager *)manager;
- (Shout *) initWithDict:(NSDictionary *)shoutDict fromManager:(ShoutManager *)manager;

@end
