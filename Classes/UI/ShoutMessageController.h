//
//  ShoutMessageController.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/09.
//  Copyright 2009 waj3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface ShoutMessageController : UIViewController {
    UITextView *message;
    Place *place;
    UILabel *placeName;
    UILabel *placePhone;
    UILabel *placeAddress;
}

@property (nonatomic, retain) IBOutlet UITextView *message;
@property (nonatomic, retain) IBOutlet Place *place;
@property (nonatomic, retain) IBOutlet UILabel *placeName;
@property (nonatomic, retain) IBOutlet UILabel *placePhone;
@property (nonatomic, retain) IBOutlet UILabel *placeAddress;

- (IBAction) doShout;

@end
