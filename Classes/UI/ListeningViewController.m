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

@synthesize refreshButtonCell;
@synthesize spinnerView;
@synthesize tableView;

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
    
    // Start data retrieval
    //NSLog(@"Starting shout retrieval...");
    //    [shoutManager findShouts];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"ListeningViewController viewWillAppear");
    [super viewWillAppear:animated];
    
    // Start data retrieval
    NSLog(@"Starting shout retrieval...");
    //    [spinnerView startAnimating];
    //    [shoutManager findShouts];
    [self refreshShoutList];
    //    [self performSelectorInBackground:@selector(refreshShoutList) withObject:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"ListeningViewController viewWillDisappear");
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
    if ([shouts count] > 0) {
        NSUInteger indexes[2] = { 0, 1 };
        NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    // Let user know we're done reloading
    [spinnerView stopAnimating];
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

- (void) dealloc {
    [super dealloc];
}

- (IBAction) refreshShoutList {
    [spinnerView startAnimating];
    [shoutManager findShouts];
}

@end
