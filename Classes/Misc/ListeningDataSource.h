//
//  ListeningDataSource.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListeningViewController.h"
#import "ShoutManager.h"

@interface ListeningDataSource : NSMutableArray <ShoutManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIFont *ageFont;
    ListeningViewController *controller;
    UIImage *defaultPersonIcon;
    CGFloat labelWidth;
    UIFont *messageFont;
    NSArray* shouts;
}

@property (nonatomic, retain) NSArray *shouts;
@property (nonatomic, retain) ListeningViewController* controller;

+ (ListeningDataSource *) initWithManager:(ShoutManager *)manager controller:(ListeningViewController *)controller;
- (NSUInteger) shoutRowForIndexPath:(NSIndexPath *)indexPath;

@end
