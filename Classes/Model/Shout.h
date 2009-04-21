//
//  Shout.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShoutManager;
@class IconCache;

@interface Shout : NSObject {
    NSDictionary *raw;
    NSNumber *shoutId;
    IconCache *iconCache;
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
    CFAbsoluteTime shout_time_nextUpdate;
    NSString *shouts_history_id;
    NSDictionary *shouts_messages;
    NSString *state_iso;
    NSString *status;
    NSString *website;
    NSString *state_name;
    NSString *zip;
}

@property (nonatomic, readonly, retain) NSNumber *shoutId;
@property (nonatomic, readonly, retain) UIImage  *icon;

@property (nonatomic, readonly)         BOOL     isHere;
@property (nonatomic, readonly, retain) NSString *latitude;
@property (nonatomic, readonly, retain) NSString *longitude;
@property (nonatomic, readonly)         NSString *message;
@property (nonatomic, readonly)         NSDictionary *messages;
@property (nonatomic, readonly, retain) NSString *modified;
@property (nonatomic, readonly, retain) NSString *personFullName;
@property (nonatomic, readonly, retain) NSString *placeName;
@property (nonatomic, readonly, retain) NSString *relativeShoutTime;
@property (nonatomic, readonly, retain) NSString *shouts_history_id;
@property (nonatomic, readonly, retain) NSString *status;
@property (nonatomic, readonly, retain) NSString *username;

+ (Shout *) initWithDict:(NSDictionary *)shoutDict fromManager:(ShoutManager *)manager;
- (Shout *) initWithDict:(NSDictionary *)shoutDict fromManager:(ShoutManager *)manager;
- (NSDate *) dateFromISO8601:(NSString *)str;

@end
