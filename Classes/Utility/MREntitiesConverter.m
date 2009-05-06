//
//  MREntitiesConverter.m
//  Shizzup
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/09.
//  Copyright 2009 waj3. All rights reserved.
//

#import "MREntitiesConverter.h"

@implementation MREntitiesConverter

@synthesize resultString;

- (id)init
{
	if([super init]) {
		resultString = [[NSMutableString alloc] init];
	}
	return self;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s {
    [self.resultString appendString:s];
}

- (NSString*)newConvertEntitiesInString:(NSString*)s {
	if(s == nil) {
		NSLog(@"ERROR : Parameter string is nil");
	}
	NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", s];
	NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSXMLParser* xmlParse = [[NSXMLParser alloc] initWithData:data];
	[xmlParse setDelegate:self];
	[xmlParse parse];
    [xmlParse release];
	NSString* returnStr = [[NSString alloc] initWithFormat:@"%@",resultString];
	return returnStr;
}

- (void)dealloc {
	[resultString release];
	[super dealloc];
}

@end

