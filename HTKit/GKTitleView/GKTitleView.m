//
//  GKTitleView.m
//  果库2.0
//
//  Created by huiter on 12-12-12.
//  Copyright (c) 2012年 果库. All rights reserved.
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
    tableViewTitleL.minimumFontSize = 18.0f;
    tableViewTitleL.textColor = [UIColor whiteColor];
    tableViewTitleL.shadowColor = [UIColor blackColor];
    tableViewTitleL.shadowOffset = CGSizeMake(0.0f,1.0f);
    tableViewTitleL.textAlignment = UITextAlignmentCenter;
    tableViewTitleL.adjustsFontSizeToFitWidth = YES;
    tableViewTitleL.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:22];
    [titleV addSubview:tableViewTitleL];

    return titleV;
}

@end
