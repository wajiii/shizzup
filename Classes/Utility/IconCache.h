//
//  IconCache.h
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/15.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconCache : NSObject {
    NSDictionary *icons;
    NSString *diskCachePath;
}

- (UIImage *) iconForAddress:(NSString *)iconAddress;
- (NSString *) nameForAddress:(NSString *)iconAddress;

@end
