//
//  MainTabBarController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShizzupAppDelegate.h"
#import "ShoutPlaceController.h"

@interface MainTabBarController : UITabBarController {
    ShoutPlaceController *shoutViewController;
    ShizzupAppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet ShizzupAppDelegate *appDelegate;

- (IBAction) enterShoutView;
- (IBAction) exitShoutView;

@end
