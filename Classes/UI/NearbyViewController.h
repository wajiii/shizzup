//
//  NearbyViewController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMMapView.h>

@class NearbyDataSource;
@class ShoutManager;

@interface NearbyViewController : UIViewController <CLLocationManagerDelegate, RMMapViewDelegate> {
    RMMapView *mapView;
    NearbyDataSource *nearbyDataSource;
    UIImage *refreshImage;
    ShoutManager *shoutManager;
    UIActivityIndicatorView *spinnerView;
}

@property (nonatomic, retain) IBOutlet UIImage *refreshImage;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinnerView;

- (void) dataLoaded:(NSArray *)shouts;
- (void) refreshShoutList;
- (NSUInteger) updateMarkersWithShouts:(NSArray *)shouts;

@end
