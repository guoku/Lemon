//
//  GKItemLoadingView.m
//  Grape
//
//  Created by huiter on 13-5-3.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKItemLoadingView.h"

@implementation GKItemLoadingView
{
@private
    UIImageView * one;
    UIImageView * two;
    UIImageView * three;
    UIImageView * four;
    UIImageView * five;
    
}
@synthesize hidesWhenStopped = _hidesWhenStopped;
@synthesize dotCount = _dotCount;
@synthesize duration = _duration;

- (void)setDefaultProperty
{
    _currentStep = 0;
    _isAnimating = NO;
    _duration = 0.25f;
    _hidesWhenStopped = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultProperty];
        self.backgroundColor = [UIColor clearColor];
        
        one = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stage_6.png"]];
        two= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stage_7.png"]];
        three= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stage_8.png"]];
        four= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stage_9.png"]];
        five = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stage_10.png"]];

        one.center = CGPointMake(5*self.frame.size.width/10, self.frame.size.height/2);
        two.center = CGPointMake(5*self.frame.size.width/10, self.frame.size.height/2);
        three.center = CGPointMake(5*self.frame.size.width/10, self.frame.size.height/2);
        four.center = CGPointMake(5*self.frame.size.width/10, self.frame.size.height/2);
        five.center = CGPointMake(5*self.frame.size.width/10, self.frame.size.height/2);
        
        [self addSubview:one];
        [self addSubview:two];
        [self addSubview:three];
        [self addSubview:four];
        [self addSubview:five];
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    return self;
}

#pragma mark - public
- (void)startAnimating
{
    if (_isAnimating) {
        return;
    }
    _currentStep = 0;
    one.alpha = 1;
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
    [self reset];
     one.alpha = 1;
}

- (BOOL)isAnimating
{
    return _isAnimating;
}
- (void)repeatAnimation
{
    _currentStep = ++_currentStep % 5;
    [self reset];
    switch (_currentStep) {
        case 0:
        {
            one.image = [UIImage imageNamed:@"stage_comp_6.png"];
            one.alpha = 1.0;
            [UIView animateWithDuration:_duration
                             animations:^{
                                 one.alpha = 1.0;
                             }];
        }
            break;
        case 1:
        {
            two.image = [UIImage imageNamed:@"stage_comp_7.png"];
            two.alpha = 1.0;
            [UIView animateWithDuration:_duration
                             animations:^{
                                 two.alpha = 1.0;
                             }];
        }
            break;
        case 2:
        {
            three.image = [UIImage imageNamed:@"stage_comp_8.png"];
            three.alpha = 1.0;
            [UIView animateWithDuration:_duration
                             animations:^{
                                 three.alpha = 1.0;
                             }];
        }
            break;
        case 3:
        {
            four.image = [UIImage imageNamed:@"stage_comp_9.png"];
            four.alpha = 1.0;
            [UIView animateWithDuration:_duration
                             animations:^{
                                 four.alpha = 1.0;
                             }];
        }
            break;
        case 4:
        {
            five.image = [UIImage imageNamed:@"stage_comp_10.png"];
            five.alpha = 1.0;
            [UIView animateWithDuration:_duration
                             animations:^{
                                 five.alpha = 1.0;
                             }];
        }
            break;
            
        default:
            break;
    }
}
- (void)reset
{
    one.alpha = 0;
    two.alpha = 0;
    three.alpha = 0;
    four.alpha = 0;
    five.alpha = 0;
    one.image = [UIImage imageNamed:@"stage_6.png"];
    two.image= [UIImage imageNamed:@"stage_7.png"];
    three.image= [UIImage imageNamed:@"stage_8.png"];
    four.image = [UIImage imageNamed:@"stage_9.png"];
    five.image = [UIImage imageNamed:@"stage_10.png"];
}
@end
