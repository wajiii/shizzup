//
//  ListeningViewController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoutManager;

@interface ListeningViewController : UIViewController {
    UITableView *tableView;
    UIActivityIndicatorView *spinnerView;
    ShoutManager *shoutManager;
    UITableViewCell *refreshButtonCell;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinnerView;
@property (nonatomic, retain) IBOutlet UITableViewCell *refreshButtonCell;

- (void) dataLoaded:(NSArray *) shouts;
- (void) refreshShoutList;

@end
