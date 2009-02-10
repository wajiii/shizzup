//
//  MainNavController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import "MainNavController.h"

@implementation MainNavController

//@synthesize shoutViewController;

- (IBAction) pushShoutView {
    if (shoutViewController == nil)
    {
        shoutViewController = [ShoutViewController alloc];
        [shoutViewController initWithNibName:@"ShoutView" bundle:nil];
    }
    [self pushViewController:shoutViewController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"MainNavController viewDidAppear:%@", animated);
    [self pushShoutView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end
