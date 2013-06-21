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
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kScreenHeight-300, kScreenWidth, 300)];
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
