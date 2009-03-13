//
//  LoginController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "LoginController.h"

@implementation LoginController

@synthesize appDelegate;

- (IBAction) login:(id)sender {
    [appDelegate exitCurrentView];
}

- (NSString *) message {
    return [messageLabel text];
}

- (void) setMessage:(NSString *)message {
    [messageLabel setText:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end
