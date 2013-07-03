//
//  GKAppDelegate.m
//  Grape
//
//  Created by huiter on 13-3-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//


#import "GKAppDelegate.h"
#import "GKRootViewController.h"
#import "SNViewController.h"
#import "GKLoginViewController.h"
#import "CPMotionRecognizingWindow.h"
#import "GKNotification.h"
#import "GKVersion.h"
#import "AudioToolbox/AudioToolbox.h"
#import "GKUserGuideViewController.h"
#import "GKDevice.h"
#import "GKAppDotNetAPIClient.h"
#import "GKDetailViewController.h"

#import "MMDrawerController.h"
#import "GKCenterViewController.h"
#import "GKLeftViewController.h"
#import "GKRightViewController.h"
#import "MMExampleDrawerVisualStateManager.h"


@implementation GKAppDelegate

@synthesize window = _window;
@synthesize HUD = _HUD;
@synthesize sinaweibo;
@synthesize viewController = _viewController;
@synthesize activity = _activity;
@synthesize hostReach = _hostReach;
@synthesize tracker = tracker_;
@synthesize drawerController = _drawerController;

#pragma mark- 系统
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    if (application)
    {
        application.applicationIconBadgeNumber = 0;
    }
    //启动缓存区
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 diskCapacity:1024 * 1024 * 5 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [GKVersion getAppVersionWithBlock:^(NSDictionary *dict, NSError *error) {
        if(!error)
        {
            GKVersion * _version = [dict objectForKey:@"content"];
            if([_version.device isEqual: @"iPhone"])
            {
                NSString  *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                BOOL hasNewVersion = [NSString CompareVersionFromOldVersion:localVersion newVersion:_version.version];
                NSString *_versionmessage;
                if((NSNull *)_version.message != [NSNull null])
                {
                    _versionmessage =_version.message;
                }
                else
                {
                    _versionmessage= @"";
                }
                
                if(hasNewVersion)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本啦\U0001F603" message:_versionmessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去升级", nil];
                    [alertView show];
                }
            }
        }
    }];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.viewController = [[SNViewController alloc] init];
    //微博
    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kGK_WeiboAPPKey appSecret:kGK_WeiboSecret appRedirectURI:kGK_WeiboRedirectURL andDelegate:_viewController];
    
    //注册app 到 微信
    [WXApi registerApp:kGK_WeixinShareKey];
    
    [GAI sharedInstance].debug = NO;
    [GAI sharedInstance].dispatchInterval = 60;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kGK_GAnalyticsAccountId];
    
    self.window = [[CPMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    

    
    //设置状态栏为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"stage"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"stage"];
    }
    
    //如果是第一次启动则开启引导页，否则进入rootViewController
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:@"hadTipShake"];
    }
    //用了判断是不是正在同步请求
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])//判读是否为第一次启动
    {
        if([GKDevice isRetinaScreen])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"useBigImg"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:@"useBigImg"];
        }
        GKLog(@"是第一次启动");
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"新用户"
                                                        withAction:nil
                                                         withLabel:nil
                                                         withValue:nil];
        GKUserGuideViewController *userGuideViewController = [[GKUserGuideViewController alloc] init];
        self.window.rootViewController = userGuideViewController;
    }
    else
    {
        GKLog(@"不是第一次启动");
        UIViewController * leftSideDrawerViewController = [[GKLeftViewController alloc] init];
        
        UIViewController * centerViewController = [[GKCenterViewController alloc] init];
        
        UIViewController * rightSideDrawerViewController = [[GKRightViewController alloc] init];
        
        GKNavigationController * navigationController = [[GKNavigationController alloc] initWithRootViewController:centerViewController];
        
        self.drawerController = [[GKRootViewController alloc]
                                                    initWithCenterViewController:navigationController
                                                    leftDrawerViewController:leftSideDrawerViewController
                                                    rightDrawerViewController:rightSideDrawerViewController];
        [_drawerController setMaximumLeftDrawerWidth:260.0];
        [_drawerController setMaximumRightDrawerWidth:220.0];
        [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [_drawerController setShouldStretchDrawer:NO];
        [_drawerController setShowsShadow:YES];
        [_drawerController
         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager]
                      drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block){
                 block(drawerController, drawerSide, percentVisible);
             }
         }];

        self.window.rootViewController = _drawerController;
    }
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"打开应用"
                                                    withAction:nil
                                                     withLabel:nil
                                                     withValue:nil];
    self.window.backgroundColor = [UIColor blackColor];
    [self customizeAppearance];
    
    [self.window makeKeyAndVisible];
    self.hostReach = [Reachability reachabilityForInternetConnection];
    [self updateInterfaceWithReachability:self.hostReach];
    [_hostReach startNotifier];
    
    if (![kUserDefault stringForKey:kSession])
    {
        GKLoginViewController *loginVC = [[GKLoginViewController alloc] init];
        [self.window.rootViewController presentViewController: loginVC animated:NO completion:NULL];
    }

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    GKLog(@"%@", deviceToken);
    if(!TARGET_IPHONE_SIMULATOR)
    {
        NSString *devToken = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString:@"<"withString:@""]
                               stringByReplacingOccurrencesOfString:@">" withString:@""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
        [GKNotification postNotificationInfoWithDeviceToken:devToken Block:^(BOOL is_success, NSError *error) {
            if (!error)
            {

            }
        }];
    }
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    GKLog(@"FailToRegisterForRemoteNotifications: %@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive )
    {
        
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[[GKAppDotNetAPIClient sharedClient]operationQueue]cancelAllOperations];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (application)
    {
        application.applicationIconBadgeNumber = 0;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    SinaWeibo *sinaweibodata = [self sinaweibo];
    GKUser *user = [[GKUser alloc]initFromSQLite];
    if(user.weibo_token.user_id !=0)
    {
        sinaweibodata.userID = [NSString stringWithFormat:@"%lld",user.weibo_token.weibo_id];
        sinaweibodata.accessToken= user.weibo_token.access_token;
        sinaweibodata.expirationDate =[NSDate dateWithTimeIntervalSinceNow:user.weibo_token.expires_in];
    }
    [self.sinaweibo applicationDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if([[url absoluteString]hasPrefix:@"sinaweibosso"])
    {
        return [self.sinaweibo handleOpenURL:url];
    }
    if([[url absoluteString]hasPrefix:@"wx"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return NO;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([[url absoluteString]hasPrefix:@"sinaweibosso"])
    {
        return [self.sinaweibo handleOpenURL:url];
    }
    if([[url absoluteString]hasPrefix:@"wx"])
    {
        NSString *absoluteString = [url absoluteString];
        NSRange range = [absoluteString rangeOfString:@"detail/"];
        if (range.location != NSNotFound) {
            NSString *cardID = [absoluteString substringFromIndex:range.location+range.length];
            [self showDetailFromWXWithCardID:cardID];
        }
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return NO;
}
- (void)showDetailFromWXWithCardID:(NSString *)cardID
{
    if (cardID.length > 0) {
        
        //GKDetailViewController *detailVC = [[GKDetailViewController alloc] initWithEntityID:[cardID integerValue]];
        GKDetailViewController *detailVC = [[GKDetailViewController alloc] init];
        GKNavigationController *navi = [[GKNavigationController alloc] initWithRootViewController:detailVC];
        UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [backBTN setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backBTN setImageEdgeInsets:UIEdgeInsetsMake(0, -20.0f, 0, 0)];
        [backBTN addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBTN];
        [navi.navigationItem setLeftBarButtonItem:back animated:YES];
        detailVC.hidesBottomBarWhenPushed = YES;
        
        [self.window.rootViewController presentViewController: navi animated:YES completion:NULL];
    }
}
- (void)cancelButtonAction:(id)sender
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark- 单例


#pragma mark - MBProgressHUD
- (MBProgressHUD *)sharedHUD
{
    if (_HUD) {
        [_HUD removeFromSuperview];
        self.HUD = nil;
    }
    self.HUD = [[MBProgressHUD alloc] initWithWindow:_window];
    [_window addSubview:_HUD];
    _HUD.delegate = self;
    return _HUD;
}

#pragma mark - Activity
- (UIActivityIndicatorView *)sharedActivity
{
    if(_activity)
    {
        [_activity removeFromSuperview];
    }
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activity.backgroundColor = [UIColor blackColor];
    [_activity setCenter:CGPointMake(160, self.window.frame.size.height/2-20)];
    _activity.layer.cornerRadius = 4;
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.window addSubview:_activity];
    
    return _activity;
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_HUD removeFromSuperview];
    self.HUD = nil;
}

- (GKStatusBar *)sharedStatusBar
{
    if (!_statusBar) {
        self.statusBar = [[GKStatusBar alloc] initWithFrame:CGRectZero];
    }
    return _statusBar;
}

-(void)customizeAppearance
{
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"topbar.png"]forBarMetrics:UIBarMetricsDefault];    
}
- (void)showLoginView
{
    GKLoginViewController *loginVC = [[GKLoginViewController alloc] init];
    [self.window.rootViewController presentViewController: loginVC animated:YES completion:NULL];
}

- (void)reachabilityChanged:(NSNotification *)info
{
    Reachability *curReach = [info object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)curReach
{
    NetworkStatus networkStatus = [curReach currentReachabilityStatus];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    switch (networkStatus) {
        case NotReachable:
        {
            [userDefault setObject:@"NotReachable" forKey:@"networkStatus"];
            [GKMessageBoard showMBWithText:@"似乎已与互联网断开连接" customView:
             [[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
        }
            break;
        case ReachableViaWiFi:
        {
            [userDefault setObject:@"WIFI" forKey:@"networkStatus"];
        }
            break;
        case ReachableViaWWAN:
        {
            [userDefault setObject:@"WWAN" forKey:@"networkStatus"];
        }
            break;
        default:
            break;
    }
    
    [userDefault synchronize];
}

-(void) onResp:(BaseResp*)resp
{
    
    if(resp.errCode == 0)
    {
        [GKMessageBoard showMBWithText:@"分享成功\U0001F603" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
    else
    {
        [GKMessageBoard showMBWithText:@"分享失败\U0001F628" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString* url = [NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kGK_AppID_iPhone];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
    
}
@end

