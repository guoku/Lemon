//
//  GKLoginViewController.m
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKLoginViewController.h"
#import "GKAppDelegate.h"
@interface GKLoginViewController ()
{
    @private UIButton * _sinaBtn;
}

@end

@implementation GKLoginViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:63.0f / 255.0f blue:56.0 / 255.0f alpha:1.0f];
    
    UIImageView *pic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    pic.image = [UIImage imageNamed:@"login_pic.png"];
    [self.view addSubview:pic];
	// Do any additional setup after loading the view.
    _sinaBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 250,265, 42)];
    _sinaBtn.center = CGPointMake(kScreenWidth/2, _sinaBtn.center.y);
    [_sinaBtn setTitle:@"新浪微博登录" forState:UIControlStateNormal];
    [_sinaBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_sinaBtn setImage:[UIImage imageNamed:@"icon_sina.png" ]forState:UIControlStateNormal];
    [_sinaBtn setBackgroundImage:[UIImage imageNamed:@"button_green.png"] forState:UIControlStateNormal];
    [_sinaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sinaBtn.titleLabel setTextAlignment:UITextAlignmentLeft];
    _sinaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_sinaBtn addTarget:self action:@selector(sinaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sinaBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sinaBtnAction
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"AcountAction"
                                                    withAction:@"try_login_sina"
                                                     withLabel:nil
                                                     withValue:nil];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"YES" forKey:@"isWantToLoginWithSina"];
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.sinaweibo logIn];
}

@end
