//
//  GKBaseViewController.m
//  Grape
//
//  Created by huiter on 13-4-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKDetailViewController.h"
#import "GKUserViewController.h"
#import "GKFollowViewController.h"
#import "DPCardWebViewController.h"
#import "GKAppDotNetAPIClient.h"
#import "GAI.h"
#import "GKAppDelegate.h"
#import "GKNoteCommentViewController.h"

@interface GKBaseViewController ()

@end

@implementation GKBaseViewController

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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    if([self.navigationController.viewControllers count] >3)
    {

        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hadTipShake"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"妈妈清单小提示：\n摇晃设备可迅速返回最上层" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道啦", nil];
            alertView.tag = 25001;
            [alertView show];
        }
    }
     */
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
#pragma mark Delegate
- (void)showDetailWithEntityID:(NSUInteger)entity_id
{
    
    GKDetailViewController *VC = [[GKDetailViewController alloc] initWithEntityID:entity_id];
    VC.hidesBottomBarWhenPushed = YES;
    if(self.navigationController)
    {
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:YES];
        }];
    }
}
- (void)showDetailWithData:(GKEntity*)data
{
    
    GKDetailViewController *VC = [[GKDetailViewController alloc] initWithDate:data];
    VC.hidesBottomBarWhenPushed = YES;
    if(self.navigationController)
    {
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:YES];
        }];
    }

}

- (void)showUserWithUserID:(NSUInteger)user_id
{
    GKUserViewController *VC = [[GKUserViewController alloc] initWithUserID:user_id];
    VC.hidesBottomBarWhenPushed = YES;
    if(self.navigationController)
    {
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:YES];
    }];
    }

}
- (void)showUserFollowWithUserID:(NSUInteger)user_id
{
    GKFollowViewController *VC = [[GKFollowViewController alloc]initWithUserID:user_id withGroup:@"follow"];
    VC .hidesBottomBarWhenPushed = YES;
    if(self.navigationController)
    {
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:YES];
        }];
    }
}
- (void)showUserFansWithUserID:(NSUInteger)user_id
{
    GKFollowViewController *VC = [[GKFollowViewController alloc]initWithUserID:user_id withGroup:@"fan"];
    VC.hidesBottomBarWhenPushed = YES;
    if(self.navigationController)
    {
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:YES];
        }];
    }
}
- (void)showWebViewWithTaobaoid:(NSString *)taobao_id
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                    withAction:@"go_taobao"
                                                     withLabel:nil
                                                     withValue:nil];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    NSString * TTID = [NSString stringWithFormat:@"%@_%@",kTTID_IPHONE,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *sid = @"";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginTaobaoUserInfo"] objectForKey:@"sid"])
    {
        sid = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginTaobaoUserInfo"] objectForKey:@"sid"]];
    }
    
    NSString *url = [NSString stringWithFormat:@"i%@.htm?ttid=%@&sid=%@&sche=tb21563453", taobao_id, TTID,sid];
    GKLog(@"%@",url);
    
    DPCardWebViewController * _webVC = [DPCardWebViewController linksWebViewControllerWithURL:[NSURL URLWithString:url relativeToURL:kTaoBaoBaseWapURL]];
    
    _webVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController * _navi = [[UINavigationController alloc] initWithRootViewController:_webVC] ;
    [self presentViewController:_navi animated:YES completion:NULL];
    
}
- (void)showWebViewWithTaobaoUrl:(NSString *)taobao_url
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                    withAction:@"go_taobao"
                                                     withLabel:nil
                                                     withValue:nil];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    NSString * TTID = [NSString stringWithFormat:@"%@_%@",kTTID_IPHONE,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *sid = @"";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginTaobaoUserInfo"] objectForKey:@"sid"])
    {
        sid = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginTaobaoUserInfo"] objectForKey:@"sid"]];
    }
    taobao_url = [taobao_url stringByReplacingOccurrencesOfString:@"&type=mobile" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@&ttid=%@&sid=%@&type=mobile&outer_code=IPE&sche=tb21563453",taobao_url, TTID,sid];
    GKUser *user = [[GKUser alloc ]initFromNSU];
    if(user.user_id !=0)
    {
        url = [NSString stringWithFormat:@"%@%u",url,user.user_id];
    }
    GKLog(@"%@",url);
    DPCardWebViewController * _webVC = [DPCardWebViewController linksWebViewControllerWithURL:[NSURL URLWithString:url]];
    
    _webVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController * _navi = [[UINavigationController alloc] initWithRootViewController:_webVC] ;
    [self presentViewController:_navi animated:YES completion:NULL];
    
}
- (void)showCommentWithNote:(GKNote *)note Entity:(GKEntity *)entity
{
    GKNoteCommentViewController *noteCommentVC = [[GKNoteCommentViewController alloc]initWithNote:note Entity:entity];
    noteCommentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noteCommentVC animated:YES];
}
- (void)showCommentWithNoteID:(NSUInteger)note_id EntityID:(NSUInteger)entity_id
{
    GKNoteCommentViewController *noteCommentVC = [[GKNoteCommentViewController alloc]initWithNoteID:note_id EntityID:entity_id];
    noteCommentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noteCommentVC animated:YES];
}


- (void)backButtonAction:(id)sender
{
    if ([self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 25001)
    {
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hadTipShake"];
    }
    
}
@end
