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

@implementation ShizzupAppDelegate

@synthesize window;
@synthesize navController;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    //[window addSubview:tabBarController.view];
    [window addSubview:navController.view];

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
                NSString *frameList = [[NSString alloc] init];
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

/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end
