//
//  ShoutDetailController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/29.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shout.h"

@interface ShoutDetailController : UIViewController {
    UIImageView *iconView;
    UILabel *lastModifiedLabel;
    UITextView *messages;
    UILabel *personHandleLabel;
    UILabel *personNameLabel;
    UILabel *placeNameLabel;
    Shout *shout;
}

@property(nonatomic, retain) Shout *shout;
@property(nonatomic, retain) IBOutlet UIImageView *iconView;
@property(nonatomic, retain) IBOutlet UILabel *lastModifiedLabel;
@property(nonatomic, retain) IBOutlet UITextView *messages;
@property(nonatomic, retain) IBOutlet UILabel *personHandleLabel;
@property(nonatomic, retain) IBOutlet UILabel *personNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *placeNameLabel;
//@property(nonatomic, retain) IBOutlet 
//@property(nonatomic, retain) IBOutlet 
//@property(nonatomic, retain) IBOutlet 
//@property(nonatomic, retain) IBOutlet 

@end
