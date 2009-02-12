//
//  ListeningViewController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/10.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMMapView.h>

@interface ListeningViewController : UIViewController <RMMapViewDelegate> {
    RMMapView *mapView;
}

@end
