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
    GKUser * user =[[GKUser alloc ]initFromSQLite];
    
    GKUserButton * avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
    avatar.center = CGPointMake(kScreenWidth/2, 100);
    avatar.user = user;
    [self.view addSubview:avatar];
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-150, 25)];
    name.center = CGPointMake(kScreenWidth/2, 150);
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentCenter;
    [name setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
    name.textColor = [UIColor blackColor];
    name.text = user.nickname;
    [self.view addSubview:name];
    
    int i =1;
    
    NSArray * dataArray = [NSArray arrayWithObjects:@"准备怀孕",@"怀孕了",@"宝宝降生",nil];
    for (i= 1 ; i<=3; i++) {
    
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, 200+i*55, kScreenWidth-60, 40)];
        [button setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow_press.png"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        [button.titleLabel setTextAlignment:UITextAlignmentLeft];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:kColor555555 forState:UIControlStateNormal];
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
    switch (((UIButton *)sender).tag) {
        case 1:
        {
            GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
        
            }];
        }
            break;
        case 2:
        {
            GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                GKEDCSettingViewController *VC = [[GKEDCSettingViewController alloc]init];
                [delegate.window.rootViewController presentViewController: VC animated:NO completion:NULL];
            }];
        }
            break;
        case 3:
        {
            GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                GKEDCSettingViewController *VC = [[GKEDCSettingViewController alloc]init];
                [delegate.window.rootViewController presentViewController: VC animated:NO completion:NULL];
            }];
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

@end
