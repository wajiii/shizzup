//
//  ShoutListReceiver.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/10.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutListReceiver.h"

#import "MREntitiesConverter.h"
#import "ShizzowApiConnection.h"
#import "ShizzupAppDelegate.h"
#import "Shout.h"

@implementation ShoutListReceiver

@synthesize delegate;

- (id) initWithManager:(ShoutManager *)shoutManager {
    manager = shoutManager;
    return self;
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
        //NSLog(@"Cancelling authentication attempt after %d failures.", failureCount);
        [appDelegate updateCredentialsWithMessage:@"Please log in to Shizzow."];
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
    //NSLog(@"   - responseText: %@", responseText);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"ShoutManager:connectionDidFinishLoading connection:%@ responseText:\n%@", connection, responseText);
    NSLog(@"ShoutManager:connectionDidFinishLoading connection: %@", connection);
    //NSLog(@"                                      responseText: %@", responseText);
    NSString *filteredResponseText = [[[MREntitiesConverter alloc] init] convertEntitiesInString: responseText];
    //NSLog(@"                              filteredResponseText: %@", filteredResponseText);
    CFAbsoluteTime jsonStart = CFAbsoluteTimeGetCurrent();
    NSDictionary *responseDictionary = [filteredResponseText JSONValue];
    CFAbsoluteTime jsonEnd = CFAbsoluteTimeGetCurrent();
    NSLog(@"   - jsonStart: %f", jsonStart);
    NSLog(@"   - jsonEnd  : %f", jsonEnd);
    NSLog(@"   - jsonDelta: %f", (jsonEnd - jsonStart));
    //NSLog(@"responseDictionary: %@: %@", [responseDictionary class], responseDictionary);
    NSDictionary *results = [responseDictionary valueForKey:@"results"];
    //NSLog(@"results: %@: %@", [results class], results);
    NSArray *shoutArray = [results valueForKey:@"shouts"];
    //NSLog(@"   - shoutArray: %@: %@", [shoutArray class], shoutArray);
    NSMutableArray *newShouts = [[[NSMutableArray alloc] init] retain];
    if ([[results valueForKey:@"count"] integerValue] < 1) {
        NSLog(@"   - Uh-oh, results.count is zero!");
    } else if (shoutArray == nil) {
        NSLog(@"   - Uh-oh, shoutArray is nil!");
    } else {
        for (int i = 0; i < [shoutArray count]; i++) {
            NSDictionary *shoutDict = [shoutArray objectAtIndex:i];
            Shout *shout = [Shout initWithDict: shoutDict fromManager: manager];
            [newShouts addObject:[shout retain]];
        }
        NSLog(@"   - finished parsing shouts.");
    }
    [delegate managerLoadedShouts: newShouts];
    //api = nil;
}

@end
