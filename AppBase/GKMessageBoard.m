//
//  GKMessageBoard.m
//  GKNEW
//
//  Created by huiter on 13-1-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKMessageBoard.h"
#import "GKStatusBar.h"
#import "GKAppDelegate.h"

@implementation GKMessageBoard
+ (void)showStatusBarWithMessage:(NSString *)message
{
       GKStatusBar *statusBar = [(GKAppDelegate *)[UIApplication sharedApplication].delegate sharedStatusBar];
       [statusBar showWithMessage:message];
}

+ (void)hideStatusBar
{
    GKStatusBar *statusBar = [(GKAppDelegate *)[UIApplication sharedApplication].delegate sharedStatusBar];
    [statusBar hideMessage];
}

+ (void)showMBHigher:(MBProgressHUD *)HUD
{
    HUD.center = CGPointMake(HUD.center.x, [UIApplication sharedApplication].delegate.window.center.y-60.0f);
}

+ (void)showMBWithText:(NSString *)text customView:(UIView *)customView delayTime:(float)time
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"sync"])
    {
    MBProgressHUD *HUD = [(GKAppDelegate *)[UIApplication sharedApplication].delegate sharedHUD];
    HUD.labelText = nil;
    HUD.detailsLabelText = nil;
    HUD.labelText = text;
    if (customView) {
        HUD.customView = customView;
        HUD.mode = MBProgressHUDModeCustomView;
    }
    [HUD show:YES];
    if (time > 0.0) {
        [HUD hide:YES afterDelay:time];
    }
    }
}

+ (void)showMBWithText:(NSString *)text customView:(UIView *)customView delayTime:(float)time atHigher:(BOOL)higher
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"sync"])
    {
    MBProgressHUD *HUD = [(GKAppDelegate *)[UIApplication sharedApplication].delegate sharedHUD];
    HUD.labelText = nil;
    HUD.detailsLabelText = nil;
    HUD.labelText = text;
    if (customView) {
        HUD.customView = customView;
        HUD.mode = MBProgressHUDModeCustomView;
    }
    if (higher) {
        [self showMBHigher:HUD];
    }
    [HUD show:YES];
    if (time > 0.0) {
        [HUD hide:YES afterDelay:time];
    }
    }
}

+ (void)showMBWithText:(NSString *)text detailText:(NSString *)detailText lableFont:(UIFont *)labelFont detailFont:(UIFont *)detailFont customView:(UIView *)customView delayTime:(float)time atHigher:(BOOL)higher
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"sync"])
    {
    MBProgressHUD *HUD = [(GKAppDelegate *)[UIApplication sharedApplication].delegate sharedHUD];
    HUD.labelText = nil;
    HUD.detailsLabelText = nil;
    HUD.labelText = text;
    HUD.detailsLabelText = detailText;
    if (labelFont && detailFont) {
        HUD.labelFont = labelFont;
        HUD.detailsLabelFont = detailFont;
    }
    if (customView) {
        HUD.customView = customView;
        HUD.mode = MBProgressHUDModeCustomView;
    }
    if (higher) {
        [self showMBHigher:HUD];
    }
    [HUD show:YES];
    if (time > 0.0) {
        [HUD hide:YES afterDelay:time];
    }
    }
}

+ (void)hideMB
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"sync"])
    {
    MBProgressHUD *HUD = [(GKAppDelegate *)[UIApplication sharedApplication].delegate HUD];
    [HUD hide:YES];
    }
}

+ (void)showActivity
{
    UIActivityIndicatorView *activity = [(GKAppDelegate *)[UIApplication sharedApplication].delegate sharedActivity];
    [activity startAnimating];
}

+ (void)hideActivity
{
    UIActivityIndicatorView *activity = [(GKAppDelegate *)[UIApplication sharedApplication].delegate sharedActivity];
    [activity stopAnimating];
}

@end
