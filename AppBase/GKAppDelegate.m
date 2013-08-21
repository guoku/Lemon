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
#import "GKLoadingViewController.h"
#import "GKMessages.h"
#import "MobClick.h"
#import "UMFeedbackViewController.h"
#import "GKMessageViewController.h"
#import "UIViewController+MMDrawerController.h"


@implementation GKAppDelegate
{
@private bool loadingEntity;
}

@synthesize window = _window;
@synthesize HUD = _HUD;
@synthesize sinaweibo;
@synthesize viewController = _viewController;
@synthesize activity = _activity;
@synthesize hostReach = _hostReach;
@synthesize tracker = tracker_;
@synthesize drawerController = _drawerController;
@synthesize needRequestEntityArray = _needRequestEntityArray;
@synthesize navigationController = _navigationController;
@synthesize centerViewController = _centerViewController;
@synthesize messageRemind = _messageRemind;

#pragma mark- 系统
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [EGG launchWithAppToken:@"9c8aff14d2583954082d72e7e5175c92"];
    [MobClick startWithAppkey:@"51f215d556240b3094053a48"];
    [MobClick beginEvent:@"app_launch"];
    [UMFeedback setLogEnabled:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(umCheck:) name:UMFBCheckFinishedNotification object:nil];

    //[MobClick startWithAppkey:@"51f215d556240b3094053a48" reportPolicy:REALTIME channelId:nil];
    if (application)
    {
        application.applicationIconBadgeNumber = 0;
        loadingEntity =NO;
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
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"pid"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"pid"];
    }
    

        UIViewController * leftSideDrawerViewController = [[GKLeftViewController alloc] init];
        
        _centerViewController = [[GKCenterViewController alloc] init];
        
        UIViewController * rightSideDrawerViewController = [[GKRightViewController alloc] init];
        
        _navigationController = [[GKNavigationController alloc] initWithRootViewController:_centerViewController];
        
        self.drawerController = [[GKRootViewController alloc]
                                                    initWithCenterViewController:_navigationController
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


    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"打开应用"
                                                    withAction:nil
                                                     withLabel:nil
                                                     withValue:nil];
    self.window.backgroundColor = [UIColor blackColor];
    [self customizeAppearance];
    
    [self.window makeKeyAndVisible];
    
    if (![kUserDefault stringForKey:kSession])
    {
        GKLoginViewController * _loginVC = [[GKLoginViewController alloc] init];
        [self.window.rootViewController presentViewController: _loginVC animated:NO completion:NULL];
    }
    else
    {
        GKUser * me = [[GKUser alloc]initFromNSU];
        if (me.stage == 0) {
            GKLoginViewController * _loginVC = [[GKLoginViewController alloc] init];
            [self.window.rootViewController presentViewController: _loginVC animated:NO completion:NULL];
        }
        else
        {
            GKLoadingViewController * VC = [[GKLoadingViewController alloc] init];
            [self.window.rootViewController presentViewController: VC animated:NO completion:NULL];
        }
    }
    
    //检测网络状况
    self.hostReach = [Reachability reachabilityForInternetConnection];
    [self updateInterfaceWithReachability:self.hostReach];
    [_hostReach startNotifier];

    NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:20.0f
                                                       target:self
                                                     selector:@selector(getEntity)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:120.0f
                                                       target:self
                                                     selector:@selector(checkUM)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    NSTimer *_timer2 = [NSTimer scheduledTimerWithTimeInterval:20.0f
                                                       target:self
                                                     selector:@selector(checkNewMessage)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer2 forMode:NSRunLoopCommonModes];
    [self checkNewMessage];
    
    [self checkUM];

    [MobClick endEvent:@"app_launch"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    _messageRemind = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    _messageRemind.center = CGPointMake(kScreenWidth+40, kScreenHeight-20);
    //_messageRemind.backgroundColor = UIColorFromRGB(0x98d9cb);
    //[_messageRemind setBackgroundImage:[[UIImage imageNamed:@"button_flat.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5 ] forState:UIControlStateNormal];
    //[_messageRemind setBackgroundImage:[[UIImage imageNamed:@"button_flat_gray.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5 ] forState:UIControlStateNormal|UIControlStateHighlighted];
    [_messageRemind setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [_messageRemind setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    _messageRemind.layer.cornerRadius = 5.0;
    [_messageRemind.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:9.0f]];
    _messageRemind.titleLabel.textAlignment = UITextAlignmentCenter;
    _messageRemind.titleLabel.numberOfLines = 0;
    [_messageRemind setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_messageRemind addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //_messageRemind.hidden = YES;
    [self.window addSubview:_messageRemind];
    
    return YES;
}
- (void)checkUM
{
    [UMFeedback checkWithAppkey:UMENG_APPKEY];
}
-(void)checkNewMessage
{
    [GKMessages getUserUnreadMessageCountWithBlock:^(NSUInteger count, NSError * error)
     {
         if (!error) {
             if (count>0) {
                [_messageRemind setTitle:[NSString stringWithFormat:@"新消息\
                                          %d条",count] forState:UIControlStateNormal];
                 [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                     _messageRemind.center = CGPointMake(kScreenWidth-30, kScreenHeight-20);
                 } completion:^(BOOL finished) {
                     
                 }];
             }
             else
             {
                 [UIView animateWithDuration:0.3 animations:^{
                     _messageRemind.center = CGPointMake(kScreenWidth+30, kScreenHeight-20);
                 }];
             }
         }
     }];
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
    if([kUserDefault objectForKey:@"sina_user_id"])
    {
    sinaweibodata.userID = [kUserDefault objectForKey:@"sina_user_id"];
    sinaweibodata.accessToken= [kUserDefault objectForKey:@"sina_access_token"];
    sinaweibodata.expirationDate =[NSDate dateWithTimeIntervalSinceNow:[[kUserDefault objectForKey:@"sina_expires_in"] integerValue]];
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
        UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 32)];
        [backBTN setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
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
            //[GKMessageBoard showMBWithText:@"WIFI已连接" customView:
            // [[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            [userDefault setObject:@"WIFI" forKey:@"networkStatus"];
        }
            break;
        case ReachableViaWWAN:
        {
           // [GKMessageBoard showMBWithText:@"蜂窝网络" customView:
           //  [[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
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
    if(alertView.tag == 10086)
    {
        if (buttonIndex == 1) {
            [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
        } else {
            
        }
        return;
    }
    else
    {
        if(buttonIndex == 1)
        {
            NSString* url = [NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kGK_AppID_iPhone];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }
    }
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    [self.window.rootViewController presentModalViewController:navigationController animated:YES];
}
- (void)getEntity
{
    if(!loadingEntity)
    {
    loadingEntity = YES;
    NSArray * array = [GKEntity getNeedResquestEntity];
        if([array count]!=0)
        {
            [GKEntity getEntityByArray:array Block:^(NSArray *entitylist, NSError *error) {
                if (!error) {
                    for (GKEntity * entity in entitylist) {
                        for(NSString  * pidString in entity.pid_list ) {
                            entity.pid = [pidString integerValue];
                            [entity save];
                        }
                    }
                    [self.centerViewController stageChange];
                }
                else
                {
                
                }
                loadingEntity = NO;
            }];
        }
        else
        {
            loadingEntity = NO;
        }
    }
}
- (void)umCheck:(NSNotification *)notification {
    UIAlertView *alertView;

    if (notification.userInfo) {
        NSArray *newReplies = [notification.userInfo objectForKey:@"newReplies"];
        NSLog(@"newReplies = %@", newReplies);
        NSString *title = [NSString stringWithFormat:@"%d条新消息", [newReplies count]];
        NSMutableString *content = [NSMutableString string];
        for (NSUInteger i = 0; i < [newReplies count]; i++) {
          //  NSString *dateTime = [[newReplies objectAtIndex:i] objectForKey:@"datetime"];
            NSString *_content = [[newReplies objectAtIndex:i] objectForKey:@"content"];
    
            //[content appendString:[NSString stringWithFormat:@"%d .......%@.......\r\n", i + 1, dateTime]];
            [content appendString:[NSString  stringWithFormat:@"意见反馈回复：%@",_content ]];
            [content appendString:@"\r\n\r\n"];
        }
        
        alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alertView.tag = 10086;
        ((UILabel *) [[alertView subviews] objectAtIndex:1]).textAlignment = NSTextAlignmentLeft;
            [alertView show];
    } else {
    //alertView = [[UIAlertView alloc] initWithTitle:@"没有新回复" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    }

}
- (void)messageButtonAction
{
    if([kAppDelegate.window.rootViewController.presentedViewController isKindOfClass:[GKNavigationController class]])
    {
    
        GKNavigationController * nav = (GKNavigationController *)(kAppDelegate.window.rootViewController.presentedViewController);
        if([nav.viewControllers[0] isKindOfClass:[GKMessageViewController class]])
        {
            [nav popToRootViewControllerAnimated:YES];
            [nav.viewControllers[0] refresh];
            return;
        }
        else
        {
            [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                GKMessageViewController *VC = [[GKMessageViewController alloc]init];
                UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
                [backBTN setImage:[UIImage imageNamed:@"button_icon_close.png"] forState:UIControlStateNormal];
                [backBTN setImage:[UIImage imageNamed:@"button_icon_close.png"] forState:UIControlStateHighlighted];
                UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
                [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
                [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
                [backBTN addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                VC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
                VC.navigationItem.rightBarButtonItem = nil;
                GKNavigationController *nav = [[GKNavigationController alloc]initWithRootViewController:VC];
                //[_messageRemind setBackgroundImage:[[UIImage imageNamed:@"button_flat_gray.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5 ] forState:UIControlStateNormal];
                //[_messageRemind setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [self.window.rootViewController presentViewController:nav animated:YES completion:^{
                    
                }];
            }];
        }
    }
    else
    {

        GKMessageViewController *VC = [[GKMessageViewController alloc]init];
        UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
        [backBTN setImage:[UIImage imageNamed:@"button_icon_close.png"] forState:UIControlStateNormal];
        [backBTN setImage:[UIImage imageNamed:@"button_icon_close.png"] forState:UIControlStateHighlighted];
        UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
        [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
        [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
        [backBTN addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        VC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
        VC.navigationItem.rightBarButtonItem = nil;
        GKNavigationController *nav = [[GKNavigationController alloc]initWithRootViewController:VC];
        //[_messageRemind setBackgroundImage:[[UIImage imageNamed:@"button_flat_gray.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5 ] forState:UIControlStateNormal];
        //[_messageRemind setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [self.window.rootViewController presentViewController:nav animated:YES completion:^{

        }];
    }
    
}
- (void)hideMessageRemind
{
    [UIView animateWithDuration:0.3 animations:^{
        _messageRemind.center = CGPointMake(kScreenWidth+30, kScreenHeight-20);
    } completion:^(BOOL finished) {
        //[_messageRemind setBackgroundImage:[[UIImage imageNamed:@"button_flat.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5 ] forState:UIControlStateNormal];
        //[_messageRemind setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }];
}
@end

