//
//  GKBagde.m
//  Grape
//
//  Created by huiter on 13-4-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBagde.h"

@implementation GKBagde
@synthesize icon = _icon;
@synthesize hidesWhenStopped = _hidesWhenStopped;
@synthesize duration = _duration;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bagde.png"]];
        [self addSubview:_icon];
        [self setDefaultProperty];
        
    }
    return self;
}


- (void)setDefaultProperty
{
    _isAnimating = NO;
    _duration = 0.8f;
    _hidesWhenStopped = NO;
}
- (void)startAnimating
{
    if (_isAnimating) {
        [self stopAnimating];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration
                                              target:self
                                            selector:@selector(repeatAnimation)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _isAnimating = YES;
    
    self.hidden = NO;
    
}

- (void)stopAnimating
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _isAnimating = NO;
    
    if (_hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (BOOL)isAnimating
{
    return _isAnimating;
}
- (void)repeatAnimation
{

    self.icon.alpha = 1.0;

    [UIView animateWithDuration:_duration animations:^{
         self.icon.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:_duration animations:^{
            self.icon.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}


@end
