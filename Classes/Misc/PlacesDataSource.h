//
//  PlacesDataSource.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/09.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceManager.h"
#import "ShoutPlaceController.h"

@interface PlacesDataSource : NSObject <PlaceManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    ShoutPlaceController *controller;
    NSArray *places;
}

@property (nonatomic, retain) ShoutPlaceController *controller;

+ (PlacesDataSource *) initWithManager:(PlaceManager *)manager controller:(ShoutPlaceController *)controller;

@end
