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
#import "ShoutDetailController.h"
#import "ShoutListCell.h"

#define CELL_REUSE_ID @"ShoutListCell"
#define TAG_ICON 10
#define TAG_LABEL 20
#define TAG_AGE 30

@implementation ListeningDataSource

@synthesize controller;
@synthesize shouts;

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
    [controller release];
    [shouts release];
    [super dealloc];
}

- (id) init {
    [super init];
    defaultPersonIcon = [UIImage imageNamed:@"DefaultPersonIcon.png"];
    messageFont = [UIFont systemFontOfSize: LABEL_FONT_SIZE];
    ageFont = [UIFont systemFontOfSize: AGE_FONT_SIZE];
    return self;
}

+ (ListeningDataSource *) initWithManager:(ShoutManager *)manager controller:(ListeningViewController *)controller{
    ListeningDataSource *source = [[ListeningDataSource alloc] init];
    [source setController: controller];
    [manager setDelegate: source];
    return source;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    // Add one for the "refresh" cell
    return [shouts count]+1;
}

- (Shout *) getShoutForRow:(NSUInteger)row {
    Shout *shout = nil;
    //NSLog(@"Requested row: %u ; shout count: %u", row, [shouts count]);
    if ((row > 0) && (row <= [shouts count])) {
        shout = [shouts objectAtIndex:(row-1)];
    } else {
        NSLog(@"Oops! Requested row %u, but shout count is %u.", row, [shouts count]);
    }
    //NSLog(@"getShoutForRow %u = %@", row, shout);
    return shout;
}

//- (void) setIcon:(UIImage *)shoutIcon forCell:(UITableViewCell *)cell  {
// Add icon
//    UIImage *icon;
//    if (shoutIcon != nil) {
//        icon = shoutIcon;
//    } else {
//        icon = defaultPersonIcon;
//    }
//    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:TAG_ICON];
//    if (imageView == nil) {
//        imageView = [[UIImageView alloc] init];
//        imageView.tag = TAG_ICON;
//        imageView.frame = CGRectMake(SHOUTCELL_MARGIN_HORIZONTAL, SHOUTCELL_MARGIN_VERTICAL, ICON_WIDTH, ICON_HEIGHT);
//        [cell.contentView addSubview:imageView];
//    }
//    imageView.image = icon;
//}

- (NSString *) textForShout: (Shout *) shout  {
    if (shout == nil) {
        NSLog(@"WTF, passing nil to textForShout?!");
        return @"WTF";
    }
    NSString *username = shout.username;
    NSString *placeName = shout.placeName;
    NSString *shoutText = [NSString stringWithFormat:@"%@ shouted from %@", username, placeName];
    if (shout.message != nil) {
        shoutText = [shoutText stringByAppendingFormat:@":\n%@", shout.message];
    }
    return shoutText;
}

- (NSUInteger) shoutRowForIndexPath:(NSIndexPath *) indexPath {
    NSUInteger shoutIndex = [indexPath indexAtPosition:([indexPath length]-1)];
    return shoutIndex;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"ListeningDataSource cellForRowAtIndexPath: %@", indexPath);
    NSUInteger shoutIndex = [self shoutRowForIndexPath:indexPath];
    if (shoutIndex == 0) {
        return [controller refreshButtonCell];
    }

    ShoutListCell *cell = (ShoutListCell *)[tableView dequeueReusableCellWithIdentifier: CELL_REUSE_ID];
    if (cell == nil) {
        cell = [[[ShoutListCell alloc] initWithFrame: CGRectZero reuseIdentifier: CELL_REUSE_ID] autorelease];
    }
    Shout *shout = [self getShoutForRow:shoutIndex];
    [cell setShout: shout];
    CGFloat myWidth = [tableView bounds].size.width - (ICON_WIDTH + (SHOUTCELL_MARGIN_HORIZONTAL * 2));
    // Set icon
    //    [self setIcon:shout.icon forCell:cell];
    NSString *ageText = [shout relativeShoutTime];
    //NSLog(@"   - myWidth: %f", myWidth);
    NSString *shoutText = [self textForShout: shout];
    CGSize shoutLabelSize = [shoutText sizeWithFont: messageFont forWidth: myWidth lineBreakMode: UILineBreakModeWordWrap];
    //NSLog(@"   - shoutLabelSize.width: %f", shoutLabelSize.width);
    //NSLog(@"   - shoutLabelSize.height: %f", shoutLabelSize.height);
    UILabel *shoutLabel = (UILabel*)[cell.contentView viewWithTag: TAG_LABEL];
    [shoutLabel setBounds:CGRectMake(0, 0, myWidth, shoutLabelSize.height)];
    [shoutLabel setText: shoutText];
    //[ageLabel setBounds
    [(UILabel*)[cell.contentView viewWithTag: TAG_AGE] setText: ageText];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"ListeningDataSource tableView:%@ heightForRowAtIndexPath:%@", tableView, indexPath);
    CGFloat result = CELL_HEIGHT_MIN;
    NSUInteger shoutIndex = [self shoutRowForIndexPath:indexPath];
    //NSLog(@"shoutIndex: %d", shoutIndex);
    if (shoutIndex != 0) {
        Shout *shout = [self getShoutForRow:shoutIndex];
        result = [ShoutListCell heightForShout:shout];
    } else {
        result = [controller refreshButtonCell].bounds.size.height;
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"ListeningDataSource :: tableView:%@ didSelectRowAtIndexPath:%@", tableView, newIndexPath);
    ShizzupAppDelegate *delegate = [ShizzupAppDelegate singleton];
    NSLog(@"   - delegate: %@", delegate);
    NSUInteger shoutIndex = [self shoutRowForIndexPath: newIndexPath];
    if (shoutIndex == 0) {
        //NSLog(@"   - TODO: refresh list.");
        [controller refreshShoutList];
        [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
    } else {
        Shout *shout = [self getShoutForRow:shoutIndex];
        NSLog(@"   - shout: %@", shout);
        NSLog(@"   - shout.placeName: %@", shout.placeName);
        NSLog(@"   - shout.message: %@", shout.message);
        [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
        [delegate enterShoutDetailView:shout];
    }
}

- (void) managerLoadedShouts:(NSArray *)newShouts {
    NSLog(@"ListeningDataSource managerLoadedShouts");
    NSLog(@"  - thread: %@", [NSThread currentThread]);
    [newShouts retain];
    [self setShouts:newShouts];
    [self performSelectorInBackground:@selector(updateIcons) withObject:nil];
    //[NSThread detachNewThreadSelector:@selector(myThreadMainMethod:) toTarget:self withObject:nil];
    [controller dataLoaded: newShouts];
}


- (void) updateIcons {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"ListeningViewController updateIcons");
    NSLog(@"  - sleeping 1 second");
    sleep(1);
    NSThread *thread = [NSThread currentThread];
    NSLog(@"  - thread: %@", thread);
    for (Shout *shout in shouts) {
        //CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        //UIImage *icon =
        [shout icon];
        //CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
        //NSLog(@"  - user: %@; place:%@; icon load time: %f", [shout username], [shout placeName], (endTime - startTime));
    }
    [pool release];
}

@end
