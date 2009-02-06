//
//  ImageManipulator.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageManipulator : NSObject {

}

+(UIImage *)makeRoundCornerImage:(UIImage*)img :(int) cornerWidth :(int) cornerHeight;

@end
