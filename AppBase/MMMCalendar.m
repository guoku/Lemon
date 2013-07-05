//
//  MMMCalendar.m
//  MMM
//
//  Created by huiter on 13-6-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "MMMCalendar.h"
#import "NSDate+GKHelper.h"
@implementation MMMCalendar
{
@private
    UILabel *month;
    UILabel *day;
}

- (id)initWithFrame:(CGRect)frame kind:(NSUInteger)kind
{
    self = [super initWithFrame:frame];
    if (self) {
        switch (kind) {
            case 0:
            {
                UIImageView * Calendar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sidebar_calendar.png"]];
                Calendar.center = CGPointMake(frame.size.width/2, frame.size.height/2);
                
                day = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 12)];
                day.textAlignment = NSTextAlignmentCenter;
                day.backgroundColor = [UIColor clearColor];
                [day setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
                day.textColor = UIColorFromRGB(0x777777);
                day.center =  CGPointMake(Calendar.frame.size.width/2,13);
                [Calendar addSubview:day];
                
                month = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20,10)];
                month.textAlignment = NSTextAlignmentCenter;
                month.backgroundColor = [UIColor clearColor];
                [month setFont:[UIFont fontWithName:@"Helvetica" size:5.0f]];
                month.textColor = UIColorFromRGB(0x777777);
                month.center = CGPointMake(Calendar.frame.size.width/2,20);
                [Calendar addSubview:month];
                
                
                
                [self addSubview:Calendar];
            }
                break;
            
                
            default:
            {
                UIImageView * Calendar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Calendar.png"]];
                Calendar.center = CGPointMake(frame.size.width/2, frame.size.height/2);
                
                day = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 12)];
                day.textAlignment = NSTextAlignmentCenter;
                day.backgroundColor = [UIColor clearColor];
                [day setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
                day.textColor = UIColorFromRGB(0x666666);
                day.center =  CGPointMake(Calendar.frame.size.width/2,13);
                [Calendar addSubview:day];
                
                month = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20,10)];
                month.textAlignment = NSTextAlignmentCenter;
                month.backgroundColor = [UIColor clearColor];
                [month setFont:[UIFont fontWithName:@"Helvetica" size:5.0f]];
                month.textColor = UIColorFromRGB(0x666666);
                month.center = CGPointMake(Calendar.frame.size.width/2,20);
                [Calendar addSubview:month];
                
            
                [self addSubview:Calendar];
            }
                break;
        }

        
    }
    return self;
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    month.text = [NSDate stringFromDate:_date WithFormatter:@"MMM"];
    day.text = [NSDate stringFromDate:_date WithFormatter:@"dd"];
}

@end
