//
//  GKStateChooseViewController.m
//  MMM
//
//  Created by huiter on 13-6-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKStateChooseViewController.h"
#import "GKAppDelegate.h"
#import "GKEDCSettingViewController.h"
#import "GKUser.h"
#import "UIViewController+MMDrawerController.h"

@interface GKStateChooseViewController ()

@end

@implementation GKStateChooseViewController
{
    @private GKUser *user;
    CGFloat h1;
    UIView * bg;
}


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
    self.trackedViewName = @"状态选择页";
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"欢迎加入"];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bg.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:bg];
    if(kScreenHeight == 548)
    {
        h1 = 145;
    }
    else
    {
        h1 = 120;
    }
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,h1)];
    headerView.backgroundColor = UIColorFromRGB(0xe6e1de);
    [bg addSubview:headerView];
    
    user =[[GKUser alloc ]initFromNSU];
    
    GKUserButton * avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
    avatar.center = CGPointMake(kScreenWidth/2, 57);
    avatar.user = user;
    [bg addSubview:avatar];
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-150, 25)];
    name.center = CGPointMake(kScreenWidth/2, avatar.frame.origin.y+avatar.frame.size.height+14);
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentCenter;
    [name setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    name.textColor = UIColorFromRGB(0x555555);
    name.text = user.nickname;
    [bg addSubview:name];
    
    UILabel * description = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-100,30)];
    description.center = CGPointMake(kScreenWidth/2, name.frame.origin.y+name.frame.size.height+4);
    description.backgroundColor = [UIColor clearColor];
    description.numberOfLines = 0;
    description.textAlignment = NSTextAlignmentCenter;
    [description setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    description.textColor = UIColorFromRGB(0x999999);
    description.text = user.bio;
    [bg addSubview:description];
    
    UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-100,12)];
    tip.center = CGPointMake(kScreenWidth/2, headerView.frame.size.height+42);
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentCenter;
    [tip setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    tip.textColor = UIColorFromRGB(0x999999);
    tip.text = @"请选择您当前的状态";
    [bg addSubview:tip];
    
    int i =1;
    
    NSArray * dataArray = [NSArray arrayWithObjects:@"准备怀孕",@"已怀孕",@"宝宝已降生",nil];
    for (i= 1 ; i<=3; i++) {
    
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, tip.frame.origin.y+tip.frame.size.height+29-50+i*50, kScreenWidth-50, 44)];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_button_icon%d.png",i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_button_icon%d.png",i]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button setTitle:[dataArray objectAtIndex:i-1] forState:UIControlStateNormal];
        
        UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        arrow.tag = 110;
        arrow.center = CGPointMake(button.frame.size.width-30, button.frame.size.height/2);
        
        [button addSubview:arrow];
                
        [bg addSubview:button];
    
    }
    
}

- (void)TapButtonAction:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    switch (((UIButton *)sender).tag) {
        case 1:
        {
            [userDefault setObject:@"prepare" forKey:@"state"];
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"userstage"];
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"pid"];
         
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您选择了 准备怀孕 。" delegate:self cancelButtonTitle:@"重新设定阶段" otherButtonTitles:@"进入妈妈清单", nil];
            [alertView show];
        }
            break;
        case 2:
        {
                [userDefault setObject:@"pregnant" forKey:@"state"];
                GKEDCSettingViewController *VC = [[GKEDCSettingViewController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
        {
                [userDefault setObject:@"born" forKey:@"state"];
                GKEDCSettingViewController *VC = [[GKEDCSettingViewController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];

        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
        [user changeStageWithStage:1 Date:nil Block:^(NSDictionary *dict, NSError *error) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
            if(!error)
            {
                [GKMessageBoard showMBWithText:@"阶段设置成功" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
                [UIView animateWithDuration:0.5 animations:^{
                    bg.alpha = 0;
                } completion:^(BOOL finished) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfileChange" object:nil userInfo:nil];
                    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
                    [self.mm_drawerController setCenterViewController:delegate.navigationController withFullCloseAnimation:NO completion:^(BOOL finished) {
                    }];
                    [delegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }];
            }
            else
            {
                [GKMessageBoard showMBWithText:@"与服务器同步状态时网络出错，请重试" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            }
        }];
        
    }
    
}
@end
