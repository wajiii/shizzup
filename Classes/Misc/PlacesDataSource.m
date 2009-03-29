//
//  PlacesDataSource.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/09.
//  Copyright 2009 waj3. All rights reserved.
//

#import "PlacesDataSource.h"

#import "ShizzupAppDelegate.h"
#import "ShoutMessageController.h"

#define CELL_REUSE_ID            @"PlaceCell"
#define CELL_HEIGHT_MIN         36.0
#define NAME_FONT_SIZE          16.0
#define NAME_MARGIN_HORIZONTAL   8.0
#define NAME_MARGIN_VERTICAL     4.0
#define DIST_FONT_SIZE          14.0
#define DIST_MARGIN_HORIZONTAL   8.0
#define DIST_MARGIN_VERTICAL     4.0
#define TAG_NAME                10
#define TAG_DISTANCE            20

@implementation PlacesDataSource

@synthesize controller;

+ (PlacesDataSource *) initWithManager:(PlaceManager *)manager controller:(ShoutPlaceController *)controller {
    PlacesDataSource *source = [[PlacesDataSource alloc] init];
    [source setController:controller];
    [manager setDelegate:source];
    return source;
}

NSInteger distanceSort(id place1, id place2, void *context) {
    NSString *v1 = [place1 distance];
    double v1d = [v1 doubleValue];
    //NSLog(@"      - v1: %f, %@, %@", v1d, v1, [place1 places_name]);
    NSString *v2 = [place2 distance];
    double v2d = [v2 doubleValue];
    //NSLog(@"      - v2: %f, %@, %@", v2d, v2, [place2 places_name]);
    if (v1d < v2d)
        return NSOrderedAscending;
    else if (v1d > v2d)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

- (void) managerLoadedPlaces:(NSArray *)newPlaces {
    //NSLog(@"PlacesDataSource managerLoadedPlaces [%d]", [newPlaces count]);
    @synchronized(places) {
        //        places = newPlaces;
        places = [[newPlaces sortedArrayUsingFunction:distanceSort context:nil] retain];
    }
    //NSLog(@"   - places: %@", places);
    [controller dataLoaded];
}

- (void) placeManager:(PlaceManager *) manager loadError:(NSError *) error {
    if (error != nil) {
        NSString *alertTitle = [NSString stringWithFormat:@"Connection Error (%d)", [error code]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:[error description] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
    [controller exitShoutView];
}

- (Place *) getPlaceForIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"PlacesDataSource getPlaceForIndexPath: %@", indexPath);
    NSUInteger lastIndexPosition = [indexPath length] - 1;
    NSUInteger row = [indexPath indexAtPosition:lastIndexPosition];
    //NSLog(@"   - row: %u", row);
    Place *place = nil;
    @synchronized(places) {
        NSUInteger placeCount = [places count];
        //NSLog(@"   - places count: %u", placeCount);
        if ((row >= 0) && (row < placeCount)) {
            place = [places objectAtIndex:row];
        } else {
            NSLog(@"Oops! Requested row %u, but place count is %u.", row, [places count]);
        }
    }
    //NSLog(@"getPlaceForRow %u = %@", row, place);
    return place;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [places count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"PlacesDataSource heightForRowAtIndexPath: %@", indexPath);
    Place *place = [self getPlaceForIndexPath:indexPath];
    CGFloat result = 24;
    if (place != nil) {
        CGFloat tableViewWidth = ([tableView frame].size.width * .75) - (NAME_MARGIN_HORIZONTAL * 2);
        CGSize nameSize = [[place name] sizeWithFont:[UIFont systemFontOfSize:NAME_FONT_SIZE] forWidth:tableViewWidth lineBreakMode:UILineBreakModeWordWrap];
        result = nameSize.height + (NAME_MARGIN_VERTICAL * 2);
    }
    //NSLog(@"   - Place: \"%@\"; height: %f", [place places_name], result);
    if (result < CELL_HEIGHT_MIN) {
        result = CELL_HEIGHT_MIN;
        //NSLog(@"Generated row height was too small; overridden to %5.1f.", result);
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"PlacesDataSource cellForRowAtIndexPath: %@", indexPath);
    Place *place = [self getPlaceForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELL_REUSE_ID];
        
        CGFloat nameX = NAME_MARGIN_HORIZONTAL;
        CGFloat nameY = NAME_MARGIN_VERTICAL;
        CGFloat nameWidth = (cell.contentView.frame.size.width * 0.8) - (NAME_MARGIN_HORIZONTAL * 1.5);
        CGFloat nameHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath] - (NAME_MARGIN_VERTICAL * 2);
        CGRect nameLabelFrame = CGRectMake(nameX, nameY, nameWidth, nameHeight);
        //NSLog(@"   - nameLabelFrame: %1.0fx%1.0f @ %1.0fx%1.0f", nameLabelFrame.size.width, nameLabelFrame.size.height, nameLabelFrame.origin.x, nameLabelFrame.origin.y);
        {
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
            [nameLabel setTag:TAG_NAME];
            [nameLabel setAdjustsFontSizeToFitWidth:YES];
            //            [nameLabel setBackgroundColor:[UIColor lightGrayColor]];
            [nameLabel setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
            [nameLabel setTextAlignment:UITextAlignmentLeft];
            [nameLabel setTextColor:[UIColor blackColor]];
            [nameLabel setFont:[UIFont systemFontOfSize:NAME_FONT_SIZE]];
            [nameLabel setLineBreakMode:UILineBreakModeWordWrap];
            [cell.contentView addSubview:nameLabel];
        }
        CGFloat distX = (cell.contentView.frame.size.width * 0.8) + (DIST_MARGIN_HORIZONTAL / 2);
        CGFloat distY = DIST_MARGIN_VERTICAL;
        CGFloat distWidth = (cell.contentView.frame.size.width * 0.2) - (DIST_MARGIN_HORIZONTAL * 1.5);
        CGRect distLabelFrame = CGRectMake(distX, distY, distWidth, nameHeight);
        //NSLog(@"   - distLabelFrame: %1.0fx%1.0f @ %1.0fx%1.0f", distLabelFrame.size.width, distLabelFrame.size.height, distLabelFrame.origin.x, distLabelFrame.origin.y);
        {
            UILabel *distLabel = [[UILabel alloc] initWithFrame:distLabelFrame];
            [distLabel setTag:TAG_DISTANCE];
            //            [distLabel setBackgroundColor:[UIColor greenColor]];
            [distLabel setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
            [distLabel setTextAlignment:UITextAlignmentRight];
            [distLabel setTextColor:[UIColor blackColor]];
            [distLabel setFont:[UIFont systemFontOfSize:DIST_FONT_SIZE]];
            [distLabel setLineBreakMode:UILineBreakModeWordWrap];
            [cell.contentView addSubview:distLabel];
        }
    }
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:TAG_NAME];
    //NSLog(@"   - nameLabel: %@", nameLabel);
    NSString *nameValue = [place name];
    //NSLog(@"   - nameValue: %@", nameValue);
    if ([place isFavorite]) {
        nameValue = [nameValue stringByAppendingString:@" (favorite)"];
    }
    [nameLabel setText:nameValue];
    
    UILabel *distLabel = (UILabel *)[cell.contentView viewWithTag:TAG_DISTANCE];
    //NSLog(@"   - distLabel: %@", distLabel);
    NSString *distValue = [NSString stringWithFormat:@"%1.0fm", ([[place distance] doubleValue] * 1000)];
    //NSLog(@"   - distValue: %@", distValue);
    [distLabel setText:distValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"PlacesDataSource tableView:%@ didSelectRowAtIndexPath:%@", tableView, newIndexPath);
    Place *place = [self getPlaceForIndexPath: newIndexPath];
    NSLog(@"   - place: %@", place);
    NSLog(@"   - place.name: %@", [place name]);
    NSLog(@"   - place.key: %@", [place key]);
    [controller userSelectedPlace: place];
}

@end
