//
//  ImageManipulator.m
//  Shizzup
//
//  Originally published by Björn Sållarp at http://jsus.is-a-geek.org/blog/2008/09/iphone-uiimage-round-corners/ .
//  Branched by Bill Jackson <wajiii@gmail.com> on 2009/02/06.
//  Modifications copyright 2009 waj3. All rights reserved.
//

#import "ImageManipulator.h"

#define ICON_CORNER_WIDTH 8.0
#define ICON_CORNER_HEIGHT 8.0

@implementation ImageManipulator

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *) makeRoundCornerImage:(UIImage*)img :(int)cornerWidth :(int)cornerHeight
{
    int w = img.size.width;
    int h = img.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    //[img release];
    
    return [UIImage imageWithCGImage:imageMasked];
}

+ (UIImage *) getImageForUrl:(NSURL *) url {
    UIImage *image = nil;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    NSURLResponse *response;
    NSError *error;
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([error code] != 0) {
        NSLog(@"Error retrieving \"%@\"!  %@", url, error);
    } else {
        image = [UIImage imageWithData:imageData];
    }
    return image;
}

+ (UIImage *) getIconForUrl:(NSURL *) url {
    UIImage *icon = [self getImageForUrl:url];
    UIImage *roundedIcon = [ImageManipulator makeRoundCornerImage:icon :ICON_CORNER_WIDTH :ICON_CORNER_HEIGHT];
    return roundedIcon;
}

@end
