//
//  ShoutMessageController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/09.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutMessageController.h"

#import "ShoutManager.h"

@implementation ShoutMessageController

@synthesize place;
@synthesize placeName;
//@synthesize placePhone;
@synthesize placeAddress;
@synthesize message;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"ShoutMessageController viewWillAppear");
    [super viewWillAppear:animated];
    NSLog(@"   - place: %@", place);
    NSLog(@"   - place.name: %@", [place name]);
    [placeName setText:[place name]];
    //NSLog(@"   - place.phone: %@", [place phone]);
    //[placePhone setText:[place phone]];
    NSLog(@"   - place.address1: %@", [place address1]);
    NSLog(@"   - place.address2: %@", [place address2]);
    NSString *address1 = [place address1];
    NSString *address2 = [place address2];
    NSString *address = [NSString stringWithFormat:@"%@", address1];
    if ([place address2] != nil) {
        address = [address stringByAppendingFormat:@"\n%@", address2];
    }
    [placeAddress setText:address];
    [message setText:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction) doShout {
    NSLog(@"ShoutMessageController doShout");
    NSLog(@"   - place.name: %@", [place key]);
    NSLog(@"   - place.key: %@", [place key]);
    NSLog(@"   - message: %@", [message text]);
    ShoutManager *manager = [[ShoutManager alloc] init];
    [manager sendShoutFromPlace:[place key] withMessage:[message text]];
    [(UINavigationController *)[self parentViewController] popToRootViewControllerAnimated:YES];
}

@end
