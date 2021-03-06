//
//  GKTitleView.m
//  妈妈清单2.0
//
//  Created by huiter on 12-12-12.
//  Copyright (c) 2012年 妈妈清单. All rights reserved.
//

#import "GKTitleView.h"

@implementation GKTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UIView *)setTitleLabel:(NSString *)title
{
    UIView * titleV = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 30.0f)];
    UILabel *tableViewTitleL = [[UILabel alloc] initWithFrame:titleV.frame];
    tableViewTitleL.backgroundColor = [UIColor clearColor];
    tableViewTitleL.text = title;
    tableViewTitleL.textColor = [UIColor whiteColor];
    tableViewTitleL.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    tableViewTitleL.shadowOffset = CGSizeMake(0.0f,-1.0f);
    tableViewTitleL.textAlignment = NSTextAlignmentCenter;
    tableViewTitleL.adjustsFontSizeToFitWidth = YES;
    //tableViewTitleL.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:22];
    tableViewTitleL.font =  [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [titleV addSubview:tableViewTitleL];

    return titleV;
}

@end
