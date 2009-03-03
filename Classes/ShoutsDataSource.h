//
//  ShoutsDataSource.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoutListViewController.h"
#import "ShoutManager.h"

@interface ShoutsDataSource : NSMutableArray <ShoutManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIImage *defaultPersonIcon;
    NSArray* shouts;
    ShoutListViewController *controller;
}

@property (nonatomic, retain) NSArray *shouts;
@property (nonatomic, retain) ShoutListViewController* controller;

+ (ShoutsDataSource *) initWithManager:(ShoutManager *)manager controller:(ShoutListViewController *)controller;

@end
