//
//  ShizzupAppDelegate.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import "ShizzupAppDelegate.h"

#import <CrashReporter/CrashReporter.h>
#import <dlfcn.h>
#import <execinfo.h>

#import "LoginController.h"
#import "Shout.h"
#import "ShoutDetailController.h"
#import "ShoutPlaceController.h"
#import "IconCache.h"

#define PREFKEY_USERNAME @"net.waj3.shizzup.accounts.1.username"
#define PREFKEY_PASSWORD @"net.waj3.shizzup.accounts.1.password"

@implementation ShizzupAppDelegate

id APP_DELEGATE;

@synthesize window;
@synthesize navController;
@synthesize loginController;
@synthesize mainTabBarController;
@synthesize username;
@synthesize password;

- (void)dealloc {
    [username release];
    [password release];
    [mainTabBarController release];
    [loginController release];
	[navController release];
    [window release];
    [super dealloc];
}

+ (id) singleton {
    return APP_DELEGATE;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    APP_DELEGATE = self;
    [[NSThread currentThread] setName:@"Shizzup.main"];

//    IconCache *iconCache = [[IconCache alloc] init];
//    NSLog(@"Icon for http://people.shizzow.com/bettse_48.jpg: %@", [iconCache iconForAddress:@"http://people.shizzow.com/bettse_48.jpg"]);
//    [iconCache release];
//    return;

    // Attempt to load saved credentials
    [self retrieveCredentials];

    // Crash reporting stuff
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    // Check if we previously crashed
    if ([crashReporter hasPendingCrashReport]) {
        [self handleCrashReport];
    }
    // Enable the Crash Reporter
    NSError *error;
    if (![crashReporter enableCrashReporterAndReturnError: &error]) {
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
    }

	// Configure and show the window
    [window addSubview:navController.view];
	[window makeKeyAndVisible];
}

//
// Called to handle a pending crash report.
//
- (void) handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;

    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
    } else {
        // We could send the report from here, but we'll just print out
        // some debugging info instead
        PLCrashReport *report = [[[PLCrashReport alloc] initWithData: crashData error: &error] autorelease];
        if (report == nil) {
            NSLog(@"Could not parse crash report");
        } else {
            NSLog(@"Crashed on %@", report.systemInfo.timestamp);
            NSLog(@"   - Signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name, report.signalInfo.code, report.signalInfo.address);
            NSLog(@"   - Exception: %@: %@", report.exceptionInfo.exceptionName, report.exceptionInfo.exceptionReason);
            int i = 0;
            for (PLCrashReportThreadInfo *reportThread in report.threads) {
                NSLog(@"   - Thread %d: %@", i, reportThread);
                NSLog(@"      - Crashed: %d", reportThread.crashed);
                NSString *frameList = [[[NSString alloc] init] autorelease];
                for (PLCrashReportStackFrameInfo *frame in reportThread.stackFrames) {
                    frameList = [frameList stringByAppendingFormat:@",\n    %u", frame.instructionPointer];
                }
                NSLog(@"      - Stack (%u frames):%@\n\n", [reportThread.stackFrames count], frameList);
                i++;
            }
            //NSLog(@"JSON crash data: %@", [report JSONRepresentation]);
        }
    }

    // Purge the report
    //[crashReporter purgePendingCrashReport];
    return;
}

- (IBAction) usernameChanged:(id)sender {
    username = [sender text];
    NSLog(@"ShizzupAppDelegate usernameChanged: %@", username);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:PREFKEY_USERNAME];
}

- (IBAction) passwordChanged:(id)sender {
    password = [sender text];
    //NSLog(@"ShizzupAppDelegate passwordChanged: %@", password);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:PREFKEY_PASSWORD];
}

- (BOOL) hasCredentials {
    BOOL result = YES;
    if (username == nil) {
        result = NO;
    }
    if (password == nil) {
        result = NO;
    }
    //NSLog(@"ShizzupAppDelegate hasCredentials returning: %u", result);
    return result;
}

- (id) updateCredentials {
    //NSLog(@"ShizzupAppDelegate updateCredentials");
    [self updateCredentialsWithMessage:@"Welcome!"];
    return self;
}

- (id) updateCredentialsWithMessage:(NSString *)message {
    //NSLog(@"ShizzupAppDelegate updateCredentialsWithMessage");
    @synchronized(self) {
        //NSLog(@"ShizzupAppDelegate updateCredentials - synchronized");
        //if (![self hasCredentials]){
        //NSLog(@"ShizzupAppDelegate updateCredentials - ! hasCredentials");
        [loginController setMessage: message];
        [navController pushViewController:loginController animated:YES];
        //}
    }
    return self;
}

- (void) retrieveCredentials {
    NSLog(@"ShizzupAppDelegate retrieveCredentials");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog(@"   - defaults: %@", defaults);
    //NSLog(@"   - [defaults dictionaryRepresentation]: %@", [defaults dictionaryRepresentation]);
    username = [defaults stringForKey:PREFKEY_USERNAME];
    NSLog(@"   - username: %@", username);
    password = [defaults stringForKey:PREFKEY_PASSWORD];
    NSLog(@"   - password: %@", password);
}

- (IBAction) enterShoutView {
    NSLog(@"ShizzupAppDelegate enterShoutView");
    ShoutPlaceController *shoutPlaceController = [ShoutPlaceController alloc];
    [shoutPlaceController initWithNibName:@"ShoutPlace" bundle:nil];
    [navController pushViewController:shoutPlaceController animated:YES];
    [shoutPlaceController release];
}

- (IBAction) enterShoutDetailView:(Shout *)shout {
    NSLog(@"ShizzupAppDelgate enterShoutDetailView");
    ShoutDetailController *shoutDetailController = [ShoutDetailController alloc];
    [shoutDetailController initWithNibName:@"ShoutDetail" bundle:nil];
    [shoutDetailController setShout:shout];
    [navController pushViewController:shoutDetailController animated:YES];
    [shoutDetailController release];
}

- (IBAction) exitCurrentView {
    NSLog(@"ShizzupAppDelegate exitShoutView");
    [navController popViewControllerAnimated:YES];
}

- (IBAction) exitToMainView {
    NSLog(@"ShizzupAppDelegate exitToMainView");
    [navController popToRootViewControllerAnimated:YES];
}

@end
