//
//  SNViewController.m
//  Grape
//
//  Created by huiter on 13-3-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "SNViewController.h"
#import "NSDate+GKHelper.h"
#import "GKUser.h"
#import "GKAppDelegate.h"

@interface SNViewController ()

@end

@implementation SNViewController
//@synthesize token = _token;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:sinaweibo.userID,@"uid", nil]
                   httpMethod:@"GET"
                     delegate:self];
    
}

- (SinaWeibo *)sinaweibo
{
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    if(error.code == 21332)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"授权过期，需要重新登录新浪微博" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if(error.code == 21315)
    {
        SinaWeibo *sinaweibo = [self sinaweibo];
        [sinaweibo logIn];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
        [GKMessageBoard showMBWithText:@"网络错误" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = (NSDictionary *)result;
        
//        NSString * screen_name = [data objectForKey:@"screen_name"];
        GKLog(@"user info from weibo %@", data);
        SinaWeibo *sinaweibo = [self sinaweibo];
        GKLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
        //这里拿到新浪微博用户名，之后请求GOUKU服务器进行注册。
        NSUInteger expires_in = [sinaweibo.expirationDate timeIntervalSince1970];
        NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:5];
        [paramters setValue:sinaweibo.userID forKey:@"weibo_id"];
        [paramters setValue:[data valueForKeyPath:@"screen_name"] forKey:@"screen_name"];
        [paramters setValue:sinaweibo.accessToken forKey:@"access_token"];
        [paramters setValue:[NSString stringWithFormat:@"%u", expires_in] forKey:@"expires_in"];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [GKUser registerByWeiboOrTaobaoWithParamters:paramters Type:GKWeiboURLType  Block:^(NSDictionary *dict, NSError *error) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
            if(!error)
            {
                [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"AcountAction"
                                                                withAction:@"login_sina_success"
                                                                 withLabel:nil
                                                                 withValue:nil];
                GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
                [GKMessageBoard showMBWithText:kGK_WeiboLoginSucceedText customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2]; 

            }
        }];
        [paramters setValue:[data valueForKeyPath:@"profile_image_url"] forKey:@"avatar"];
        [userDefault setObject:paramters forKey:@"LoginSinaUserInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
     
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.sinaweibo logOut];
        [delegate.sinaweibo logIn];
    }
}
@end
