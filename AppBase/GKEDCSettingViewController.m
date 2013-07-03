//
//  GKEDCSettingViewController.m
//  MMM
//
//  Created by huiter on 13-6-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEDCSettingViewController.h"
#import "GKAppDelegate.h"
@interface GKEDCSettingViewController ()

@end

@implementation GKEDCSettingViewController
{
    @private UIDatePicker *datePicker;
    CGFloat y1;
    UILabel * tip;
    UIButton *button;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.titleView = [GKTitleView  setTitleLabel:@"最后一步"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    if(kScreenHeight == 548)
    {
        y1 = 60;
    }
    else
    {
        y1 = 20;
    }
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
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
        
    button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-50, 40)];
    button.center = CGPointMake(kScreenWidth/2, headerView.frame.size.height+y1);
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_button_icon%d.png",4]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_button_icon%d.png",4]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
    [button.titleLabel setTextAlignment:UITextAlignmentLeft];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:kColor555555 forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [button addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"state"]isEqualToString:@"pregnant"])
    {
        [button setTitle:@"设定宝宝预产期" forState:UIControlStateNormal];
    }
    else if([[userDefault objectForKey:@"state"]isEqualToString:@"born"])
    {
        [button setTitle:@"设定宝宝生日" forState:UIControlStateNormal];
    }
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrow.tag = 110;
    arrow.center = CGPointMake(button.frame.size.width-25, button.frame.size.height/2);
    
    [button addSubview:arrow];
    
    tip = [[UILabel alloc]initWithFrame:CGRectMake(155, 0, 80,12)];
    tip.center = CGPointMake(tip.center.x, button.frame.size.height/2+1);
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentCenter;
    [tip setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    tip.textColor = UIColorFromRGB(0x999999);
    
    [button addSubview:tip];
    
    button.enabled = NO;

    [self.view addSubview:button];

    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kScreenHeight-250, kScreenWidth, 200)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:datePicker];
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:YES];
    [datePicker addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];

    tip.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"yyyy.MM.dd"];
    
}
- (void)TapButtonAction:(id)sender
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"state"]isEqualToString:@"pregnant"])
    {
        if([[datePicker.date earlierDate:[NSDate date]] isEqualToDate:datePicker.date])
        {
            NSLog(@"%@",[NSDate date]);
            NSLog(@"%@",datePicker.date);
            [GKMessageBoard showMBWithText:@"预产期不能早于当前日期" customView:
             [[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"userstage"];
        [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"stage"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfileChange" object:nil userInfo:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您目前正处于预产阶段-孕中期\U0001F603" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"妈妈清单，GO！", nil];
        [alertView show];
    }
    else if([[userDefault objectForKey:@"state"]isEqualToString:@"born"])
    {
        if(![[datePicker.date earlierDate:[NSDate date]]isEqualToDate:datePicker.date])
        {
            [GKMessageBoard showMBWithText:@"出生日期不能晚于当前日期" customView:
             [[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:@(6) forKey:@"stage"];
        [[NSUserDefaults standardUserDefaults] setObject:@(6) forKey:@"userstage"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfileChange" object:nil userInfo:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您的宝宝已经3个月啦\U0001F603" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"妈妈清单，GO！", nil];
        [alertView show];
    }
    

}
- (void)change
{
    tip.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"yyyy.MM.dd"];
    button.enabled = YES;
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
