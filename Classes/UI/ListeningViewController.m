//
//  ListeningViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import "ListeningViewController.h"

#import "ListeningDataSource.h"
#import "ShizzupConstants.h"
#import "ShoutManager.h"

@implementation ListeningViewController

#define REDRAW_TIMER_INTERVAL  10.0  // seconds
#define AUTORELOAD_INTERVAL 60.0  // seconds
#define TAG_REFRESH_BUTTON_CELL 0xfade

@synthesize refreshButtonCell;
@synthesize spinnerView;
@synthesize tableView;

- (void) dealloc {
    [refreshButtonCell release];
    [spinnerView release];
    [tableView release];
    [super dealloc];
}

- (void) viewDidLoad {
    [super viewDidLoad];

    NSLog(@"Setting up shout manager...");
    shoutManager = [[ShoutManager alloc] init];

    NSLog(@"Setting up shouts data source...");
    [shoutManager setWho:@"listening"];
    ListeningDataSource *shoutsDataSource = [ListeningDataSource initWithManager:shoutManager controller:self];

    NSLog(@"Setting up list view...");
    [tableView setDataSource:shoutsDataSource];
    [tableView setDelegate:shoutsDataSource];
    [tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

    isFirstLoad = YES;
    [refreshButtonCell setTag:TAG_REFRESH_BUTTON_CELL];
    nextAutoReload = CFAbsoluteTimeGetCurrent() - 1;
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"ListeningViewController viewWillAppear");
    [super viewWillAppear:animated];

    // Start data retrieval
    NSLog(@"Starting shout retrieval...");
    //[self refreshShoutList];
    [self loadCachedShouts];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"ListeningViewController viewDidAppear");
    [super viewDidAppear:animated];
    [self startRedrawTimer];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"ListeningViewController viewWillDisappear");
    [self stopRedrawTimer];
    [super viewWillDisappear:animated];
}

- (void) dataLoaded:(NSArray *)shouts {
    NSLog(@"ListeningViewController dataLoaded");

    // Update tab bar item badge
    NSUInteger shoutCount = 0;
    if (shouts != nil) {
        shoutCount = [shouts count];
    }
    NSString *shoutCountS = [NSString stringWithFormat:@"%u", shoutCount];
    [[self tabBarItem] setBadgeValue:shoutCountS];

    // Update list view table
    [tableView setHidden:NO];
    [tableView reloadData];
    //    [tableView performSelectorInBackground:@selector(reloadData) withObject:nil];

    // Scroll to first shout
    // Reconsidering this, given auto-reload
    NSArray *visibleCells = [tableView visibleCells];
    //NSLog(@"  - visibleCells: %@", visibleCells);
    UITableViewCell *firstVisibleCell = (UITableViewCell *)[visibleCells objectAtIndex:0];
    //NSLog(@"  - firstVisibleCell: %@", firstVisibleCell);
    //NSLog(@"  - firstVisibleCell.tag: %i", firstVisibleCell.tag);
    if ((firstVisibleCell.tag == TAG_REFRESH_BUTTON_CELL) && (shoutCount > 0)) {
        NSUInteger indexes[2] = { 0, 1 };
        NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [indexPath release];
    }

    // Let user know we're done reloading
    [spinnerView stopAnimating];
    if (isFirstLoad) {
        //NSLog(@"  - is first load!");
        isFirstLoad = NO;
    } else {
        //NSLog(@"  - is not first load!");
        nextAutoReload = CFAbsoluteTimeGetCurrent() + AUTORELOAD_INTERVAL;
    }
    NSLog(@"  - next automatic reload: %f", nextAutoReload);
    [self startRedrawTimer];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[self view] setAutoresizesSubviews:YES];
    return YES;
}

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview
    [super didReceiveMemoryWarning];
    // Release anything that's not essential, such as cached data
}

- (void) loadCachedShouts {
    NSLog(@"ListeningViewController loadCachedShouts");
    [spinnerView startAnimating];
    [self stopRedrawTimer];
    [shoutManager loadCachedShouts];
}

- (IBAction) refreshShoutList {
    NSLog(@"ListeningViewController refreshShoutList");
    [self stopRedrawTimer];
    [spinnerView startAnimating];
    [shoutManager findShouts];
}

- (void) startRedrawTimer {
    [self stopRedrawTimer];
    NSLog(@"ListeningViewController startRedrawTimer");
    redrawTimer = [[NSTimer scheduledTimerWithTimeInterval:REDRAW_TIMER_INTERVAL target:self selector:@selector(redraw:) userInfo:nil repeats:YES] retain];
    NSDate *fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0.1];
    [redrawTimer setFireDate:fireDate];
    NSLog(@"  - redrawTimer: %@", redrawTimer);
    [fireDate release];
}

- (void) redraw:(NSTimer*)theTimer {
    @synchronized(self) {
        CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
        NSLog(@"ListeningViewController redraw - now: %.2f; next auto-reload: %.2f", now, nextAutoReload);
        if (now >= nextAutoReload) {
            [self refreshShoutList];
        } else {
            [tableView reloadData];
        }
    }
}

- (void) stopRedrawTimer {
    NSLog(@"ListeningViewController stopRedrawTimer");
    if (redrawTimer != nil) {
        NSLog(@"  - invalidating redrawTimer");
        [redrawTimer invalidate];
        [redrawTimer release];
        redrawTimer = nil;
    }
}

@end
