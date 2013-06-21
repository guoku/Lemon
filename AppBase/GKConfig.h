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
#define kGK_GAnalyticsAccountId @"UA-33667018-1"
#endif

#ifndef kGK_AppID_iPhone
#define kGK_AppID_iPhone @"477652209"
#endif
// guoku api base url
#define kGKAppBaseURL @"http://api.guoku.com/mobile/v2/"

#define kGuokuApiKey @"0b19c2b93687347e95c6b6f5cc91bb87"
#define kGuokuApiSecret @"47b41864d64bd46"

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
#define kGK_WeiboAPPKey @"1459383851"
#endif

#ifndef kGK_WeiboSecret
#define kGK_WeiboSecret @"bfb2e43c3fa636f102b304c485fa2110"
#endif

#ifndef kGK_WeiboRedirectURL
#define kGK_WeiboRedirectURL @"http://www.guoku.com/sina/auth"
#endif

//weixin
#ifndef kGK_WeixinShareKey
#define kGK_WeixinShareKey	@"wx59118ccde8270caa"		//REPLACE ME
#endif

#ifndef kGK_WeixinShareURL
#define kGK_WeixinShareURL @"http://www.guoku.com/weixin/present/"  //apisent
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

#ifndef kColorb6ada6
#define kColorb6ada6 [UIColor colorWithRed:182.0f / 255.0f green:173.0f / 255.0f blue:166.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColorfecbc4
#define kColorfecbc4 [UIColor colorWithRed:254.0f / 255.0f green:203.0f / 255.0f blue:196.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColore2ddd9
#define kColore2ddd9 [UIColor colorWithRed:226.0f / 255.0f green:221.0f / 255.0f blue:217.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColorebe7e4
#define kColorebe7e4 [UIColor colorWithRed:235.0f / 255.0f green:231.0f / 255.0f blue:228.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColored5c49
#define kColored5c49 [UIColor colorWithRed:237.0f / 255.0f green:92.0f / 255.0f blue:73.0 / 255.0f alpha:1.0f]
#endif

//灰色
#ifndef kColorf9f9f9
#define kColorf9f9f9 [UIColor colorWithRed:249.0f / 255.0f green:249.0f / 255.0f blue:249.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColorf2f2f2
#define kColorf2f2f2 [UIColor colorWithRed:242.0f / 255.0f green:242.0f / 255.0f blue:242.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColorf1f1f1
#define kColorf1f1f1 [UIColor colorWithRed:241.0f / 255.0f green:241.0f / 255.0f blue:241.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColore4e4e4
#define kColore4e4e4 [UIColor colorWithRed:228.0f / 255.0f green:228.0f / 255.0f blue:228.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColorc6c6c6
#define kColorc6c6c6 [UIColor colorWithRed:198.0f / 255.0f green:198.0f / 255.0f blue:198.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColor666666
#define kColor666666 [UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColor555555
#define kColor555555 [UIColor colorWithRed:85.0f / 255.0f green:85.0f / 255.0f blue:85.0 / 255.0f alpha:1.0f]
#endif

#ifndef kColorc8c8c8
#define kColorc8c8c8 [UIColor colorWithRed:200.0f / 255.0f green:200.0f / 255.0f blue:200.0 / 255.0f alpha:1.0f]
#endif



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
#define kGK_PopSucceedText [NSString stringWithFormat:@"已返回顶端，继续刷果库吧 %@",smile]
#endif

#ifndef kGK_PopFailText
#define kGK_PopFailText [NSString stringWithFormat:@"不要闹，已在最顶端了 %@",smile]
#endif
