//
//  MREntitiesConverter.h
//  Shizzup
//
//  Original source: http://discussions.apple.com/message.jspa?messageID=8064367#8064367
//     posted by "HerbertHansen" (http://discussions.apple.com/profile.jspa?userID=724268) on 2008/09/11
//
//  Forked by Bill Jackson <wajiii@gmail.com> on 2009/03/09.
//  Copyright 2009 waj3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MREntitiesConverter : NSObject {
	NSMutableString* resultString;
}

@property (nonatomic, retain) NSMutableString* resultString;

- (NSString*)convertEntiesInString:(NSString*)s;

@end
