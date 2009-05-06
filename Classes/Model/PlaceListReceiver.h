//
//  PlaceListReceiver.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/04/24.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceManager.h"
#import "ShizzowApiConnection.h"

@interface PlaceListReceiver : NSObject {
    ShizzowApiConnection *api;
    id<PlaceManagerDelegate> delegate;
    PlaceManager *manager;
    NSString *responseText;
}

@property(nonatomic, retain) ShizzowApiConnection *api;
@property(nonatomic, retain) PlaceManager *manager;
@property(nonatomic, retain) id<PlaceManagerDelegate> delegate;

@end
