//
//  ShoutListCell.h
//  FastScrolling
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/15.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "Shout.h"

@interface ShoutListCell : ABTableViewCell {
    NSString *age;
    NSString *message;
    Shout *shout;
    NSNumber *shoutId;
}

@property (nonatomic, retain) Shout *shout;

+ (CGFloat) tableView:(UITableView *)tableView heightForShout:(Shout *)shout;
+ (NSString *) messageForShout:(Shout *)shout;
+ (void) setPageWidth:(CGFloat)newWidth;

@end
