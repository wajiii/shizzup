//
//  ListeningViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/10.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ListeningViewController.h"

#define MAP_LAT_INITIAL     45.515963
#define MAP_LON_INITIAL   -122.656525
#define MAP_SCALE_INITIAL    3.0

@implementation ListeningViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSLog(@"ListeningViewController viewDidLoad");
    [super viewDidLoad];
    mapView = [[RMMapView alloc] initWithFrame:[[self view] frame]];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:MAP_LAT_INITIAL longitude:MAP_LON_INITIAL];
    RMMapContents *mapContents = [mapView contents];
    [mapContents setMapCenter:location.coordinate];
    [mapContents setScale:MAP_SCALE_INITIAL];
    [mapView setDelegate:self];
    [self setView:mapView];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

//------------------------------ RMMapViewDelegate methods ------------------------------

//- (void) beforeMapMove: (RMMapView*) map {
//    NSLog(@"ListeningViewController beforeMapMove: %@", map);
//}

//- (void) afterMapMove: (RMMapView*) map {
//    NSLog(@"ListeningViewController afterMapMove: %@", map);
//}

- (void) beforeMapZoom: (RMMapView*) map byFactor: (float) zoomFactor near:(CGPoint) center {
    NSLog(@"ListeningViewController beforeMapZoom:%@ byFactor:%f near:%1.1f,%1.1f", map, zoomFactor, center.x, center.y);
}

- (void) afterMapZoom: (RMMapView*) map byFactor: (float) zoomFactor near:(CGPoint) center {
    NSLog(@"ListeningViewController afterMapZoom:%@ byFactor:%f near:%1.1f,%1.1f", map, zoomFactor, center.x, center.y);
    RMMapContents *contents = [map contents];
    NSLog(@"   - map.contents.scale: %f", map.contents.scale);
    NSLog(@"   - map.contents.zoom : %f", map.contents.zoom);
    if (contents.scale < 0.5) {
        [contents setScale:0.5];
        [mapView drawRect:[mapView frame]];
    }
}

//- (void) singleTapOnMap: (RMMapView*) map At: (CGPoint) point {
//    NSLog(@"ListeningViewController singleTapOnMap:%@ At:%1.1f,%1.1f", map, point.x, point.y);
//}

//- (void) doubleTapOnMap: (RMMapView*) map At: (CGPoint) point {
//    NSLog(@"ListeningViewController doubleTapOnMap:%@ At:%1.1f,%1.1f", map, point.x, point.y);
//}

- (void) tapOnMarker: (RMMarker*) marker onMap: (RMMapView*) map {
    NSLog(@"ListeningViewController tapOnMarker:%@ onMap:%@", marker, map);
}

- (void) tapOnLabelForMarker: (RMMarker*) marker onMap: (RMMapView*) map {
    NSLog(@"ListeningViewController tapOnMarker:%@ onMap:%@", marker, map);
}

- (void) dragMarkerPosition: (RMMarker*) marker onMap: (RMMapView*)map position:(CGPoint)position {
    NSLog(@"ListeningViewController dragMarkerPosition:%@ onMap:%@ position:%@", marker, map, position);
}

//- (void) afterMapTouch: (RMMapView*) map {
//    NSLog(@"ListeningViewController afterMapTouch:%@", map);
//}

@end
