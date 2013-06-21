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
	// Do any additional setup after loading the view.
    _sinaBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,120, 24)];
    _sinaBtn.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [_sinaBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_sinaBtn setImage:[UIImage imageNamed:@"icon_sina.png" ]forState:UIControlStateNormal];
    [_sinaBtn setTitleColor:kColor666666 forState:UIControlStateNormal];
    [_sinaBtn.titleLabel setTextAlignment:UITextAlignmentLeft];
    _sinaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
