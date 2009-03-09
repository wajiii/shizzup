//
//  MainNavController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import "MainTabBarController.h"

@implementation MainTabBarController

@synthesize appDelegate;

- (void) viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MainTabBarController viewDidLoad");
}

- (IBAction) enterShoutView {
    NSLog(@"MainTabBarController enterShoutView");
    if (shoutViewController == nil) {
        shoutViewController = [ShoutViewController alloc];
        [shoutViewController initWithNibName:@"ShoutView" bundle:nil];
    }
    [appDelegate.navController pushViewController:shoutViewController animated:YES];
}

- (IBAction) exitShoutView {
    NSLog(@"MainTabBarController exitShoutView");
    [appDelegate.navController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"MainTabBarController viewWillAppear");
    UIViewController *view = [self selectedViewController];
    [view viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"MainTabBarController viewDidAppear", animated);
    [[self selectedViewController] viewDidAppear:animated];
    //[self enterShoutView];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"MainTabBarController viewWillDisappear", animated);
    [[self selectedViewController] viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    NSLog(@"MainTabBarController viewDidDisappear", animated);
    [[self selectedViewController] viewDidDisappear:animated];
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
    NSLog(@"MainTabBarController dealloc");
    [super dealloc];
}

@end
