//
//  ShizzowApiConnection.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShizzowApiConnection.h"
#import "ShizzowConstants.h"

@implementation ShizzowApiConnection

- (NSURLConnection *) callUri:(NSString *)apiUriStub delegate:(id)delegate {
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
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiUrl];
    NSLog(@"        request: %@", request);
    
    // TODO: Find a better way around this!  Perhaps user could be prompted, a la Safari's invalid-certificate handling.
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
