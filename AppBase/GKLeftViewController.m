//
//  GKLeftViewController.m
//  MMM
//
//  Created by huiter on 13-6-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKLeftViewController.h"
#import "MMMCalendar.h"
#import "MMMLeftCell.h"
#import "UIViewController+MMDrawerController.h"
#import "GKLoginViewController.h"
#import "GKAppDelegate.h"
#import "GKSettingViewController.h"
#import "GKMessageViewController.h"
#import "GKUserViewController.h"

@interface GKLeftViewController ()

@end
@implementation GKLeftViewController
{
@private
    NSMutableArray * _dataArray;
    NSMutableDictionary *dictionary;
    UIView *tableHeaderView;
    UIView *tableFooterView;
    UIButton * message;
    UIButton * setting;
    GKUser *user;
    BOOL selectCell;
    
    GKUserButton * avatar;
    UILabel * name;
    UILabel * description;
    UILabel * tip;
    MMMCalendar * calendar;
}
@synthesize table = _table;
#pragma mark - LifeCircle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectCell = YES;
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        self.view.backgroundColor= UIColorFromRGB(0x403b3b);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"左侧菜单页";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GKLogin) name: GKUserLoginNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GKLogout) name: GKUserLogoutNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProfileChange) name:@"UserProfileChange" object:nil];

    _dataArray = [NSMutableArray arrayWithObjects:
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"准备怀孕",@"name",@"0",@"count",@"1",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"孕期",@"name",@"0",@"count",@"2",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"待产与产后",@"name",@"0",@"count",@"5",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0-6个月",@"name",@"0",@"count",@"6",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6-12个月",@"name",@"0",@"count",@"8",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1-3岁",@"name",@"0",@"count",@"9",@"pid",nil]
                  , nil];
    
    //NSUInteger i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userstage"]integerValue];
  
    for (NSMutableDictionary *dic in _dataArray) {
      [dic setObject:@"YES" forKey:@"open"];
          /*
        if([[dic objectForKey:@"pid"] intValue]<i)
        {
            [dic setObject:@"NO" forKey:@"open"];
        }
        else
        {
            [dic setObject:@"YES" forKey:@"open"];
        }
                */
        
    }

    user =[[GKUser alloc ]initFromNSU];
    
    tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    tableHeaderView.backgroundColor = UIColorFromRGB(0x403B3B);
    
    avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
    avatar.center = CGPointMake(40, 40);
    [tableHeaderView addSubview:avatar];
    
    UIButton * GoMyList = [[UIButton alloc]initWithFrame:tableHeaderView.bounds];
    [GoMyList setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
    [GoMyList setImage:[UIImage imageNamed:@"arrow_press.png"] forState:UIControlStateHighlighted];
    [GoMyList setImageEdgeInsets:UIEdgeInsetsMake(0, 220, 40, 0)];
    GoMyList.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    GoMyList.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [GoMyList addTarget:self action:@selector(showMeAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:GoMyList];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, tableHeaderView.frame.size.width-200, 20)];
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentLeft;
    [name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0f]];
    [name setMinimumFontSize:10];
    name.textColor = UIColorFromRGB(0xFFFFFF);
    name.adjustsFontSizeToFitWidth = YES;
    [tableHeaderView addSubview:name];
    
    description = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, tableHeaderView.frame.size.width,30)];
    description.backgroundColor = [UIColor blackColor];
    description.numberOfLines = 0;
    description.textAlignment = NSTextAlignmentLeft;
    [description setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    description.textColor = UIColorFromRGB(0xffffff);
    //[tableHeaderView addSubview:description];
    
    UIView *tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 320, 40)];
    tipView.backgroundColor = UIColorFromRGB(0x363131);
    
    UIImageView *H1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,tipView.frame.size.width, 2)];
    [H1 setImage:[UIImage imageNamed:@"sidebar_shadow.png"]];
    [tipView addSubview:H1];
    
    calendar = [[MMMCalendar alloc]initWithFrame:CGRectMake(0, 0, 30, 30) kind:0];
    calendar.center = CGPointMake(20, 20);
    [tipView addSubview:calendar];
    
    tip = [[UILabel alloc]initWithFrame:CGRectMake(40,0,tipView.frame.size.width-100,40)];
    tip.center = CGPointMake(tip.center.x, tipView.frame.size.height/2+1);
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentLeft;
    [tip setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    tip.textColor = UIColorFromRGB(0x777777);
    [tipView addSubview:tip];
    
    UIImageView *_seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, tipView.frame.size.width, 2)];
    [_seperatorLineImageView setImage:[UIImage imageNamed:@"sidebar_shadow_down@2x.png"]];
    [tipView addSubview:_seperatorLineImageView];
    
    [self refresh];
    [tableHeaderView addSubview:tipView];
    [self.view addSubview:tableHeaderView];
    
    tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
    tableFooterView.backgroundColor = UIColorFromRGB(0x403B3B);
    
    message = [[UIButton alloc]initWithFrame:CGRectMake(0, 0 , 116 , 34)];
    message.center = CGPointMake(65, 23);
    [message setBackgroundImage:[[UIImage imageNamed:@"sidebar_button.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [message setBackgroundImage:[[UIImage imageNamed:@"sidebar_button_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] forState:UIControlStateHighlighted];
    [message setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [message setTitle:@"消息" forState:UIControlStateNormal];
    [message.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    [message.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [message addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:message];

    
    setting = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 116, 34)];
    setting.center = CGPointMake(190, 23);
    [setting setBackgroundImage:[[UIImage imageNamed:@"sidebar_button.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [setting setBackgroundImage:[[UIImage imageNamed:@"sidebar_button_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] forState:UIControlStateHighlighted];
    [setting setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [setting setTitle:@"设置" forState:UIControlStateNormal];
    [setting.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    [setting addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [setting.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tableFooterView addSubview:setting];
    
    UIImageView *H2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
    [H2 setImage:[UIImage imageNamed:@"sidebar_divider.png"]];
    
    [tableFooterView addSubview:H2];
    
    [self.view addSubview:tableFooterView];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, tableHeaderView.frame.origin.y+tableHeaderView.frame.size.height, 320, kScreenHeight-(tableHeaderView.frame.origin.y+tableHeaderView.frame.size.height)-(tableFooterView.frame.size.height)) style:UITableViewStylePlain];
    
    _table.backgroundColor = UIColorFromRGB(0x403B3B);
    _table.separatorStyle =  UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = YES;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    NSUInteger pid =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"]]integerValue];
    NSUInteger stage = [self getIndexByPid:pid];
    [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:stage-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (NSMutableDictionary * dic in _dataArray) {
        [dic setObject:@"0" forKey:@"count"];
    }
    for (NSDictionary * dic in [GKEntity getEntityCountGroupByPid]) {
        NSUInteger pid = [[dic objectForKey:@"pid"]integerValue];
        NSUInteger count = [[dic objectForKey:@"count"]integerValue];
        NSUInteger stage = [self getIndexByPid:pid];
        [[_dataArray objectAtIndex:(stage-1)]setObject:[NSString stringWithFormat:@"%u",count] forKey:@"count"];
    }
    [self refresh];
    [self.table reloadData];
    NSUInteger pid =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"]]integerValue];
    NSUInteger stage = [self getIndexByPid:pid];
    if(selectCell)
    {
        [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:stage-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    }

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _table.allowsSelection = YES;
}

#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    MMMLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[MMMLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier];
    }
    cell.backgroundColor = UIColorFromRGB(0x403B3B);
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *data = [_dataArray objectAtIndex:row];
    cell.data = data;
    
    [[cell viewWithTag:4003]removeFromSuperview];
    [[cell viewWithTag:4004]removeFromSuperview];
    
    if(row != 0)
    {
        UIImageView *_seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
        _seperatorLineImageView.tag = 4003;
        [_seperatorLineImageView setImage:[UIImage imageNamed:@"sidebar_divider.png"]];
        [cell addSubview:_seperatorLineImageView];
    }
    NSUInteger userstage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userstage"] integerValue];
    userstage = [self getIndexByPid:userstage];
    if(row == (userstage -1))
    {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 14)];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        CGSize size = [[data objectForKey:@"name"] sizeWithFont:font constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
        image.center = CGPointMake(50+size.width, cell.frame.size.height/2);
        image.image = [UIImage imageNamed:@"sidebar_dot@2x.png"];
        image.tag = 4004;
    
        [cell addSubview:image];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    selectCell = YES;
    NSUInteger pid = [[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"pid"]integerValue];
    [[NSUserDefaults standardUserDefaults] setObject:@(pid) forKey:@"pid"];
    _table.allowsSelection = NO;
    NSString * title = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"切换分类"
                                                    withAction:title
                                                     withLabel:nil
                                                     withValue:nil];
    
    [self performSelector:@selector(close) withObject:self afterDelay:0.0];
    [self performSelector:@selector(PN) withObject:self afterDelay:0.05];

    NSInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
            
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
}
- (void)close
{
    GKAppDelegate *delegate = ((GKAppDelegate *)[UIApplication sharedApplication].delegate);
    [self.mm_drawerController setCenterViewController:delegate.navigationController withFullCloseAnimation:YES completion:NULL];
}
- (void)PN
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stageChange" object:nil userInfo:nil];

}
#pragma mark - 按钮方法
- (void)settingButtonAction
{
    //[self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    //selectCell = NO;
    GKSettingViewController *VC = [[GKSettingViewController alloc]init];
    GKNavigationController *nav = [[GKNavigationController alloc]initWithRootViewController:VC];
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_close.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_close.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    VC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    VC.navigationItem.rightBarButtonItem = nil;
    
    //[self.mm_drawerController setCenterViewController:nav withFullCloseAnimation:YES completion:NULL];
    [kAppDelegate.window.rootViewController presentModalViewController:nav animated:YES];
}
- (void)messageButtonAction
{
    //[self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    //selectCell = NO;
    /*
    GKMessageViewController *VC = [[GKMessageViewController alloc]init];
    GKNavigationController *nav = [[GKNavigationController alloc]initWithRootViewController:VC];
    [self.mm_drawerController setCenterViewController:nav withFullCloseAnimation:YES completion:NULL];
     */
    GKMessageViewController *VC = [[GKMessageViewController alloc]init];
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_close.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_close.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    VC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    VC.navigationItem.rightBarButtonItem = nil;
    GKNavigationController *nav = [[GKNavigationController alloc]initWithRootViewController:VC];

    [kAppDelegate.window.rootViewController presentViewController:nav animated:YES completion:^{
    }];
}
- (void)showMeAction:(id)sender
{
    
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    selectCell = NO;
    
    //GKAppDelegate *delegate = ((GKAppDelegate *)[UIApplication sharedApplication].delegate);

    GKUserViewController *VC = [[GKUserViewController alloc] initWithUserID:user.user_id];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    VC.navigationItem.titleView = [GKTitleView setTitleLabel:@"我的清单"];
    UIButton *menuBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [menuBTN setImage:[UIImage imageNamed:@"button_icon_menu.png"] forState:UIControlStateNormal];
    [menuBTN setImage:[UIImage imageNamed:@"button_icon_menu.png"] forState:UIControlStateHighlighted];
    [menuBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [menuBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [menuBTN addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    VC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuBTN];
    GKNavigationController * nav = [[GKNavigationController alloc]initWithRootViewController:VC];
    
    
    //[self.mm_drawerController setCenterViewController:nav withFullCloseAnimation:YES completion:NULL];
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:NULL];

    //[self showUserWithUserID:user.user_id];
    /*
    GKUserViewController *VC = [[GKUserViewController alloc] initWithUserID:user.user_id];
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    VC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    VC.hidesBottomBarWhenPushed = YES;
    
    [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) pushViewController:VC  animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:NULL];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"OpenRightMenu" object:nil userInfo:nil];
     */
}
- (void)showLeftMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
}
- (void)backButtonAction:(id)sender
{
    [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) popViewControllerAnimated:YES];
    //[self performSelector:@selector(open) withObject:nil afterDelay:0.4];
}
- (void)cancelButtonAction:(id)sender
{
    [kAppDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)open
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 通知处理
- (void)GKLogin
{
    [self refresh];
   
}
- (void)GKLogout
{

}

- (void)ProfileChange
{
   
    [self refresh];
     [self.table reloadData];
    NSUInteger pid =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"]]integerValue];
    NSUInteger stage = [self getIndexByPid:pid];
    [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:stage-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - 其他方法
- (void)refresh
{
    user =[[GKUser alloc ]initFromNSU];
   avatar.user = user;
   name.text = user.nickname;
   //description.text = user.bio;
    description.text = [kUserDefault stringForKey:kSession];
    if((user.birth_date)&&(user.stage !=1))
    {
        calendar.date = [NSDate date];
        //calendar.date = user.birth_date;
    }
    else
    {
        calendar.date = [NSDate date];
    }
    //[[NSUserDefaults standardUserDefaults] setObject:@(user.stage) forKey:@"userstage"];
    if(user)
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSDayCalendarUnit;
        NSDate *startDate = [NSDate date];
        NSDate *endDate = user.birth_date;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
        int days = [comps day];
        switch (user.stage) {
            case 2:
            {
                if (days<0) {
                    user.stage = 3;
                    [user save];
                }
            }
        }
    }
    switch (user.stage) {
        case 1:
        {
            tip.text = @"宝宝即将到来。";
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"userstage"];
        }
            break;
        case 2:
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *startDate = [NSDate date];
            NSDate *endDate = user.birth_date;
            unsigned int unitFlags = NSDayCalendarUnit;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
            int days = [comps day];
            tip.text = [NSString stringWithFormat:@"离宝宝出生还有%u天。",days];
            
            int week = days/7;
            if(week<2)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:@"userstage"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"userstage"];
            }

        }
            break;
        case 3:
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *endDate = [NSDate date];
            NSDate *startDate = user.birth_date;
            unsigned int unitFlags = NSDayCalendarUnit;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
            int days = [comps day];
            tip.text = [NSString stringWithFormat:@"宝宝已经出生%d天。",days];
            
            int week = days/7;
            int month = days/30;
            if(week<2)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:@"userstage"];
            }
            else if(month<6)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@(6) forKey:@"userstage"];
            }
            else if(month<12)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@(8) forKey:@"userstage"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@(9) forKey:@"userstage"];
            }
        }
            break;
            
        default:
            break;
    }

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
