//
//  SimpleCardView.m
//  Grape
//
//  Created by huiter on 13-4-9.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "SimpleCardView.h"

@implementation SimpleCardView

@synthesize img =_img;
@synthesize data = _data;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _img = [[GKItemButton alloc] initWithFrame:CGRectZero];
        [_img setType:kItemButtonWithActivityIndicator];
        [_img setPadding:6];
        [self addSubview:_img];
    }
    return self;
}
- (void)setDelegate:(id<GKDelegate>)delegate
{
    _delegate = delegate;
    _img.delegate = _delegate;
}
- (void)setData:(GKEntity *)data
{
    _data = data;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    _img.entity = _data;
    _img.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
