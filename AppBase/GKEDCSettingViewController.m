//
//  GKEDCSettingViewController.m
//  MMM
//
//  Created by huiter on 13-6-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKEDCSettingViewController.h"
#import "GKAppDelegate.h"
#import "UIViewController+MMDrawerController.h"
@interface GKEDCSettingViewController ()

@end

@implementation GKEDCSettingViewController
{
    @private UIDatePicker *datePicker;
    NSMutableArray * _dataArray;
    CGFloat y1;
    CGFloat h1;
    UILabel * tip;
    UILabel * _year;
    UILabel * _month;
    UILabel * _day;
    UIButton *button;
    UIButton *sendBTN;
    NSUInteger state;
    GKUser * user;
    UIView * bg;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                self.navigationItem.titleView = [GKTitleView  setTitleLabel:@"最后一步"];

       // UIBarButtonItem *followBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sendBTN];
        //[self.navigationItem setRightBarButtonItem:followBtnItem animated:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"预产期设置页";
    _dataArray = [NSMutableArray arrayWithObjects:
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"准备怀孕",@"name",@"0",@"count",@"1",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"孕期",@"name",@"0",@"count",@"2",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"待产与产后",@"name",@"0",@"count",@"5",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0-6个月",@"name",@"0",@"count",@"6",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6-12个月",@"name",@"0",@"count",@"8",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1-3岁",@"name",@"0",@"count",@"9",@"pid",nil]
                  , nil];

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
        y1 = 80;
        h1 = 145;
    }
    else
    {
        y1 = 48;
        h1 = 120;
    }
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bg.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:bg];
    
    
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
        
    button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 50)];
    button.center = CGPointMake(kScreenWidth/2, headerView.frame.size.height+y1);
    //button.userInteractionEnabled = NO;
    //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_button_icon%d.png",4]] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_button_icon%d.png",4]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateHighlighted];
    //[button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateHighlighted];
    //[button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateDisabled];
    [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [button setTitle:@"                  年               月              日" forState:UIControlStateNormal];
    //button.userInteractionEnabled = NO;
    //[button addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    sendBTN = [[UIButton alloc]initWithFrame:CGRectMake(button.frame.size.width-60,9, 50, 32)];
    [sendBTN setTitle:@"保存" forState:UIControlStateNormal];
  
    [sendBTN.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"button_flat.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"button_flat_gray.png"] resizableImageWithCapInsets:insets]forState:UIControlStateDisabled];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"button_flat_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    
    
    
    //[sendBTN setImageEdgeInsets:UIEdgeInsetsMake(0, -20.0f, 0, 0)];
    [sendBTN addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:sendBTN];
    sendBTN.enabled = NO;
    

    
    //UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
    //arrow.tag = 110;
    //arrow.center = CGPointMake(button.frame.size.width-25, button.frame.size.height/2);
    
    //[button addSubview:arrow];
    
    tip = [[UILabel alloc]initWithFrame:CGRectMake(155, 0, 80,12)];
    tip.center = CGPointMake(tip.center.x, button.frame.size.height/2+1);
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentCenter;
    [tip setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    tip.textColor = UIColorFromRGB(0x999999);
    
    //[button addSubview:tip];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, button.frame.origin.y-18,100,15)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    label.textColor = UIColorFromRGB(0x777777);
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"state"]isEqualToString:@"pregnant"])
    {
        //[button setTitle:@"设定宝宝预产期" forState:UIControlStateNormal];
        label.text = @"宝宝预产期";
    }
    else if([[userDefault objectForKey:@"state"]isEqualToString:@"born"])
    {
        //[button setTitle:@"设定宝宝生日" forState:UIControlStateNormal];
        label.text = @"宝宝生日";
    }
    [bg addSubview:label];

    [bg addSubview:button];
    
    _year = [[UILabel alloc]initWithFrame:CGRectMake(6, 9,60,32)];
    _year.backgroundColor = UIColorFromRGB(0xededed);
    _year.numberOfLines = 0;
    _year.layer.cornerRadius = 2;
    _year.textAlignment = NSTextAlignmentCenter;
    [_year setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0f]];
    _year.textColor = UIColorFromRGB(0x777777);
    
    _month = [[UILabel alloc]initWithFrame:CGRectMake(94, 9,36,32)];
    _month.backgroundColor = UIColorFromRGB(0xededed);
    _month.numberOfLines = 0;
    _month.layer.cornerRadius = 2;
    _month.textAlignment = NSTextAlignmentCenter;
    [_month setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0f]];
    _month.textColor = UIColorFromRGB(0x777777);
    
    _day = [[UILabel alloc]initWithFrame:CGRectMake(153, 9,36,32)];
    _day.backgroundColor = UIColorFromRGB(0xededed);
    _day.numberOfLines = 0;
    _day.layer.cornerRadius = 2;
    _day.textAlignment = NSTextAlignmentCenter;
    [_day setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0f]];
    _day.textColor = UIColorFromRGB(0x777777);
    
    [button addSubview:_year];
    [button addSubview:_month];
    [button addSubview:_day];
    

    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kScreenHeight-260, kScreenWidth, 200)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [bg addSubview:datePicker];
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:YES];
    [datePicker addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];
    _year.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"yyyy"];
    _month.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"MM"];
    _day.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"dd"];

    //tip.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"yyyy.MM.dd"];
    
}
- (void)TapButtonAction:(id)sender
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"state"]isEqualToString:@"pregnant"])
    {
        if([[datePicker.date earlierDate:[NSDate date]] isEqualToDate:datePicker.date])
        {
            GKLog(@"%@",[NSDate date]);
            GKLog(@"%@",datePicker.date);
            [GKMessageBoard showMBWithText:@"预产期不能早于当前日期" customView:
             [[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            return;
        }
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *startDate = [NSDate date];
        NSDate *endDate = datePicker.date;
        unsigned int unitFlags = NSDayCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
        int days = [comps day];
        int week = days/7;
        //int month = days/30;
        //int year = days/365;
        if(week<2)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:@"pid"];
            [[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:@"userstage"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"pid"];
            [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"userstage"];
        }
        int i = [[kUserDefault objectForKey:@"userstage"] integerValue];
        NSUInteger stage = [self getIndexByPid:i];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"您目前正处于『%@』\U0001F603",[[_dataArray objectAtIndex:(stage-1)]objectForKey:@"name"]]  delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"进入妈妈清单", nil];
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
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *startDate = datePicker.date;
        NSDate *endDate = [NSDate date];
        unsigned int unitFlags = NSDayCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
        int days = [comps day];
        int week = days/7;
        int month = days/30;
        //int year = days/365;
        if(week<2)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:@"pid"];
            [[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:@"userstage"];
        }
        else if(month<6)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(6) forKey:@"pid"];
            [[NSUserDefaults standardUserDefaults] setObject:@(6) forKey:@"userstage"];
        }
        else if(month<12)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(8) forKey:@"pid"];
            [[NSUserDefaults standardUserDefaults] setObject:@(8) forKey:@"userstage"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(9) forKey:@"pid"];
            [[NSUserDefaults standardUserDefaults] setObject:@(9) forKey:@"userstage"];
        }
        //int i = [[kUserDefault objectForKey:@"userstage"] integerValue];
        //NSUInteger stage = [self getIndexByPid:i];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"您的宝宝已经%d天了啦\U0001F603",days] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"进入妈妈清单", nil];
        [alertView show];
    }
}
- (void)change
{
    //tip.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"yyyy.MM.dd"];
    _year.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"yyyy"];
    _month.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"MM"];
    _day.text = [NSDate stringFromDate:datePicker.date WithFormatter:@"dd"];
    sendBTN.enabled = YES;
    
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
        if([[kUserDefault objectForKey:@"state"]isEqualToString:@"pregnant"])
        {
            state = 2;
        }
        else
        {
            state = 3;
        }
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
        [user changeStageWithStage:state Date:datePicker.date Block:^(NSDictionary *dict, NSError *error) {
            if(!error)
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
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
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (NSUInteger)getIndexByPid:(NSUInteger)pid
{
    for (NSDictionary * dic in _dataArray) {
        if([[dic objectForKey:@"pid"] integerValue] == pid)
        {
            return [_dataArray indexOfObject:dic]+1;
        }
    }
    return 1;
}
@end
