//
//  Shouts.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/03.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutManager.h"
#import "Shout.h"
#import "ShizzowConstants.h"

@implementation ShoutManager

@synthesize limit;

- (Shout *) createShout:(long)shoutId {
    Shout *dummy = [Shout alloc];
    dummy.shoutId = shoutId;
    dummy.message = [NSString stringWithFormat:@"Hello, Shizzow!  %u: Someone-or-other shouted from such-and-such a place a certain amount of time ago.", shoutId];
    NSLog([NSString stringWithFormat:@"Shout %u: %@", dummy.shoutId, dummy.message]);
    return dummy;
}

- (NSArray*) getList {
    NSString *apiUrlString = [NSString stringWithFormat:@"%@%@", SHIZZOW_API_URL_PREFIX, SHIZZOW_API_PATH_SHOUTS];
    NSLog(@"   apiUrlString: %@", apiUrlString);
    
    NSURL *apiUrl = [NSURL URLWithString:apiUrlString];
    NSLog(@"         apiUrl: %@", apiUrl);
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:TEMP_USERNAME password:TEMP_PASSWORD persistence:NSURLCredentialPersistenceNone];
    NSLog(@"     credential: %@", credential);
    
    NSURLProtectionSpace *protectionSpace = [NSURLProtectionSpace alloc];
    NSString *host = [apiUrl host];
    NSInteger port = [[apiUrl port] integerValue];
    NSString *scheme = [apiUrl scheme];
    [protectionSpace initWithHost:host port:port protocol:scheme realm:nil authenticationMethod:nil];
    NSLog(@"protectionSpace: %@", protectionSpace);
    
    NSURLCredentialStorage *credStore = [NSURLCredentialStorage sharedCredentialStorage];
    [credStore setDefaultCredential:credential forProtectionSpace:protectionSpace];
    //[credStore saveOptions];
    NSLog(@"      credStore: %@", credStore);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiUrl];
    NSLog(@"        request: %@", request);
    
    // TODO: Find a better way around this!  Perhaps user should be prompted, a la Safari's invalid-certificate handling.
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[apiUrl host]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    NSLog(@"     connection: %@", connection);
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    Shout *dummy = [self createShout:1];
    [list addObject:dummy];
    dummy = [self createShout:2];
    [list addObject:dummy];
    dummy = [self createShout:3];
    [list addObject:dummy];
    dummy = [self createShout:4];
    [list addObject:dummy];
    dummy = [self createShout:5];
    dummy.icon = [UIImage imageNamed:@"DefaultPersonIcon.png"];
    [list addObject:dummy];
    return list;
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSInteger failureCount = [challenge previousFailureCount];
    NSLog(@"ShoutManager:didRecieveAuthenticationChallenge; previous failure count: %d", failureCount);
    if (failureCount == 0) {
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:TEMP_USERNAME
                                                                    password:TEMP_PASSWORD
                                                                 persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        NSLog(@"Trying credential %@...", newCredential);
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password in the preferences are incorrect
        //[self showPreferencesCredentialsAreIncorrectPanel:self];
        NSLog(@"Cancelling authentication attempt after %d failures.", failureCount);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"ShoutManager:didReceiveResponse connection:%@ response:%@", connection, response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"ShoutManager:didReceiveData connection:%@ data.length:%u", connection, [data length]);
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (responseText == nil) {
        responseText = dataString;
    } else  {
        [responseText stringByAppendingString:dataString];
    }
    NSLog(@"responseText length: %d", [responseText length]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"ShoutManager:connectionDidFinishLoading connection:%@ responseText:\n%@", connection, responseText);
}

@end

// This lets us bypass the certificate error on the API server:
//@implementation NSURLRequest(DataController)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
//	return YES;
//}
//@end
