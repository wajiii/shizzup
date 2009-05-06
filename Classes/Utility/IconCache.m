//
//  IconCache.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/15.
//  Copyright 2009 waj3. All rights reserved.
//

#import "IconCache.h"
#import "ImageManipulator.h"

@implementation IconCache

#define SPACER_CHARACTER 95

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
    [super dealloc];
}

- (id) init {
    NSLog(@"IconCache init");
    [super init];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"   - paths: %@", paths);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"   - documentsDirectory: %@", documentsDirectory);
//    diskCachePath = [documentsDirectory stringByAppendingPathComponent:@"userIconCache.plist"];
    diskCachePath = [NSTemporaryDirectory() retain];
    NSLog(@"   - diskCachePath: %@", diskCachePath);
    icons = [[NSMutableDictionary alloc] init];
    return self;
}

- (NSString *) nameForAddress:(NSString *)iconAddress {
    //NSLog(@"IconCache nameForAddress: %@", iconAddress);
    //CFAbsoluteTime currentMethodStart = CFAbsoluteTimeGetCurrent();
    NSUInteger length = [iconAddress length];
    //NSLog(@"   - length: %u", length);
    unichar *characters = malloc(length * sizeof(unichar));
    //NSLog(@"   - characters: %S", characters);
    [iconAddress getCharacters:characters];
    //NSLog(@"   - characters: %S", characters);
    //unichar newChar;
    unichar oldChar;
    for (int i = 0; i < length; i++) {
        //newChar = 
        oldChar = characters[i];
        //NSLog(@"   - character: %C", character);
        if (oldChar < 48 || (oldChar > 57 && oldChar < 65) || (oldChar > 90 && oldChar < 97) || oldChar > 122) {
            //newChar = 
            characters[i] = SPACER_CHARACTER;
        }
        //NSLog(@"   - character: %C %C", oldChar, newChar);
    }
    //NSLog(@"   - characters: %S", characters);
    NSString *result = [NSString stringWithCharacters:characters length:length];
    //NSLog(@"   - result: %@", result);
    free(characters);
    //CFAbsoluteTime currentMethodFinish = CFAbsoluteTimeGetCurrent();
    //NSLog(@"   - IconCache nameForAddress time: %f", (currentMethodFinish - currentMethodStart));
    return result;
}

- (UIImage *) iconForAddress:(NSString *)iconAddress {
    //NSLog(@"IconCache iconForAddress: %@", iconAddress);
    //CFAbsoluteTime currentMethodStart = CFAbsoluteTimeGetCurrent();
    UIImage *icon = [icons objectForKey:iconAddress];
    if (icon != nil) {
        //NSLog(@"   - memory cache hit (immediate)");
    } else {
        @synchronized(self) {
            icon = [icons objectForKey:iconAddress];
            if (icon != nil) {
                //NSLog(@"   - memory cache hit (@synchronized)");
            } else {
                //NSLog(@"   - memory cache miss");
                NSString *thisFileName = [self nameForAddress:iconAddress];
                //NSLog(@"   - thisFileName: %@", thisFileName);
                NSString *thisFilePath = [diskCachePath stringByAppendingPathComponent:thisFileName];
                //NSLog(@"   - thisFilePath: %@", thisFilePath);
                icon = [UIImage imageWithContentsOfFile:thisFilePath];
                if (icon != nil) {
                    //NSLog(@"   - disk cache hit");
                } else {
                    //NSLog(@"   - disk cache miss");
                    UIImage *roundedIcon;
                    if ([iconAddress compare:@"/images/people/people_48.jpg"] == 0) {
                        roundedIcon = nil;
                    } else {
                        NSURL *iconUrl = [NSURL URLWithString:iconAddress];
                        roundedIcon = [ImageManipulator getIconForUrl:iconUrl];
                    }
                    icon = [roundedIcon retain];
                    NSData *iconPngData = UIImagePNGRepresentation(icon);
                    //BOOL cacheWriteResult = 
                        [iconPngData writeToFile:thisFilePath atomically:YES];
                    //BOOL cacheWriteResult = [icons writeToFile:diskCachePath atomically:YES];
                    //NSLog(@"   - write to disk cache: %d", cacheWriteResult);
                }
                [icons setValue:icon forKey:iconAddress];
            }
        }
    }
    //CFAbsoluteTime currentMethodFinish = CFAbsoluteTimeGetCurrent();
    //NSLog(@"   - IconCache iconForAddress time: %f", (currentMethodFinish - currentMethodStart));
    return icon;
}

@end
