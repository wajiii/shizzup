//
//  ShizzupAppDelegate.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMMapView.h>

@class LoginController;
@class Shout;

@interface ShizzupAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UINavigationController *navController;
    LoginController *loginController;
    UITabBarController *mainTabBarController;
    BOOL hasCredentials;
    NSString *username;
    NSString *password;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet LoginController *loginController;
@property (nonatomic, retain) IBOutlet UITabBarController *mainTabBarController;
@property (nonatomic, retain) IBOutlet NSString *username;
@property (nonatomic, retain) IBOutlet NSString *password;

+ (id) singleton;

- (void) handleCrashReport;
- (BOOL) hasCredentials;
- (id) updateCredentials;
- (id) updateCredentialsWithMessage:(NSString *)message;
- (IBAction) usernameChanged:(id)sender;
- (IBAction) passwordChanged:(id)sender;
- (void) retrieveCredentials;
- (IBAction) enterShoutView;
- (IBAction) enterShoutDetailView:(Shout *)shout;
- (IBAction) exitCurrentView;
- (IBAction) exitToMainView;

@end
