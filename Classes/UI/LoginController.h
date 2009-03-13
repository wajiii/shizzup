//
//  LoginController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShizzupAppDelegate.h"

@interface LoginController : UIViewController {
    ShizzupAppDelegate *appDelegate;
    IBOutlet UILabel *messageLabel;
}

@property (nonatomic, retain) IBOutlet ShizzupAppDelegate *appDelegate;
@property (nonatomic, retain) NSString *message;

- (IBAction) login:(id)sender;

@end
