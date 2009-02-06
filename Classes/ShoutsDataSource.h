//
//  ShoutsDataSource.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EveryoneViewController.h"
#import "ShoutManager.h"

@interface ShoutsDataSource : NSMutableArray <ShoutManagerCallback, UITableViewDataSource, UITableViewDelegate> {
    UIImage *defaultPersonIcon;
    NSArray* shouts;
    EveryoneViewController *controller;
}

@property (nonatomic, retain) NSArray *shouts;
@property (nonatomic, retain) EveryoneViewController* controller;

+ (ShoutsDataSource *) initWithManager:(ShoutManager *)manager controller:(EveryoneViewController *)controller;

@end
