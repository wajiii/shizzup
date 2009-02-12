//
//  MapViewController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/10.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMMapView.h>

@interface MapViewController : UIViewController <RMMapViewDelegate> {
    RMMapView *mapView;
}

@property (nonatomic, retain) IBOutlet RMMapView *mapView;

@end
