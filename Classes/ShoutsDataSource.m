//
//  ShoutsDataSource.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutsDataSource.h"

#define CELL_REUSE_ID @"ShoutCell"
#define LABEL_TAG 10
#define CELL_HEIGHT_MIN
#define ICON_HEIGHT_MAX 64
#define ICON_WIDTH_MAX 64

@implementation ShoutsDataSource

@synthesize shouts;

- (id) init {
    [super init];
    defaultPersonIcon = [UIImage imageNamed:@"DefaultPersonIcon.png"];
    return self;
}

+ (ShoutsDataSource *) initWithManager:(ShoutManager *)manager {
    ShoutsDataSource *source = [[ShoutsDataSource alloc] init];
    NSArray* shouts = [manager getList];
    [source setShouts:shouts];
    return source;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [shouts count];
}

- (Shout *) getShoutForRow:(NSUInteger)row {
    Shout *shout = nil;
    //NSLog(@"Requested row: %u ; shout count: %u", row, [shouts count]);
    if ((row >= 0) && (row < [shouts count])) {
        shout = [shouts objectAtIndex:row];
    } else {
        NSLog(@"Oops! Requested row %u, but shout count is %u.", row, [shouts count]);
    }
    NSLog(@"getShoutForRow %u = %@", row, shout);
    return shout;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger shoutIndex = [indexPath indexAtPosition:([indexPath length]-1)];
    //NSLog([NSString stringWithFormat:@"index length: %d", [indexPath length]]);
    Shout *shout = [self getShoutForRow:shoutIndex];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID] autorelease];
        //CGRect frame = CGRectMake(0, 0, 320, 96);
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize cellFrameSize = cell.frame.size;
        NSLog(@"cell frame size width, height: %f, %f", cellFrameSize.width, cellFrameSize.height);
        // Add label
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(68, 0, (cellFrameSize.width-68), cell.frame.size.height)] autorelease];
        label.tag = LABEL_TAG;
        label.font = [UIFont systemFontOfSize:12.0];
        //label.autoresizingMask = 1;
        label.textAlignment = UITextAlignmentLeft;
        label.textColor = [UIColor blueColor];
        label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:label];
    }
    cell.image = [defaultPersonIcon copy];
    [[cell image] stretchableImageWithLeftCapWidth:cell.frame.size.height topCapHeight:cell.frame.size.height];
    if (shout.icon != nil) {
        cell.image = shout.icon;
    }
    CGSize iconSize = cell.image.size;
    CGFloat cellHeight = cell.frame.size.height;
    if (iconSize.height > cellHeight) {
        CGSize newIconSize = CGSizeMake(cellHeight, cellHeight);
        [cell.image setSize:newIconSize];            
    }
    cell.textColor = [UIColor redColor];
    cell.backgroundColor = [UIColor redColor];
    cell.opaque = 1.0;
    //NSString *newText = [NSString localizedStringWithFormat:@"a %u : %s b", shout.shouts_history_id, shout.message];
    //cell.text = newText;
    [(UILabel*)[cell.contentView viewWithTag:LABEL_TAG] setText:shout.message];
    //cell.text = shout.message;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result = 44;
    @try {
        NSUInteger shoutIndex = [indexPath indexAtPosition:([indexPath length]-1)];
        Shout *shout = [self getShoutForRow:shoutIndex];
        if (shout != nil) {
            CGSize cellSize = [shout.message sizeWithFont:[UIFont systemFontOfSize:14] forWidth:300 lineBreakMode:UILineBreakModeWordWrap];
            result = cellSize.height;
        }
        NSLog(@"row %d (shout %@) height: %d", shoutIndex, shout, result);
        if (result < 64) {
            result = 64;
            NSLog(@"Generated row height was too small; overridden to %d.", result);
        }
    }
    @catch (NSException * e) {
        NSLog(@"Caught exception: %@ %@\n%@", [e name], [e reason], [e callStackReturnAddresses]);
    }
    return result;
}

@end
