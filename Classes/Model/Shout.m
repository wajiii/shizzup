//
//  Shout.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "Shout.h"

#import "IconCache.h"
#import "ImageManipulator.h"
#import "ShoutManager.h"

@implementation Shout

// Real separate fields
@synthesize shoutId;

// Maps to dictionary
@synthesize latitude;
@synthesize longitude;
@synthesize messages = shouts_messages;
@synthesize modified;
@synthesize personFullName = profiles_name;
@synthesize placeName = places_name;
@synthesize shouts_history_id;
@synthesize status;
@synthesize username = people_name;

+ (Shout *) initWithDict:(NSDictionary *) shoutDict fromManager:(ShoutManager *)manager {
    Shout *shout = [Shout alloc];
    [shout initWithDict:shoutDict fromManager:manager];
    return shout;
}

- (Shout *) initWithDict:(NSDictionary *) shoutDict fromManager:(ShoutManager *)manager {
    [self init];
    //NSLog(@"Shout initWithDict:%@", shoutDict);
    //NSLog(@"Shout initWithDict");
    raw = shoutDict;
    [self setValuesForKeysWithDictionary:raw];
    shoutId = [[NSNumber alloc] initWithLongLong:[shouts_history_id longLongValue]];
    iconCache = [manager iconCache];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Shout setValue:%@ forUndefinedKey:%@", value, key);
}

- (NSString *) message {
    if (!message_checked) {
        //NSLog(@"   - message_checked is false; looking for message for shout %@ in dictionary:\n%@", shouts_history_id, shouts_messages);
        for (NSDictionary *messageDict in shouts_messages) {
            //NSLog(@"   - messageDict: %@", messageDict);
            NSString *messageShoutId = [messageDict valueForKey:@"shouts_history_id"];
            //NSLog(@"   - is \"%@\" equal to \"%@\"?", shouts_history_id, messageShoutId);
            if ([shouts_history_id isEqualToString:messageShoutId]) {
                //NSLog(@"     - yes!");
                message = [messageDict valueForKey:@"message"];
                //NSLog(@"     - message: \"%@\"", message);
                break;
            }
        }
        //        message = @"abc";
        message_checked = YES;
    }
    return message;
}

- (UIImage *) icon {
    //NSLog(@"Shout icon");
    if (icon == nil) {
        // Only incur synchronization cost if necessary.
        @synchronized(self) {
            // Check again to be sure this is still needed.
            if (icon == nil) {
                //NSLog(@"   - people_images: %@: %@", people_images);
                NSString *iconAddress = [people_images valueForKey:@"people_image_48"];
                //NSLog(@"   - iconAddress: %@: %@", [iconAddress class], iconAddress);
//                UIImage *roundedIcon;
//                if ([iconAddress compare:@"/images/people/people_48.jpg"] == 0) {
//                    roundedIcon = nil;
//                } else {
//                    NSURL *iconUrl = [NSURL URLWithString:iconAddress];
//                    roundedIcon = [ImageManipulator getIconForUrl:iconUrl];
//                }
//                icon = [roundedIcon retain];
                icon = [iconCache iconForAddress: iconAddress];
            }
        }
    }
    return icon;
}

- (BOOL) isHere {
    return [status isEqualToString:@"here"];
}

- (NSString *) relativeShoutTime {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    if (currentTime >= shout_time_nextUpdate) {
        NSLog(@"Shout relativeShoutTime");
        NSLog(@"  - shout_time: %@", shout_time);
        //NSLog(@"  - currentTime: %f", currentTime);
        NSDate *dateModified = [self dateFromISO8601:modified];
        //NSLog(@"   - modified as NSDate: %@", dateModified);
        NSDate *now = [NSDate date];
        //double timeInterval = trunc([now timeIntervalSinceDate:dateModified]);
        double timeInterval = [now timeIntervalSinceDate:dateModified];
        long int timeValue = lrint(timeInterval);
        //NSLog(@"  - timeInterval: %f", timeInterval);
        NSString *timeUnit;
        int timeUnitSeconds = 1;
        if (timeInterval < 60) {
            timeUnit = @"second";
        } else if (timeInterval < 3600) {
            timeUnit = @"minute";
            timeUnitSeconds = 60;
        } else if (timeInterval < 86400) {
            timeUnit = @"hour";
            timeUnitSeconds = 3600;
        } else {
            timeUnit = @"day";
            timeUnitSeconds = 86400;
        }
        timeValue = lrint(timeInterval / timeUnitSeconds);
        int updatePeriod = (timeValue * timeUnitSeconds) - timeInterval;
        if (updatePeriod < 0) {
            updatePeriod += timeUnitSeconds;
        }
        //NSLog(@"  - timeUnit: %@, timeValue: %d, updatePeriod: %d", timeUnit, timeValue, updatePeriod);
        if (timeValue != 1) {
            timeUnit = [timeUnit stringByAppendingString:@"s"];
            //NSLog(@"  - timeValue: %d, timeUnit: %@", timeValue, timeUnit);
        }
        //shout_time = [NSString stringWithFormat:@"%.0f %@ ago", timeInterval, timeUnit];
        shout_time = [NSString stringWithFormat:@"%d %@ ago", timeValue, timeUnit];
        [shout_time retain];
        NSLog(@"  - shout_time: %@", shout_time);
        shout_time_nextUpdate = currentTime + updatePeriod;
        NSLog(@"  - shout_time_nextUpdate: %f", shout_time_nextUpdate);
    }
    return shout_time;
}

/*
 Derived from code posted by Nathan Vander Wilt:
 http://www.cocoabuilder.com/archive/message/cocoa/2008/3/18/201578
 */
- (NSDate *) dateFromISO8601:(NSString *) str {
    static NSDateFormatter* sISO8601 = nil;
    if (!sISO8601) {
        sISO8601 = [[NSDateFormatter alloc] init];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];    // NOTE: problem!
    }
    if ([str hasSuffix:@"Z"]) {
        str = [[str substringToIndex:(str.length-1)] stringByAppendingString:@"GMT"];
    }
    return [sISO8601 dateFromString:str];
}

@end
