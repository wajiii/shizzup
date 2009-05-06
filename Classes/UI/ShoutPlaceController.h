//
//  ShoutPlaceController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import <CoreLocation/CLLocationManagerDelegate.h>
#import <RMMapView.h>
#import <UIKit/UIKit.h>
#import "PlaceManager.h"

@class Place;

@interface ShoutPlaceController : UIViewController <CLLocationManagerDelegate> {
    PlaceManager *placeManager;
    UILabel *locationLabel;
    CLLocation *nextLocation;
    UIActivityIndicatorView *spinnerView;
    UITableView *tableView;
    RMMapView *mapView;
    BOOL updating;
}

@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinnerView;
@property (nonatomic, retain) IBOutlet RMMapView *mapView;

- (void) dataLoaded;
- (IBAction) exitShoutView;
- (IBAction) refreshLocation;
- (void) updateLocation;
- (void) userSelectedPlace:(Place *)place;

@end
