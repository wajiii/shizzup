//
//  FirstViewController.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import "EveryoneViewController.h"
#import "ShoutManager.h"
#import "ShoutsDataSource.h"

@implementation EveryoneViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    ShoutManager *shoutManager = [ShoutManager alloc];
    ShoutsDataSource *shoutsDataSource = [ShoutsDataSource initWithManager:shoutManager];
    [tableView setDataSource:shoutsDataSource];
    [tableView setDelegate:shoutsDataSource];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end
