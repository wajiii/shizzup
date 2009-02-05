//
//  ShoutsDataSource.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutsDataSource.h"

#define CELL_REUSE_ID @"ShoutCell"
#define ICON_TAG 10
#define LABEL_TAG 20
#define ICON_WIDTH_MAX 64.0
#define ICON_HEIGHT_MAX 64.0
#define ICON_MARGIN_HORIZONTAL 2
#define ICON_MARGIN_VERTICAL 2
#define CELL_HEIGHT_MIN ICON_HEIGHT_MAX + (ICON_MARGIN_VERTICAL*2)

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

- (void) setIcon:(UIImage *) shoutIcon forCell:(UITableViewCell *) cell  {
    // Add icon
    UIImage *icon;
    if (shoutIcon != nil) {
        icon = shoutIcon;
    } else {
        icon = defaultPersonIcon;
    }
    CGFloat iconWidth = icon.size.width;
    CGFloat iconHeight = icon.size.height;
    if (iconWidth > ICON_WIDTH_MAX) {
        NSLog(@"Icon width too great, resizing from: %5.1fx%5.1f", iconWidth, iconHeight);
        iconHeight = (iconHeight * ICON_WIDTH_MAX) / iconWidth;
        iconWidth = ICON_WIDTH_MAX;
        NSLog(@"                                 to: %5.1fx%5.1f", iconWidth, iconHeight);
    }
    if (iconHeight > ICON_HEIGHT_MAX) {
        NSLog(@"Icon height too great, resizing from: %5.1fx%5.1f", iconWidth, iconHeight);
        iconWidth = (iconWidth * ICON_HEIGHT_MAX) / iconHeight;
        iconHeight = ICON_HEIGHT_MAX;
        NSLog(@"                                  to: %5.1fx%5.1f", iconWidth, iconHeight);
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
    imageView.tag = ICON_TAG;
    imageView.frame = CGRectMake(ICON_MARGIN_HORIZONTAL, ICON_MARGIN_HORIZONTAL, iconWidth, iconHeight);
    [cell.contentView addSubview:imageView];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Getting cell for row at index path: %@", indexPath);
    NSUInteger shoutIndex = [indexPath indexAtPosition:([indexPath length]-1)];
    Shout *shout = [self getShoutForRow:shoutIndex];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID] autorelease];
        //CGRect frame = CGRectMake(0, 0, 320, 96);
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID] autorelease];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        CGSize cellFrameSize = cell.frame.size;
        NSLog(@"cell frame size width, height: %f, %f", cellFrameSize.width, cellFrameSize.height);
        
        // Add icon
        [self setIcon:shout.icon forCell:cell];
        
        // Add label
        //UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(68, 0, (cellFrameSize.width-68), cell.frame.size.height)] autorelease];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(68, 0, (cellFrameSize.width-68), cell.frame.size.height)];
        label.tag = LABEL_TAG;
        label.font = [UIFont systemFontOfSize:12.0];
        //label.autoresizingMask = 1;
        label.textAlignment = UITextAlignmentLeft;
        label.textColor = [UIColor blueColor];
        label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        [label setNumberOfLines:(cellFrameSize.height / 12)];
        label.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:label];
    }
//    [[cell image] stretchableImageWithLeftCapWidth:cell.frame.size.height topCapHeight:cell.frame.size.height];
//    CGSize iconSize = cell.image.size;
//    CGFloat cellHeight = cell.frame.size.height;
//    if (iconSize.height > cellHeight) {
//        CGSize newIconSize = CGSizeMake(cellHeight, cellHeight);
//        @try {
//            if (cell.image != nil) {
//                NSLog(@"%b", [cell.image isKindOfClass:[UIImage class]]);
//            } else {
//                NSLog(@"cell.image is nil.");
//            }
//            //cell.image.size = newIconSize;
//            //[cell.image setSize:newIconSize];
//        }
//        @catch (NSException *e) {
//            NSLog(@"Caught exception while resizing image: %@ %@ %@", e, [e name], [e reason]);
//        }
//    }
    cell.textColor = [UIColor redColor];
    cell.backgroundColor = [UIColor redColor];
    cell.opaque = 1.0;
    //NSString *newText = [NSString localizedStringWithFormat:@"%@", shout.shoutId, shout.message];
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
            CGSize cellSize = [shout.message sizeWithFont:[UIFont systemFontOfSize:12] forWidth:300 lineBreakMode:UILineBreakModeWordWrap];
            result = cellSize.height;
        }
        NSLog(@"row %d (shout %@) height: %d", shoutIndex, shout, result);
        NSString *ageString = @"10 minutes ago";
        CGSize ageSize = [ageString sizeWithFont:[UIFont systemFontOfSize:12]];
        result += ageSize.height;
        NSLog(@"          updated height: %d", shoutIndex, shout, result);
        if (result < CELL_HEIGHT_MIN) {
            result = CELL_HEIGHT_MIN;
            NSLog(@"Generated row height was too small; overridden to %5.1f.", result);
        }
    }
    @catch (NSException * e) {
        NSLog(@"Caught exception in ShoutsDataSource:heightForRowAtIndexPath: %@ %@\n%@", [e name], [e reason], [e callStackReturnAddresses]);
    }
    return result;
}

@end
