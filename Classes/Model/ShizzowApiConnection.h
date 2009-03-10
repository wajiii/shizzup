//
//  ShizzowApiConnection.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/08.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShizzowApiConnection : NSURLConnection {
    NSURLConnection *connection;
}

- (NSURLConnection *) callUri:(NSString *)apiUriStub delegate:(id)delegate;
- (NSURLConnection *) callUri:(NSString *)apiUriStub usingMethod:(NSString *)method withDelegate:(id)delegate withBody:(NSString *)body;
- (void) abort;

@end
