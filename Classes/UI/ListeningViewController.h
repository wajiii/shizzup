//
//  ListeningViewController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMMapView.h>

@class ShoutManager;

@interface ListeningViewController : UIViewController <CLLocationManagerDelegate, RMMapViewDelegate> {
    UITableView *tableView;
    UIActivityIndicatorView *spinnerView;
//    UIBarButtonItem *mapButton;
//    BOOL viewIsMap;
//    UIView *nonMapView;
//    RMMapView *mapView;
    ShoutManager *shoutManager;
    UITableViewCell *refreshButtonCell;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinnerView;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem *mapButton;
@property (nonatomic, retain) IBOutlet UITableViewCell *refreshButtonCell;

- (void) dataLoaded:(NSArray *) shouts;
//- (IBAction) mapButtonPressed;
//- (void) updateMarkersWithShouts:(NSArray *)shouts;
- (void) refreshShoutList;

@end
