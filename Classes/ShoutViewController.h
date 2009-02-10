//
//  ShoutViewController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "PlaceManager.h"

@interface ShoutViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    PlaceManager *placeManager;
    UILabel *altitudeLabel;
    UILabel *altitudeLabelLabel;
    UILabel *locationLabel;
    UIActivityIndicatorView *spinnerView;
    UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UILabel *altitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *altitudeLabelLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinnerView;

- (void) dataLoaded;

@end
