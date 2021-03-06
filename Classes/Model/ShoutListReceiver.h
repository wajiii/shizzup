//
//  ShoutListReceiver.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/10.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoutManager.h"

@interface ShoutListReceiver : NSObject {
    NSString *cacheName;
    id<ShoutManagerDelegate> delegate;
    ShoutManager *manager;
    BOOL readFromCache;
    NSString *responseText;
}

@property (nonatomic, retain) NSString *cacheName;
@property (nonatomic, retain) id<ShoutManagerDelegate> delegate;
@property (nonatomic)         BOOL readFromCache;

- (id) initWithManager:(ShoutManager *)manager;
- (void) processShoutList;

@end
