//
//  GKAlertView.m
//  MMM
//
//  Created by huiter on 13-6-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKAlertView.h"
#import "RatingView.h"
@implementation GKAlertView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)ratingChanged:(float)newRating {
    if(newRating!=0)
    {
        for(UIView *subview in [self subviews]) {
            if([subview isKindOfClass:[UIButton class]] )
            {
                if([((UIButton * )subview).titleLabel.text isEqualToString:@"提交"])
                {
                    ((UIButton * )subview).enabled = YES;
                }
            }
        }
    }
    else
    {
        for(UIView *subview in [self subviews]) {
            if([subview isKindOfClass:[UIButton class]] )
            {
                if([((UIButton * )subview).titleLabel.text isEqualToString:@"提交"])
                {
                    ((UIButton * )subview).enabled = NO;
                }
            }
        }
    }
}
- (void)layoutSubviews{
    CGRect rect = self.bounds;
    rect.size.height = 150;
    self.bounds = rect;
    for(UIView *subview in [self subviews]) {
        if([subview isKindOfClass:[UIControl class]] ) {
            CGRect frame = subview.frame;
            frame.origin.y = 85;
            subview.frame = frame;
            _ratingView = [[RatingView alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
            [_ratingView setImagesDeselected:@"star_m.png" partlySelected:@"star_m_half.png" fullSelected:@"star_m_full.png" andDelegate:self];
            _ratingView.center = CGPointMake(self.frame.size.width/2-20, 55);
            [_ratingView displayRating:0];
            [self addSubview:_ratingView];
        }
    }

}

@end
