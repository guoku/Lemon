//
//  GKConfig.h
//  Grape
//
//  Created by 谢 家欣 on 13-3-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//



#include <QuartzCore/CoreAnimation.h>
#import "GKNotificationConfig.h"

#ifndef kGK_GAnalyticsAccountId
#define kGK_GAnalyticsAccountId @"UA-42384690-1"
#endif

#ifndef kGK_AppID_iPhone
#define kGK_AppID_iPhone @"695659781"
#endif
// guoku api base url
//#define kGKAppBaseURL @"http://api.guoku.com/mobile/v2/"
//#define kGKAppBaseURL @"http://119.167.225.32/mobile/"
#define kGKAppBaseURL @"http://api.guoku.com/mobile/"
//#define kGKAppBaseURL @"http://10.0.1.103/mobile/"
//#define kGuokuApiKey @"49396e9f3573727649f7c9651d0450ed"///@"4abe75e4aa7a7ec59976400e5e3b8fcf"
//#define kGuokuApiSecret @"733f16fde4d1b5876c943ddd85bd214d"//@"a3b4abb1ac8c43cc6095b25a9751a3b3"
#define UMENG_APPKEY @"51f215d556240b3094053a48"
//Pre
//#define kGuokuApiKey @"e7b9472ae626613bab0d049929d3ecc5"
//#define kGuokuApiSecret @"b28c087aa2973da5451321406938e5e1"
//API
#define kGuokuApiKey @"07fac3e6f494b98fd9482c80882d405a"
#define kGuokuApiSecret @"8bdf3f81ae642ef5852a2073f99efdcf"
// guoku user session
#define kUserDefault  [NSUserDefaults standardUserDefaults]
#define kSession @"session"

#define kDeviceToken @"deviceToken"

// guoku db config
#define kDBFILE  @"AppBaseV1.db"

// system
#ifndef isPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif


// weibo
#ifndef kGK_WeiboAPPKey
#define kGK_WeiboAPPKey @"2925244096"
#endif

#ifndef kGK_WeiboSecret
#define kGK_WeiboSecret @"ea309cceda94e73ac81fc6e0035daae1"
#endif

#ifndef kGK_WeiboRedirectURL
#define kGK_WeiboRedirectURL @"http://www.mamaqingdan.com"
#endif

//weixin
#ifndef kGK_WeixinShareKey
#define kGK_WeixinShareKey	@"wx477b7474d17102a1"		//REPLACE ME
#endif

#ifndef kGK_WeixinShareURL
#define kGK_WeixinShareURL @"http://www.mamaqingdan.com/"  //apisent
#endif

// taobao
#define kTaoBaoBaseWapURL [NSURL URLWithString:@"http://a.m.taobao.com/"]

#ifndef kTTID_IPHONE
#define kTTID_IPHONE @"400000_12313170@guoku_iphone"
#endif


// Display
#ifndef kScreenHeight //设备高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#endif
#ifndef kScreenWidth //设备高度
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kAppDelegate ((GKAppDelegate *)[UIApplication sharedApplication].delegate)

#ifndef smile
#define smile @"\U0001F603"
#endif

#ifndef sad
#define sad @"\U0001F628"
#endif

#ifndef kGK_LoginSucceedText
#define kGK_LoginSucceedText [NSString stringWithFormat:@"登录成功，欢迎回来 %@",smile]
#endif

#ifndef kGK_WeiboLoginSucceedText
#define kGK_WeiboLoginSucceedText [NSString stringWithFormat:@"微博登录成功，欢迎回来 %@",smile]
#endif

#ifndef kGK_TaobaoLoginSucceedText
#define kGK_TaobaoLoginSucceedText [NSString stringWithFormat:@"淘宝登录成功，欢迎回来 %@",smile]
#endif

#ifndef kGK_LoginFailText
#define kGK_LoginFailText [NSString stringWithFormat:@"登录失败 %@",sad]
#endif
#ifndef kGK_LogoutSucceedText
#define kGK_LogoutSucceedText [NSString stringWithFormat:@"注销成功 %@",smile]
#endif

#ifndef kGK_LogoutFailText
#define kGK_LogoutFailText [NSString stringWithFormat:@"注销失败 %@",sad]
#endif

#ifndef kGK_RegisterSucceedText
#define kGK_RegisterSucceedText [NSString stringWithFormat:@"注册成功，欢迎加入 %@",smile]
#endif

#ifndef kGK_WeiboRegisterSucceedText
#define kGK_WeiboRegisterSucceedText [NSString stringWithFormat:@"微博注册成功，欢迎加入 %@",smile]
#endif

#ifndef kGK_TaobaoRegisterSucceedText
#define kGK_TaobaoRegisterSucceedText [NSString stringWithFormat:@"淘宝注册成功，欢迎加入 %@",smile]
#endif

#ifndef kGK_WeiboBindSucceedText
#define kGK_WeiboBindSucceedText [NSString stringWithFormat:@"微博绑定成功 %@",smile]
#endif
#ifndef kGK_TaobaoBindSucceedText
#define kGK_TaobaoBindSucceedText [NSString stringWithFormat:@"淘宝绑定成功 %@",smile]
#endif


#ifndef kGK_WeiboUnBindSucceedText
#define kGK_WeiboUnBindSucceedText [NSString stringWithFormat:@"微博解绑成功 %@",smile]
#endif
#ifndef kGK_TaobaoUnBindSucceedText
#define kGK_TaobaoUnBindSucceedText [NSString stringWithFormat:@"淘宝解绑成功 %@",smile]
#endif

#ifndef kGK_RegisterFailText
#define kGK_RegisterFailText [NSString stringWithFormat:@"注册失败 %@",sad]
#endif


#ifndef kGK_PopSucceedText
#define kGK_PopSucceedText [NSString stringWithFormat:@"已返回顶端，继续刷妈妈清单吧 %@",smile]
#endif

#ifndef kGK_PopFailText
#define kGK_PopFailText [NSString stringWithFormat:@"不要闹，已在最顶端了 %@",smile]
#endif
