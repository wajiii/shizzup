//
//  FirstViewController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/02.
//  Copyright waj3 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EveryoneViewController : UIViewController {
    UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end