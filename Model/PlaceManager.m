//
//  PlaceManager.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import "PlaceManager.h"
#import "ShizzowConstants.h"
#import "ShizzowApiConnection.h"

@implementation PlaceManager

@synthesize center;
@synthesize delegate;

- (id) init {
    [super init];
    center = [[CLLocation alloc] initWithLatitude:45.515963 longitude:-122.656525];
    return self;
}

- (void) findPlaces {
    NSLog(@"PlaceManager findPlaces: %@", self);
    NSString *apiUriStub = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&radius=%f&radiusUnit=%@&limit=%d", SHIZZOW_API_PATH_PLACES, center.coordinate.latitude, center.coordinate.longitude, SHIZZOW_API_PLACES_RADIUS_DEFAULT, SHIZZOW_API_PLACES_RADIUSUNIT_DEFAULT, SHIZZOW_API_PLACES_LIMIT_DEFAULT];
    NSLog(@"   apiUriStub: %@", apiUriStub);
    
    ShizzowApiConnection *api = [[ShizzowApiConnection alloc] init];
    [api callUri:apiUriStub delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"PlaceManager didReceiveAuthenticationChallenge: %@, %@", connection, challenge);
    NSInteger failureCount = [challenge previousFailureCount];
    NSLog(@"   - failure count: %d", failureCount);
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
    NSLog(@"PlaceManager didReceiveResponse connection:%@ response:%@", connection, response);
    NSLog(@"   - URL: %@", [response URL]);
    NSLog(@"   - MIMEType: %@", [response MIMEType]);
    NSLog(@"   - expectedContentLength: %d", [response expectedContentLength]);
    NSLog(@"   - textEncodingName: %@", [response textEncodingName]);
    NSLog(@"   - suggestedFilename: %@", [response suggestedFilename]);
    BOOL responseIsHttp = [response isKindOfClass:[NSHTTPURLResponse class]];
    NSLog(@"   - response is NSHTTPURLResponse: %d", responseIsHttp);
    if (responseIsHttp) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSInteger status = [httpResponse statusCode];
        NSLog(@"   - statusCode: %d", status);
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
    if (responseText == nil) {
        responseText = dataString;
    } else  {
        [responseText stringByAppendingString:dataString];
    }
    //    NSLog(@"responseText length: %d", [responseText length]);
    //    [super connection:connection didReceiveData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //    NSLog(@"PlaceManager:connectionDidFinishLoading connection: %@", connection);
    NSDictionary *responseDictionary = [responseText JSONValue];
    //    NSLog(@"   - responseDictionary: %@: %@", [responseDictionary class], responseDictionary);
    NSDictionary *results = [responseDictionary valueForKey:@"results"];
    //    NSLog(@"   - results: %@: %@", [results class], results);
    NSArray *placeArray = [results valueForKey:@"places"];
    //    NSLog(@"   - placeArray: %@: %@", [placeArray class], placeArray);
    NSMutableArray *places = [[NSMutableArray alloc] init];
    for (int i = 0; i < [placeArray count]; i++) {
        NSDictionary *placeDict = [placeArray objectAtIndex:i];
        //        NSLog(@"      - placeDict: %@: %@", [placeDict class], placeDict);
        Place *place = [Place alloc];
        [place initFromDict:placeDict];
        [places addObject:place];
    }
    [delegate managerLoadedPlaces:places];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"PlaceManager didFailWithError: %@, %@", connection, error);
    [delegate placeManager:self loadError:error];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [delegate placeManager:self loadError:nil];
}

@end
