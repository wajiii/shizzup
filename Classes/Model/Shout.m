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
@synthesize modified;
@synthesize placeName = places_name;
@synthesize relativeShoutTime = shout_time;
@synthesize status;
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

@end
