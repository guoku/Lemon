//
//  GKEDCSettingViewController.m
//  MMM
//
//  Created by huiter on 13-6-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEDCSettingViewController.h"

@interface GKEDCSettingViewController ()

@end

@implementation GKEDCSettingViewController
{
    @private UIDatePicker *datePicker;
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
    

    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kScreenHeight-200, kScreenWidth, 200)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:datePicker];
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
