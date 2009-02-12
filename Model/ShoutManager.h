//
//  Shouts.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shout.h"

@protocol ShoutManagerDelegate
- (void) managerLoadedShouts:(NSArray *) shouts;
@end

@interface ShoutManager : NSObject {
    long limit;
    NSString *responseText; 
    id<ShoutManagerDelegate> delegate;
}

@property (nonatomic) long limit;
@property (nonatomic, retain) id<ShoutManagerDelegate> delegate;

- (void) findShouts;

@end
