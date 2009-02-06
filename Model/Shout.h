//
//  Shout.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shout : NSObject {
    long shoutId;
    NSString *username;
    NSString *placeName;
    NSString *relativeShoutTime;
    NSString *message;
    UIImage *icon;
}

@property (nonatomic) long shoutId;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *placeName;
@property (nonatomic, retain) NSString *relativeShoutTime;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) UIImage *icon;

+ (Shout*) init:(long)historyId;

@end
