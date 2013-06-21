//
//  GKStatusBar.m
//  GKNEW
//
//  Created by huiter on 13-1-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKStatusBar.h"

@implementation GKStatusBar
@synthesize statusLabel = _statusLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        self.frame = CGRectMake(statusBarFrame.origin.x + statusBarFrame.size.width * 0.65f - 7.0f, statusBarFrame.origin.y, statusBarFrame.size.width * 0.35 + 5.0f, statusBarFrame.size.height);
        self.backgroundColor = [UIColor blackColor];
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)] ;
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [_statusLabel setAdjustsFontSizeToFitWidth:NO];
        [_statusLabel setNumberOfLines:1];
        _statusLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:_statusLabel];
        
        self.alpha = 0.0f;
    }
    return self;
}

- (void)showWithMessage:(NSString *)message
{
    if (!message || [message length] == 0) {
        return;
    }
    _statusLabel.text = message;
    _statusLabel.frame = [_statusLabel textRectForBounds:_statusLabel.bounds limitedToNumberOfLines:1];
    _statusLabel.frame = CGRectMake(self.frame.size.width, _statusLabel.frame.origin.y, _statusLabel.frame.size.width + 5.0f, [UIApplication sharedApplication].statusBarFrame.size.height);
    self.alpha = 1.0f;
    self.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    _statusLabel.frame = CGRectMake(self.frame.size.width - _statusLabel.frame.size.width, _statusLabel.frame.origin.y, _statusLabel.frame.size.width, _statusLabel.frame.size.height);
    [UIView commitAnimations];
}

- (void)hideMessage
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    _statusLabel.frame = CGRectMake(self.frame.size.width + _statusLabel.frame.size.width, _statusLabel.frame.origin.y, _statusLabel.frame.size.width, _statusLabel.frame.size.height);
    self.alpha = 0.0f;
    [UIView commitAnimations];
}
@end
