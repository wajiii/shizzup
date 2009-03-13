//
//  ListeningDataSource.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ListeningDataSource.h"

#import "ShizzupConstants.h"
#import "ShizzupAppDelegate.h"

#define CELL_REUSE_ID @"ShoutCell"
#define TAG_ICON 10
#define TAG_LABEL 20
#define CELL_HEIGHT_MIN (ICON_HEIGHT + (ICON_MARGIN_VERTICAL * 2))

@implementation ListeningDataSource

@synthesize controller;
@synthesize shouts;

- (id) init {
    [super init];
    defaultPersonIcon = [UIImage imageNamed:@"DefaultPersonIcon.png"];
    return self;
}

+ (ListeningDataSource *) initWithManager:(ShoutManager *)manager controller:(ListeningViewController *)controller{
    ListeningDataSource *source = [[ListeningDataSource alloc] init];
    [source setController: controller];
    [manager setDelegate: source];
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

- (NSString *) textForShout: (Shout *) shout  {
    if (shout == nil) {
        NSLog(@"WTF, passing nil to textForShout?!");
        return @"WTF";
    }
    NSString *username = shout.username;
    NSString *placeName = shout.placeName;
    NSString *relativeShoutTime = shout.relativeShoutTime;
    NSString *shoutText = [NSString stringWithFormat:@"%@ shouted from %@ %@", username, placeName, relativeShoutTime];
    if (shout.message != nil) {
        shoutText = [shoutText stringByAppendingFormat:@":\n%@", shout.message];
    }
    return shoutText;
}

- (NSUInteger) shoutRowForIndexPath:(NSIndexPath *) indexPath {
    NSUInteger shoutIndex = [indexPath indexAtPosition:([indexPath length]-1)] - 1;
    return shoutIndex;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"ListeningDataSource cellForRowAtIndexPath: %@", indexPath);
    NSUInteger shoutIndex = [self shoutRowForIndexPath:indexPath];
    if (shoutIndex == -1) {
        return [controller refreshButtonCell];
    }
    Shout *shout = [self getShoutForRow :shoutIndex];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.opaque = 1.0;
        CGSize cellFrameSize = cell.frame.size;
        //NSLog(@"cell frame size width, height: %f, %f", cellFrameSize.width, cellFrameSize.height);
        
        // Add label
        CGFloat labelX = ICON_WIDTH + (ICON_MARGIN_HORIZONTAL * 2);
        CGFloat labelWidth = cellFrameSize.width - labelX;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, labelWidth, cellFrameSize.height)];
        label.tag = TAG_LABEL;
        label.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        label.adjustsFontSizeToFitWidth = NO;
        label.autoresizingMask = UIViewAutoresizingNone;
        label.textAlignment = UITextAlignmentLeft;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [label setNumberOfLines:(cellFrameSize.height / LABEL_FONT_SIZE)];
        label.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:label];
    }
    
    if (shoutIndex >= 0) {
        // Set icon
        [self setIcon:shout.icon forCell:cell];
        NSString *shoutText = [self textForShout: shout];
        [(UILabel*)[cell.contentView viewWithTag:TAG_LABEL] setText:shoutText];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result = 56;
    @try {
        NSUInteger shoutIndex = [self shoutRowForIndexPath:indexPath];
        //NSLog(@"shoutIndex: %d", shoutIndex);
        if (shoutIndex != -1) {
            Shout *shout = [self getShoutForRow:shoutIndex];
            NSString *shoutText = [self textForShout: shout];
            if (shout != nil) {
                CGSize cellSize = [shoutText sizeWithFont:[UIFont systemFontOfSize:12] forWidth:320 lineBreakMode:UILineBreakModeWordWrap];
                result = cellSize.height;
            }
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
        NSLog(@"Caught exception in ListeningDataSource:heightForRowAtIndexPath: %@ %@\n%@", [e name], [e reason], [e callStackReturnAddresses]);
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"ListeningDataSource :: tableView:%@ didSelectRowAtIndexPath:%@", tableView, newIndexPath);
    ShizzupAppDelegate *delegate = [ShizzupAppDelegate singleton];
    NSLog(@"   - delegate: %@", delegate);
    NSUInteger shoutIndex = [self shoutRowForIndexPath: newIndexPath];
    if (shoutIndex == -1) {
        NSLog(@"   - TODO: refresh list.");
        [controller refreshShoutList];
    } else {
        Shout *shout = [self getShoutForRow:shoutIndex];
        NSLog(@"   - shout: %@", shout);
        NSLog(@"   - shout.placeName: %@", shout.placeName);
        NSLog(@"   - shout.message: %@", shout.message);
    }
}

- (void) managerLoadedShouts:(NSArray *)newShouts {
    NSLog(@"ListeningDataSource managerLoadedShouts:");
    [self setShouts:newShouts];
    [controller dataLoaded: newShouts];
}

@end
