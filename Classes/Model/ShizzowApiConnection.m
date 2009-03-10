//
//  ShizzowApiConnection.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShizzowApiConnection.h"
#import "ShizzupConstants.h"

@implementation ShizzowApiConnection

- (NSURLConnection *) callUri:(NSString *)apiUriStub delegate:(id)delegate {
    return [self calUri:apiUriStub usingMethod:@"GET" withDelegate:delegate withBody:nil];
}

- (NSURLConnection *) callUri:(NSString *)apiUriStub usingMethod:(NSString *)method withDelegate:(id)delegate withBody:(NSString *)body {
    NSLog(@"   apiUriStub: %@", apiUriStub);
    
    NSString *apiUrlString = [NSString stringWithFormat:@"%@%@", SHIZZOW_API_URL_PREFIX, apiUriStub];
    NSLog(@"   apiUrlString: %@", apiUrlString);
    
    NSURL *apiUrl = [NSURL URLWithString:apiUrlString];
    NSLog(@"         apiUrl: %@", apiUrl);
    
    NSURLProtectionSpace *protectionSpace = [NSURLProtectionSpace alloc];
    NSString *host = [apiUrl host];
    NSInteger port = [[apiUrl port] integerValue];
    NSString *scheme = [apiUrl scheme];
    [protectionSpace initWithHost:host port:port protocol:scheme realm:nil authenticationMethod:nil];
    NSLog(@"protectionSpace: %@", protectionSpace);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: apiUrl];
    [request setHTTPMethod: method];
    NSLog(@"   - method: %@", method);
    if ([@"PUT" caseInsensitiveCompare: method] ==  NSOrderedSame) {
        NSLog(@"     - setting Content-Type to application/x-www-form-urlencoded");
        // Needed for put, per http://iphonedevelopment.blogspot.com/2008/06/http-put-and-nsmutableurlrequest.html
        //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        if (body != nil) {
            NSData *putData = [body dataUsingEncoding: NSUTF8StringEncoding];
            NSLog(@"     - setting HTTP body to: %@", putData);
            [request setHTTPBody: putData];
        }
    }
    NSLog(@"        request: %@", request);
    
    // TODO: Find a better way around this!  Would be ideal to detect the problem, prompt user before continuing, and allow only for the appropriate request; a la Safari's invalid-certificate handling.
    @try {
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[apiUrl host]];
    }
    @catch (NSException * e) {
        NSLog(@"Error attempting to override certificate handling; API calls will probably fail.\nException %@ (%@): %@", [e class], [e name], [e description]);
    }

    connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
    NSLog(@"     connection: %@", connection);
    
    return connection;
}

- (void) abort {
    [connection cancel];
}

@end
