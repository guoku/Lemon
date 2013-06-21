//
//  GKMessageBoard.h
//  GKNEW
//
//  Created by huiter on 13-1-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKMessageBoard : NSObject
+ (void)showStatusBarWithMessage:(NSString *)message;

+ (void)hideStatusBar;

+ (void)showMBWithText:(NSString *)text customView:(UIView *)customView delayTime:(float)time;

+ (void)showMBWithText:(NSString *)text customView:(UIView *)customView delayTime:(float)time atHigher:(BOOL)higher;

+ (void)showMBWithText:(NSString *)text detailText:(NSString *)detailText lableFont:(UIFont *)labelFont detailFont:(UIFont *)detailFont customView:(UIView *)customView delayTime:(float)time atHigher:(BOOL)higher;

+ (void)hideMB;

+ (void)showActivity;

+ (void)hideActivity;

@end
