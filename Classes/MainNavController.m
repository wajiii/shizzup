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

- (IBAction) enterShoutView {
    if (shoutViewController == nil)
    {
        shoutViewController = [ShoutViewController alloc];
        [shoutViewController initWithNibName:@"ShoutView" bundle:nil];
    }
    [self pushViewController:shoutViewController animated:YES];
}

- (IBAction) exitShoutView {
    [self popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"MainNavController viewDidAppear:%@", animated);
    //[self enterShoutView];
}

// Notification of rotation beginning.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

// At this point, our view orientation is set to the new orientation.
//- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end
