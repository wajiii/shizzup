//
//  Shouts.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shout.h"

@interface ShoutManager : NSObject {
    long limit;
    NSString *responseText;
}

@property (nonatomic) long limit;

- (NSArray*) getList;

@end
