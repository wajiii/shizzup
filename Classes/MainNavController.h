//
//  MainNavController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoutViewController.h"

@interface MainNavController : UINavigationController {
    ShoutViewController *shoutViewController;
}

- (IBAction) enterShoutView;
- (IBAction) exitShoutView;

@end
