//
//  GKAppDelegate.h
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EGG/EGG.h>
#import "GKStatusBar.h"
#import "MBProgressHUD.h"
#import "SinaWeibo.h"
#import "WXApi.h"
#import "Reachability.h"
#import "GAI.h"
#import "GKRootViewController.h"
#import "GKCenterViewController.h"
#import "UMFeedback.h"

@class SNViewController;

@interface GKAppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate,WXApiDelegate,UMFeedbackDataDelegate>
{
    SinaWeibo *sinaweibo;
}
@property(nonatomic, strong) UMFeedback *umFeedback;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GKStatusBar *statusBar;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (strong, nonatomic) SNViewController *viewController;
@property (nonatomic, retain) Reachability *hostReach;
@property(nonatomic, retain) id<GAITracker> tracker;
@property(nonatomic,strong) GKRootViewController * drawerController;
@property(nonatomic,strong) GKNavigationController * navigationController;
@property(nonatomic,strong)GKCenterViewController * centerViewController;
@property (nonatomic,strong) NSMutableArray *needRequestEntityArray;
@property (nonatomic,strong) UIButton * messageRemind;

- (GKStatusBar *)sharedStatusBar;
- (MBProgressHUD *)sharedHUD;
- (UIActivityIndicatorView *)sharedActivity;

- (void)hudWasHidden:(MBProgressHUD *)hud;
- (void)showLoginView;
- (void)hideMessageRemind;
@end
