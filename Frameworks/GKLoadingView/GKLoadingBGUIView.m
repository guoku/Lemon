//
//  BGUIView.m
//  GmailLikeLoading
//
//  Created by huiter on 13-4-19.
//  Copyright (c) 2013年 Nikhil Gohil. All rights reserved.
//

#import "GKLoadingBGUIView.h"

@implementation GKLoadingBGUIView

@synthesize color = _color;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         _color = [UIColor clearColor];
    }
    return self;
}
-(void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    [_color setFill];
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, rect.origin.x , rect.origin.y);
    CGPathAddLineToPoint(path1, NULL, rect.origin.x + rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path1, NULL, rect.origin.x + rect.size.width, rect.origin.y+rect.size.height);
    CGPathAddLineToPoint(path1, NULL, rect.origin.x, rect.origin.y+rect.size.height);
    CGPathAddLineToPoint(path1, NULL, rect.origin.x, rect.origin.y);
    CGPathCloseSubpath(path1);
    CGContextAddPath(ctx1, path1);
    CGContextFillPath(ctx1);
    CGPathRelease(path1);
    
}
@end
