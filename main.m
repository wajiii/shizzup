//
//  main.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal;
    @try {
        retVal = UIApplicationMain(argc, argv, nil, nil);
    }
    @catch (NSException * e) {
        NSLog(@"Caught exception: %@ %@\n%@", [e name], [e reason], [e callStackReturnAddresses]);
        @throw e;
    }
    [pool release];
    return retVal;
}

