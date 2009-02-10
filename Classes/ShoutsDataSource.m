//
//  ShoutsDataSource.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutsDataSource.h"
#import "ShizzowConstants.h"

#define CELL_REUSE_ID @"ShoutCell"
#define TAG_ICON 10
#define TAG_LABEL 20
#define CELL_HEIGHT_MIN (ICON_HEIGHT + (ICON_MARGIN_VERTICAL * 2))

@implementation ShoutsDataSource

@synthesize controller;
@synthesize shouts;

- (id) init {
    [super init];
    defaultPersonIcon = [UIImage imageNamed:@"DefaultPersonIcon.png"];
    return self;
}

+ (ShoutsDataSource *) initWithManager:(ShoutManager *)manager controller:(EveryoneViewController *)controller{
    ShoutsDataSource *source = [[ShoutsDataSource alloc] init];
    [manager setCallback:source];
    NSArray* shouts = [manager getList];
    [source setController:controller];
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
    //NSLog(@"getShoutForRow %u = %@", row, shout);
    return shout;
}

- (void) setIcon:(UIImage *)shoutIcon forCell:(UITableViewCell *)cell  {
    // Add icon
    UIImage *icon;
    if (shoutIcon != nil) {
        icon = shoutIcon;
    } else {
        icon = defaultPersonIcon;
    }
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:TAG_ICON];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] init];
        imageView.tag = TAG_ICON;
        imageView.frame = CGRectMake(ICON_MARGIN_HORIZONTAL, ICON_MARGIN_VERTICAL, ICON_WIDTH, ICON_HEIGHT);
        [cell.contentView addSubview:imageView];
    }
    imageView.image = icon;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"ShoutsDataSource cellForRowAtIndexPath: %@", indexPath);
    NSUInteger shoutIndex = [indexPath indexAtPosition:([indexPath length]-1)];
    Shout *shout = [self getShoutForRow:shoutIndex];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID] autorelease];
        //CGRect frame = CGRectMake(0, 0, 320, 96);
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID] autorelease];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.opaque = 1.0;
        
        CGSize cellFrameSize = cell.frame.size;
        //NSLog(@"cell frame size width, height: %f, %f", cellFrameSize.width, cellFrameSize.height);
        
        // Add label
        //UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(68, 0, (cellFrameSize.width-68), cell.frame.size.height)] autorelease];
        CGFloat labelX = ICON_WIDTH + (ICON_MARGIN_HORIZONTAL * 2);
        CGFloat labelWidth = cellFrameSize.width - labelX;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, labelWidth, cellFrameSize.height)];
        label.tag = TAG_LABEL;
        label.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        label.adjustsFontSizeToFitWidth = NO;
        label.autoresizingMask = UIViewAutoresizingNone;
        label.textAlignment = UITextAlignmentLeft;
        //label.textColor = [UIColor blueColor];
        //label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        [label setNumberOfLines:(cellFrameSize.height / LABEL_FONT_SIZE)];
        label.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:label];
    }
    
    // Set icon
    [self setIcon:shout.icon forCell:cell];
    
    NSString *shoutText = [NSString stringWithFormat:@"%@ shouted from %@ %@", shout.username, shout.placeName, shout.relativeShoutTime];
    //    if (shout.message != nil && [shout.message length] > 0) {
    //        shoutText = [shoutText stringByAppendingString:[NSString stringWithFormat:@"\n%@", shout.message]];
    //    }
    [(UILabel*)[cell.contentView viewWithTag:TAG_LABEL] setText:shoutText];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result = 44;
    @try {
        NSUInteger shoutIndex = [indexPath indexAtPosition:([indexPath length]-1)];
        Shout *shout = [self getShoutForRow:shoutIndex];
        if (shout != nil) {
            CGSize cellSize = [shout.message sizeWithFont:[UIFont systemFontOfSize:12] forWidth:320 lineBreakMode:UILineBreakModeWordWrap];
            result = cellSize.height;
        }
        //NSLog(@"row %d (shout %@) height: %d", shoutIndex, shout, result);
        //        NSString *ageString = @"10 minutes ago";
        //        CGSize ageSize = [ageString sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE]];
        //        result += ageSize.height;
        //        NSLog(@"          updated height: %d", shoutIndex, shout, result);
        if (result < CELL_HEIGHT_MIN) {
            result = CELL_HEIGHT_MIN;
            //NSLog(@"Generated row height was too small; overridden to %5.1f.", result);
        }
    }
    @catch (NSException * e) {
        //NSLog(@"Caught exception in ShoutsDataSource:heightForRowAtIndexPath: %@ %@\n%@", [e name], [e reason], [e callStackReturnAddresses]);
    }
    return result;
}

- (void) managerLoadedShouts:(NSArray *)newShouts {
    [self setShouts:newShouts];
    [controller dataLoaded];
}

@end
