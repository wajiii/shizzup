//
//  ShoutSendReceiver.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/10.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutSendReceiver.h"

#import "MREntitiesConverter.h"
#import "ShizzupAppDelegate.h"

@implementation ShoutSendReceiver

@synthesize delegate;

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
    [delegate release];
    [super dealloc];
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSInteger failureCount = [challenge previousFailureCount];
    //NSLog(@"ShoutSendReceiver:didRecieveAuthenticationChallenge; previous failure count: %d", failureCount);
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
    NSLog(@"ShoutSendReceiver didReceiveResponse connection:%@ response:%@", connection, response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"ShoutSendReceiver didReceiveData connection:%@ data.length:%u", connection, [data length]);
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (responseText == nil) {
        responseText = dataString;
    } else  {
        responseText = [responseText stringByAppendingString:dataString];
    }
    //NSLog(@"responseText length: %d", [responseText length]);
    //NSLog(@"   - responseText: %@", responseText);
    [dataString release];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"ShoutSendReceiver:connectionDidFinishLoading connection:%@ responseText:\n%@", connection, responseText);
    NSLog(@"ShoutSendReceiver connectionDidFinishLoading connection: %@", connection);
    //NSLog(@"                                      responseText: %@", responseText);
    MREntitiesConverter *converter = [[[MREntitiesConverter alloc] init] autorelease];
    NSString *filteredResponseText = [[converter newConvertEntitiesInString: responseText] autorelease];
    //NSLog(@"                              filteredResponseText: %@", filteredResponseText);
    NSDictionary *responseDictionary = [filteredResponseText JSONValue];
    //NSLog(@"responseDictionary: %@: %@", [responseDictionary class], responseDictionary);
    NSDictionary *results = [responseDictionary valueForKey:@"results"];
    NSLog(@"results: %@: %@", [results class], results);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",results] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
    [alert release];
    //NSArray *shoutArray = [results valueForKey:@"shouts"];
    //NSLog(@"   - shoutArray: %@: %@", [shoutArray class], shoutArray);
    //NSMutableArray *newShouts = [[[NSMutableArray alloc] init] retain];
    //if (shoutArray == nil) {
    //   NSLog(@"   - Uh-oh, shoutArray is nil!");
    //} else {
    //   for (int i = 0; i < [shoutArray count]; i++) {
    //      NSDictionary *shoutDict = [shoutArray objectAtIndex:i];
    //      Shout *shout = [Shout initWithDict: shoutDict fromManager:self];
    //      [newShouts addObject:[shout retain]];
    //   }
    //   NSLog(@"   - finished parsing shouts.");
    //}
    //[delegate managerLoadedShouts: newShouts];
}

@end
