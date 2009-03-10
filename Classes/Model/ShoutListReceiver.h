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
    id<ShoutManagerDelegate> delegate;
    NSString *responseText;
}

@property (nonatomic, retain) id<ShoutManagerDelegate> delegate;

@end
