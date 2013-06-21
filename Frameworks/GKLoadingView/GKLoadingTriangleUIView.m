//
//  TriangleUIView.m
//  GmailLikeLoading
//
//  Created by huiter on 13-4-19.
//  Copyright (c) 2013年 Nikhil Gohil. All rights reserved.
//

#import "GKLoadingTriangleUIView.h"

@implementation GKLoadingTriangleUIView
@synthesize color = _color;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = [UIColor colorWithRed:0.0/255.0f green:147.0/255.0f blue:78.0/255.0f alpha:1.0];
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
     //[super drawRect:rect];
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    [_color setFill];
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, rect.origin.x + rect.size.width/2, rect.origin.y);
    CGPathAddLineToPoint(path1, NULL, rect.origin.x + rect.size.width, rect.origin.y+rect.size.height/2);
    CGPathAddLineToPoint(path1, NULL, rect.origin.x+ rect.size.width/2, rect.origin.y+rect.size.height);
    CGPathAddLineToPoint(path1, NULL, rect.origin.x, rect.origin.y+rect.size.height/2);
    CGPathAddLineToPoint(path1, NULL, rect.origin.x + rect.size.width/2, rect.origin.y);
    CGPathCloseSubpath(path1);
    CGContextAddPath(ctx1, path1);
    CGContextFillPath(ctx1);
    CGPathRelease(path1);

}
@end
