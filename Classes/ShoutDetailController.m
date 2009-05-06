//
//  ShoutDetailController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/29.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutDetailController.h"

@implementation ShoutDetailController

@synthesize iconView;
@synthesize lastModifiedLabel;
@synthesize messages;
@synthesize personHandleLabel;
@synthesize personNameLabel;
@synthesize placeNameLabel;
@synthesize shout;

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"ShoutDetailController viewWillAppear");
    [super viewWillAppear:animated];
    NSLog(@"  - shout: %@", shout);
    NSLog(@"    - placeName: %@", [shout placeName]);
    [iconView setImage:[shout icon]];
    [personNameLabel setText:[shout personFullName]];
    [personHandleLabel setText:[@"@" stringByAppendingString:[shout username]]];
    [placeNameLabel setText:[shout placeName]];
    [lastModifiedLabel setText:[NSString stringWithFormat:@"%@ %@", [shout status], [shout relativeShoutTime]]];
    NSString *messagesText = @"";
    // TODO: Abstract this in the API wrapper
    for (NSDictionary *messageDict in [shout messages]) {
        NSLog(@"  - messageDict: %@", messageDict);
        messagesText = [messagesText stringByAppendingFormat:@"%@:\n%@\n\n", [messageDict objectForKey:@"time"], [messageDict objectForKey:@"message"]];
        NSLog(@"    - messagesText: %@", messagesText);
    }
    [messages setText:messagesText];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [iconView release];
    [lastModifiedLabel release];
    [messages release];
    [personHandleLabel release];
    [personNameLabel release];
    [placeNameLabel release];
    [shout release];
    [super dealloc];
}


@end
