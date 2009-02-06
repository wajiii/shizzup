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
#import "ImageManipulator.h"

@implementation ShoutManager

@synthesize limit;
@synthesize callback;

- (id) init {
    [super init];
    remoteImageCache = [NSDictionary alloc];
    return self;
}

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
    NSLog(@"      credStore: %@", credStore);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiUrl];
    NSLog(@"        request: %@", request);
    
    // TODO: Find a better way around this!  Perhaps user should be prompted, a la Safari's invalid-certificate handling.
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[apiUrl host]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    NSLog(@"     connection: %@", connection);
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
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

- (UIImage *) getImageFromUrl:(NSURL *) url {
    NSString *cacheKey = [url absoluteString];
    UIImage *image = [remoteImageCache objectForKey:cacheKey];
    if (image == nil) {
        NSLog(@"iconCache miss for key %@", cacheKey);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:imageData];
        [remoteImageCache setValue:image forKey:cacheKey];
    } else {
        NSLog(@"iconCache hit for key %@", cacheKey);
    }
    return image;
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
    NSMutableArray *newShouts = [[NSMutableArray alloc] init];
    for (int i = 0; i < [shoutArray count]; i++) {
        NSDictionary *shout = [shoutArray objectAtIndex:i];
        NSLog(@"shout: %@: %@", [shout class], shout);
        NSString *shoutId = [shout valueForKey:@"shouts_history_id"];
        NSLog(@"   shoutId: %@: %@", [shoutId class], shoutId);
        id username = [shout valueForKey:@"people_name"];
        NSLog(@"  username: %@: %@", [username class], username);
        NSString *placeName = [shout valueForKey:@"places_name"];
        NSLog(@"   placeName: %@: %@", [placeName class], placeName);
        NSString *relativeShoutTime = [shout valueForKey:@"shout_time"];
        NSLog(@"relativeShoutTime: %@: %@", [relativeShoutTime class], relativeShoutTime);
        NSDictionary *iconAddresses = [shout valueForKey:@"people_images"];
        NSLog(@"   iconAddresses: %@: %@", [iconAddresses class], placeName);
        NSString *iconAddress = [iconAddresses valueForKey:@"people_image_48"];
        NSLog(@"   iconAddress: %@: %@", [iconAddress class], iconAddress);
        UIImage *roundedIcon;
        if ([iconAddress compare:@"/images/people/people_48.jpg"] == 0) {
            roundedIcon = nil;
        } else {
            NSURL *iconUrl = [NSURL URLWithString:iconAddress];
            UIImage *icon = [self getImageFromUrl:iconUrl];
            roundedIcon = [ImageManipulator makeRoundCornerImage:icon :ICON_CORNER_WIDTH :ICON_CORNER_HEIGHT];
        }
        Shout *newShout = [Shout alloc];
        newShout.shoutId = [shoutId integerValue];
        newShout.username = username;
        newShout.relativeShoutTime = relativeShoutTime;
        newShout.placeName = placeName;
        newShout.message = [NSString stringWithFormat:@"%s - %s - %s", username, placeName, relativeShoutTime];
        newShout.icon = roundedIcon;
        [newShouts addObject:newShout];
    }
    [callback managerLoadedShouts:newShouts];
}

@end

// This lets us bypass the certificate error on the API server:
//@implementation NSURLRequest(DataController)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
//	return YES;
//}
//@end
