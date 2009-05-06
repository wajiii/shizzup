//
//  PlaceListReceiver.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/04/24.
//  Copyright 2009 waj3. All rights reserved.
//

#import "PlaceListReceiver.h"

#import "MREntitiesConverter.h"
#import "Place.h"
#import "PlaceManager.h"
#import "ShizzupAppDelegate.h"


@implementation PlaceListReceiver

@synthesize api;
@synthesize delegate;
@synthesize manager;

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
    [api release];
    [delegate release];
    [manager release];
    [super dealloc];
}

- (id) init {
    responseText = @"";
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //NSLog(@"PlaceListReceiver didReceiveAuthenticationChallenge: %@, %@", connection, challenge);
    NSInteger failureCount = [challenge previousFailureCount];
    //NSLog(@"   - failure count: %d", failureCount);
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
    NSLog(@"PlaceManager didReceiveResponse connection:%@ response:%@", connection, response);
    //NSLog(@"   - URL: %@", [response URL]);
    //NSLog(@"   - MIMEType: %@", [response MIMEType]);
    //NSLog(@"   - expectedContentLength: %d", [response expectedContentLength]);
    //NSLog(@"   - textEncodingName: %@", [response textEncodingName]);
    //NSLog(@"   - suggestedFilename: %@", [response suggestedFilename]);
    BOOL responseIsHttp = [response isKindOfClass:[NSHTTPURLResponse class]];
    //NSLog(@"   - response is NSHTTPURLResponse: %d", responseIsHttp);
    if (responseIsHttp) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSInteger status = [httpResponse statusCode];
        //NSLog(@"   - statusCode: %d", status);
        //...
        if (status >= 400) {
            NSString *alertMessage = [NSString stringWithFormat:@"Received status %d for URL %@", status, [response URL]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PlaceManager" message:alertMessage delegate:nil cancelButtonTitle:@"Alrighty" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    //    [super connection:connection didReceiveResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"PlaceManager didReceiveData connection:%@ data.length:%u", connection, [data length]);
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    responseText = [[responseText stringByAppendingString:dataString] retain];
    NSLog(@"  - responseText length: %u", [responseText length]);
    //    [super connection:connection didReceiveData:data];
    [dataString release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"PlaceManager:connectionDidFinishLoading connection: %@", connection);
    //NSLog(@"                                      responseText: %@", responseText);
    //NSDictionary *responseDictionary = [responseText JSONValue];
    MREntitiesConverter *converter = [[MREntitiesConverter alloc] init];
    NSString *filteredResponseText = [[converter newConvertEntitiesInString: responseText] autorelease];
    [converter release];
    //NSLog(@"                              filteredResponseText: %@", filteredResponseText);
    NSDictionary *responseDictionary = [filteredResponseText JSONValue];
    
    //NSLog(@"   - responseDictionary: %@: %@", [responseDictionary class], responseDictionary);
    NSDictionary *results = [responseDictionary valueForKey:@"results"];
    //NSLog(@"   - results: %@: %@", [results class], results);
    NSArray *placeArray = [results valueForKey:@"places"];
    //NSLog(@"   - placeArray: %@: %@", [placeArray class], placeArray);
    NSMutableArray *places = [[[NSMutableArray alloc] init] autorelease];
    if (placeArray != nil) {
        for (int i = 0; i < [placeArray count]; i++) {
            NSDictionary *placeDict = [placeArray objectAtIndex:i];
            //NSLog(@"      - placeDict: %@: %@", [placeDict class], placeDict);
            Place *place = [Place alloc];
            [place initFromDict:placeDict];
            [places addObject:place];
            [place release];
        }
    }
    if (api != nil) {
        [api release];
        api = nil;
    }
    [delegate managerLoadedPlaces:places];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"PlaceManager didFailWithError: %@, %@", connection, error);
    [delegate placeManager:manager loadError:error];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [delegate placeManager:manager loadError:nil];
}

@end
