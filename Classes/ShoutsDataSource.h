//
//  ShoutsDataSource.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoutManager.h"

@interface ShoutsDataSource : NSMutableArray <UITableViewDataSource, UITableViewDelegate> {
    UIImage *defaultPersonIcon;
    NSArray* shouts;
}

@property (nonatomic, retain) NSArray* shouts;

+ (ShoutsDataSource *) initWithManager:(ShoutManager *)manager;

@end
