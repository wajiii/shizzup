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
#import "ShizzupAppDelegate.h"

@implementation ShoutManager

@synthesize limit;
@synthesize delegate;

- (id) init {
    [super init];
    return self;
}

- (void) findShouts {
    NSString *apiUrlString = [NSString stringWithFormat:@"%@%@?limit=%d", SHIZZOW_API_URL_PREFIX, SHIZZOW_API_PATH_SHOUTS, SHIZZOW_API_SHOUTS_LIMIT_DEFAULT];
    //NSLog(@"   apiUrlString: %@", apiUrlString);
    
    NSURL *apiUrl = [NSURL URLWithString:apiUrlString];
    //NSLog(@"         apiUrl: %@", apiUrl);
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:TEMP_USERNAME password:TEMP_PASSWORD persistence:NSURLCredentialPersistenceNone];
    //NSLog(@"     credential: %@", credential);
    
    NSURLProtectionSpace *protectionSpace = [NSURLProtectionSpace alloc];
    NSString *host = [apiUrl host];
    NSInteger port = [[apiUrl port] integerValue];
    NSString *scheme = [apiUrl scheme];
    [protectionSpace initWithHost:host port:port protocol:scheme realm:nil authenticationMethod:nil];
    //NSLog(@"protectionSpace: %@", protectionSpace);
    
    NSURLCredentialStorage *credStore = [NSURLCredentialStorage sharedCredentialStorage];
    [credStore setDefaultCredential:credential forProtectionSpace:protectionSpace];
    //NSLog(@"      credStore: %@", credStore);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiUrl];
    //NSLog(@"        request: %@", request);
    
    // TODO: Find a better way around this!  User should probably be prompted, a la Safari's invalid-certificate handling.
    @try {
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[apiUrl host]];
    }
    @catch (NSException * e) {
        NSLog(@"Error attempting to override certificate handling; API calls will probably fail.\nException %@ (%@): %@", [e class], [e name], [e description]);
    }
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    // Silly hack to avoid "unused variable" warning.
    [connection class];
    //NSLog(@"     connection: %@", connection);
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSInteger failureCount = [challenge previousFailureCount];
    NSLog(@"ShoutManager:didRecieveAuthenticationChallenge; previous failure count: %d", failureCount);
    ShizzupAppDelegate *appDelegate = [ShizzupAppDelegate singleton];
    if (failureCount == 0 && [appDelegate hasCredentials]) {
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:appDelegate.username
                                                                    password:appDelegate.password
                                                                 persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        //NSLog(@"Trying credential %@...", newCredential);
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password in the preferences are incorrect
        //[self showPreferencesCredentialsAreIncorrectPanel:self];
        NSLog(@"Cancelling authentication attempt after %d failures.", failureCount);
        [appDelegate updateCredentials];
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
    //NSLog(@"responseText length: %d", [responseText length]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"ShoutManager:connectionDidFinishLoading connection:%@ responseText:\n%@", connection, responseText);
    NSLog(@"ShoutManager:connectionDidFinishLoading connection: %@", connection);
    //NSLog(@"                                      responseText: %@", responseText);
    NSDictionary *responseDictionary = [responseText JSONValue];
    //NSLog(@"responseDictionary: %@: %@", [responseDictionary class], responseDictionary);
    NSDictionary *results = [responseDictionary valueForKey:@"results"];
    //NSLog(@"results: %@: %@", [results class], results);
    NSArray *shoutArray = [results valueForKey:@"shouts"];
    //NSLog(@"shouts: %@: %@", [shouts class], shouts);
    NSMutableArray *newShouts = [[[NSMutableArray alloc] init] retain];
    for (int i = 0; i < [shoutArray count]; i++) {
        NSDictionary *shoutDict = [shoutArray objectAtIndex:i];
        Shout *shout = [Shout initWithDict:shoutDict fromManager:self];
        [newShouts addObject:[shout retain]];
    }
    [delegate managerLoadedShouts:newShouts];
}

@end

// This lets us bypass the certificate error on the API server:
//@implementation NSURLRequest(DataController)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
//	return YES;
//}
//@end
