//
//  ImageManipulator.h
//  Shizzup
//
//  Originally published by Björn Sållarp at http://jsus.is-a-geek.org/blog/2008/09/iphone-uiimage-round-corners/ .
//  Branched by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Modifications copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManipulator : NSObject {
}

+ (UIImage *) makeRoundCornerImage:(UIImage*)img :(int) cornerWidth :(int) cornerHeight;
+ (UIImage *) getImageForUrl:(NSURL *) url;
+ (UIImage *) getIconForUrl:(NSURL *) url;

@end
