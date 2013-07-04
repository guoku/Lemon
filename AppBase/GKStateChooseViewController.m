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

@interface GKStateChooseViewController ()

@end

@implementation GKStateChooseViewController


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
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"欢迎加入"];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,145)];
    headerView.backgroundColor = UIColorFromRGB(0xe6e1de);
    [self.view addSubview:headerView];
    
    GKUser * user =[[GKUser alloc ]initFromSQLite];
    
    GKUserButton * avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
    avatar.center = CGPointMake(kScreenWidth/2, 57);
    avatar.user = user;
    [self.view addSubview:avatar];
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-150, 25)];
    name.center = CGPointMake(kScreenWidth/2, avatar.frame.origin.y+avatar.frame.size.height+14);
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentCenter;
    [name setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    name.textColor = UIColorFromRGB(0x555555);
    name.text = user.nickname;
    [self.view addSubview:name];
    
    UILabel * description = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-100,30)];
    description.center = CGPointMake(kScreenWidth/2, name.frame.origin.y+name.frame.size.height+4);
    description.backgroundColor = [UIColor clearColor];
    description.numberOfLines = 0;
    description.textAlignment = NSTextAlignmentCenter;
    [description setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    description.textColor = UIColorFromRGB(0x999999);
    description.text = user.bio;
    [self.view addSubview:description];
    
    UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-100,12)];
    tip.center = CGPointMake(kScreenWidth/2, headerView.frame.size.height+42);
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentCenter;
    [tip setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    tip.textColor = UIColorFromRGB(0x999999);
    tip.text = @"请选择您当前的状态";
    [self.view addSubview:tip];
    
    int i =1;
    
    NSArray * dataArray = [NSArray arrayWithObjects:@"准备怀孕",@"怀孕了",@"宝宝降生",nil];
    for (i= 1 ; i<=3; i++) {
    
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, tip.frame.origin.y+tip.frame.size.height+29-50+i*50, kScreenWidth-50, 40)];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_button_icon%d.png",i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_button_icon%d.png",i]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        [button.titleLabel setTextAlignment:UITextAlignmentLeft];
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
                
        [self.view addSubview:button];
    
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
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"stage"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfileChange" object:nil userInfo:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您选择了准备怀孕阶段，偷偷告诉你生孩子老费钱了!!!\uE411" delegate:self cancelButtonTitle:@"重新选择" otherButtonTitles:@"妈妈清单，GO！", nil];
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
        
        GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
@end
