//
//  MMMCalendar.h
//  MMM
//
//  Created by huiter on 13-6-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMCalendar : UIView
@property (strong,nonatomic) NSDate *date;
- (id)initWithFrame:(CGRect)frame kind:(NSUInteger)kind;
@end
