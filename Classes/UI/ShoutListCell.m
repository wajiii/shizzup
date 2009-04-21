//
//  ShoutListCell.m
//  FastScrolling
//
//  Created by Bill Jackson <wajiii@gmail.com> on 2009/03/15.
//  Copyright 2009 waj3. All rights reserved.
//

#import "ShoutListCell.h"
#import "ShizzupConstants.h"

@implementation ShoutListCell

@synthesize shout;

#define LABEL_ORIGIN_X (ICON_WIDTH + (SHOUTCELL_MARGIN_HORIZONTAL * 2))

static CGFloat pageWidth = 320.0;
static CGFloat labelWidth = 320.0;
static CGSize maxTextSize;
static NSDictionary *allSizes = nil;
static UIFont *ageFont = nil;
static UIFont *messageFont = nil;

+ (void)initialize {
    NSLog(@"ShoutListCell initialize");
	if(self == [ShoutListCell class]) {
        NSLog(@"   - initializing fonts");
		messageFont = [[UIFont systemFontOfSize:14] retain];
		ageFont = [[UIFont systemFontOfSize:10] retain];
        allSizes = [[[NSMutableDictionary alloc] init] retain];
		// this is a good spot to load any graphics you might be drawing in -drawContentView:
		// just load them and retain them here (ONLY if they're small enough that you don't care about them wasting memory)
		// the idea is to do as LITTLE work (e.g. allocations) in -drawContentView: as possible
        NSLog(@"   - LABEL_ORIGIN_X: %f", LABEL_ORIGIN_X);
        [self setPageWidth:320];
	}
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame: frame reuseIdentifier: reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (NSString *) messageForShout:(Shout *)shout {
    NSString *shoutedOrLeft;
    if ([@"here" isEqualToString:[shout status]]) {
        shoutedOrLeft = @"shouted from";
    } else {
        shoutedOrLeft = @"left";
    }
    NSString *result = [NSString stringWithFormat:@"%@ %@ %@", [shout username], shoutedOrLeft, [shout placeName]];
    //NSLog(@"   - result: %@", result);
    if ([shout message] != nil) {
        result = [result stringByAppendingFormat:@": %@", [shout message]];
    }
    //NSLog(@"   - result: %@", result);
    return result;
}

- (void)drawContentView:(CGRect)r {
    //NSLog(@"ShoutListCell drawContentView");
    //CFAbsoluteTime currentMethodStart = CFAbsoluteTimeGetCurrent();
    NSArray *mySizes = [allSizes objectForKey:shoutId];
    //NSLog(@"   - mySizes: %@", mySizes);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor blackColor];
	if(self.selected) {
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
	}
    
	// Fill cell with background color
	[backgroundColor set];
	CGContextFillRect(context, r);
    
	// Draw user's icon
    [[shout icon] drawAtPoint:CGPointMake(SHOUTCELL_MARGIN_HORIZONTAL, SHOUTCELL_MARGIN_VERTICAL)];
    
	[textColor set];
    //float messageWidth = [[mySizes objectAtIndex:0] floatValue];
    float messageHeight = [[mySizes objectAtIndex:1] floatValue];
    //NSLog(@"   - messageWidth: %f", messageWidth);
    //NSLog(@"   - messageHeight: %f", messageHeight);
    CGRect firstRect = CGRectMake(LABEL_ORIGIN_X, SHOUTCELL_MARGIN_VERTICAL, labelWidth, messageHeight);
    CGSize firstSizeDrawn = [message drawInRect:firstRect withFont:messageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
	
    //CGSize ageSize = [age sizeWithFont:ageFont constrainedToSize:maxTextSize lineBreakMode:UILineBreakModeWordWrap];
    //float ageWidth = ageSize.width;
    float ageWidth = [[mySizes objectAtIndex:2] floatValue];
    float ageHeight = [[mySizes objectAtIndex:3] floatValue];
    //NSLog(@"   - ageWidth: %f", ageWidth);
    //NSLog(@"   - ageHeight: %f", ageHeight);
    CGFloat ageX = pageWidth - SHOUTCELL_MARGIN_HORIZONTAL - ageWidth;
    //NSLog(@"   - ageX: %f", ageX);
    CGFloat ageMinY = CELL_HEIGHT_MIN - SHOUTCELL_MARGIN_VERTICAL - ageHeight;
    //NSLog(@"   - ageMinY: %f", ageMinY);
    CGFloat ageY = firstSizeDrawn.height + (SHOUTCELL_MARGIN_VERTICAL * 2);
    //NSLog(@"   - ageY: %f", ageY);
    ageY = MAX(ageMinY, ageY);
    //NSLog(@"   - ageY: %f", ageY);
    CGRect ageRect = CGRectMake(ageX, ageY, ageWidth, ageHeight);
    //CGSize ageSizeDrawn = 
        [age drawInRect:ageRect withFont:ageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    //NSLog(@"   - ageSizeDrawn.width: %f", ageSizeDrawn.width);
    //NSLog(@"   - ageSizeDrawn.height: %f", ageSizeDrawn.height);
    //CFAbsoluteTime currentMethodFinish = CFAbsoluteTimeGetCurrent();
    //NSLog(@"   - ShoutListCell drawContentView time: %f", (currentMethodFinish - currentMethodStart));
}

- (void)dealloc {
    [age release];
    [message release];
    [shout release];
    [shoutId release];
    [super dealloc];
}

- (void) setShout:(Shout *) newShout {
    shout = newShout;
    [ShoutListCell heightForShout:newShout];
    age = [[shout relativeShoutTime] retain];
    message = [[ShoutListCell messageForShout:shout] retain];
    shoutId = [shout shouts_history_id];
    [self setNeedsDisplay];
}

+ (void) setPageWidth:(CGFloat) newWidth {
    pageWidth = newWidth;
    NSLog(@"ShoutListCell setPageWidth: %f", pageWidth, pageWidth);
    labelWidth = 320 - LABEL_ORIGIN_X - SHOUTCELL_MARGIN_HORIZONTAL;
    NSLog(@"   - labelWidth: %f", labelWidth);
    maxTextSize = CGSizeMake(labelWidth, 1024.0f);
    NSLog(@"   - maxTextSize.width: %f", maxTextSize.width);
    NSLog(@"   - maxTextSize.height: %f", maxTextSize.height);
}

+ (CGFloat) heightForShout:(Shout *)shout {
    //CFAbsoluteTime currentMethodStart = CFAbsoluteTimeGetCurrent();
    //NSLog(@"ShoutListCell heightForShout");
    CGFloat result = 44.0f;
    NSString *shoutId = [shout shouts_history_id];
    NSString *message = [ShoutListCell messageForShout: shout];
    NSString *age = [shout relativeShoutTime];
    
    BOOL calculate = YES;
    NSMutableArray *mySizes = [allSizes objectForKey:shoutId];
    if (mySizes != nil) {
        //NSLog(@"   - got mySizes from allSizes");
        //NSLog(@"   - mySizes: %@", mySizes);
        NSString *storedMessage = [mySizes objectAtIndex:5];
        NSString *storedAge = [mySizes objectAtIndex:6];
        if ([storedMessage isEqualToString:message] && [storedAge isEqualToString:age]){
            calculate = NO;
            result = [[mySizes objectAtIndex:4] floatValue];
        } else {
            NSLog(@"  - cell size cache mismatch, recalculating!");
            NSLog(@"    - stored: %@ %@", storedMessage, storedAge);
            NSLog(@"    - new   : %@ %@", message, age);
        }
    }
    if (calculate) {            
        //NSLog(@"   - creating new mySizes");
        mySizes = [[NSMutableArray alloc] initWithCapacity:5];
        //NSLog(@"   - mySizes: %@", mySizes);
        //NSLog(@"   - message: %@", message);
        CGSize messageSize = [message sizeWithFont:messageFont constrainedToSize:maxTextSize lineBreakMode:UILineBreakModeWordWrap];
        //NSLog(@"   - messageSize.width: %f", messageSize.width);
        //NSLog(@"   - messageSize.height: %f", messageSize.height);
        NSNumber *messageWidthNSN = [[NSNumber alloc] initWithFloat:messageSize.width];
        NSNumber *messageHeightNSN = [[NSNumber alloc] initWithFloat:messageSize.height];
        [mySizes addObject:messageWidthNSN];
        [mySizes addObject:messageHeightNSN];
        [messageWidthNSN release];
        [messageHeightNSN release];
        
        // Text height, plus vertical margins above and below
        result = (SHOUTCELL_MARGIN_VERTICAL * 2) + messageSize.height;
        //NSLog(@"   - result: %f", result);
        
        CGSize ageSize = [age sizeWithFont:ageFont constrainedToSize:maxTextSize lineBreakMode:UILineBreakModeWordWrap];
        NSNumber *ageWidthNSN = [[NSNumber alloc] initWithFloat:ageSize.width];
        NSNumber *ageHeightNSN = [[NSNumber alloc] initWithFloat:ageSize.height];
        [mySizes addObject:ageWidthNSN];
        [mySizes addObject:ageHeightNSN];
        [ageWidthNSN release];
        [ageHeightNSN release];
        
        // Add this text's height plus a final bottom margin.
        result += ageSize.height + SHOUTCELL_MARGIN_VERTICAL;
        //NSLog(@"   - result: %f", result);
        
        result = MAX(result, CELL_HEIGHT_MIN);	// at least one row
        //NSLog(@"   - result: %f", result);
        NSNumber *cellHeightNSN = [[NSNumber alloc] initWithFloat:result];
        [mySizes addObject:cellHeightNSN];
        [cellHeightNSN release];
        
        // For later comparison
        [mySizes addObject:message];
        [mySizes addObject:age];
        
        //NSLog(@"   - mySizes: %@", mySizes);
        [allSizes setValue:mySizes forKey:shoutId];
        [mySizes release];
    }
    //CFAbsoluteTime currentMethodFinish = CFAbsoluteTimeGetCurrent();
    //NSLog(@"   - ShoutListCell heightForShout time: %f", (currentMethodFinish - currentMethodStart));
	return result;
}

@end
