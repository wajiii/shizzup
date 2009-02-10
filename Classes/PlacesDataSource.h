//
//  PlacesDataSource.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/09.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceManager.h"
#import "ShoutViewController.h"

@interface PlacesDataSource : NSObject <PlaceManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    ShoutViewController *controller;
    NSArray *places;
}

@property (nonatomic, retain) ShoutViewController *controller;

+ (PlacesDataSource *) initWithManager:(PlaceManager *)manager controller:(ShoutViewController *)controller;

@end
