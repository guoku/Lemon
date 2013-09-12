//
//  GKMoreViewController.m
//  Grape
//
//  Created by huiter on 13-4-15.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKSettingViewController.h"
#import "GKFeedBackViewController.h"
#import "GKUser.h"
#import "GKDevice.h"
#import "WXApi.h"
#import "GKAppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "GKStateChooseViewController.h"
#import "GKLoginViewController.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"

#import "UMTableViewController.h"

@interface GKSettingViewController ()

@end

@implementation GKSettingViewController

{
@private
    NSMutableArray * _dataArray;
    UILabel *currentSDImageCache;
    NSString *currentSDImageCacheString;
}
@synthesize table = _table;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.titleView = [GKTitleView setTitleLabel:@"设置"];
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        UIButton *menuBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
        [menuBTN setImage:[UIImage imageNamed:@"button_icon_menu.png"] forState:UIControlStateNormal];
        [menuBTN setImage:[UIImage imageNamed:@"button_icon_menu.png"] forState:UIControlStateHighlighted];
        [menuBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
        [menuBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
        [menuBTN addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuBTN];
        
        UIButton *friendBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
        [friendBTN setImage:[UIImage imageNamed:@"button_icon_friends.png"] forState:UIControlStateNormal];
        [friendBTN setImage:[UIImage imageNamed:@"button_icon_friends.png"] forState:UIControlStateHighlighted];
        [friendBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
        [friendBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
        [friendBTN addTarget:self action:@selector(showRightMenu) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:friendBTN];
        
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStyleGrouped];
    _table.backgroundView = nil;
    _table.backgroundColor = UIColorFromRGB(0xf9f9f9);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIButton *logoutBTN = [[UIButton alloc]initWithFrame:CGRectMake(10,10,kScreenWidth - 20, 35)];
    
    [logoutBTN setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBTN.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    
    [logoutBTN setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [logoutBTN setTitleEdgeInsets:UIEdgeInsetsMake(1, 8, 0, 0)];
  
    [logoutBTN setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [logoutBTN setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [logoutBTN addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    [tableFooterView addSubview:logoutBTN];
    self.table.tableFooterView = tableFooterView;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.trackedViewName = @"设置页";
    
    //NSDictionary *firstSection = [NSDictionary dictionaryWithObjectsAndKeys:@"帐号设置",@"section",[NSArray arrayWithObjects:@"昵称设置",@"头像设置",@"重新设置我的阶段", nil], @"row", nil];
    NSDictionary *firstSection = [NSDictionary dictionaryWithObjectsAndKeys:@"帐号设置",@"section",[NSArray arrayWithObjects:@"重新设置我的阶段", nil], @"row", nil];
    
    NSDictionary *secondSection = [NSDictionary dictionaryWithObjectsAndKeys:@"推荐我们",@"section",[NSArray arrayWithObjects:@"给应用打个分",@"关注我们微博", nil], @"row", nil];
    if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled]) {
        secondSection = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"推荐", @"section", [NSArray arrayWithObjects:@"给应用打个分", @"关注我们的新浪微博", @"发给微信好友",@"分享到朋友圈", nil], @"row", nil];
    }

    NSDictionary * thirdSection = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"系统",@"section", [NSArray arrayWithObjects:@"应用推荐",@"意见反馈",@"清除图片缓存",@"版本",nil], @"row", nil];
    
    _dataArray = [NSMutableArray arrayWithObjects:firstSection,secondSection,thirdSection, nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.table reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    currentSDImageCacheString= [ NSString stringWithFormat:@"%.1fM",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
     */
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [GKMessageBoard hideActivity];
    //[((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}
#pragma mark 重载tableview必选方法
//返回一共有多少个Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count] ;
}

//返回每个Section有多少Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[[_dataArray objectAtIndex:section]objectForKey:@"row"]count] ;
}

//定义每个Row
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *MoreTableIdentifier = [NSString stringWithFormat:@"More%u%u",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             MoreTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: MoreTableIdentifier];
    }
    
    cell.textLabel.text = [[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"row"]objectAtIndex:indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    cell.textLabel.textColor = UIColorFromRGB(0X666666);
    cell.textLabel.highlightedTextColor = UIColorFromRGB(0X666666);
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //设置背景色
    if (0 == indexPath.row) {
        cell.selectedBackgroundView =[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"tables_top_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:2]];
    }
    else
    {
        if ([[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"row"]count] == indexPath.row+1) {
            cell.selectedBackgroundView =[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"tables_bottom_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:2]];
        }
        else{
            cell.selectedBackgroundView =[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"tables_middle_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:2]];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *accessoryV = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, cell.frame.size.height)];
            [accessoryV setBackgroundColor:[UIColor clearColor]];
            accessoryV.clipsToBounds = NO;
            
            UILabel *currentVersionL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90.00f, cell.frame.size.height)];
            [currentVersionL setBackgroundColor:[UIColor clearColor]];
            [currentVersionL setTextAlignment:NSTextAlignmentRight];
            currentVersionL.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            currentVersionL.font = [UIFont fontWithName:@"Helvetica" size:15];;
            currentVersionL.textColor = UIColorFromRGB(0X666666);
            [accessoryV addSubview:currentVersionL];
            cell.accessoryView = accessoryV;
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *bgV = [[UIImageView alloc]init];
    if (0 == indexPath.row) {
        bgV.image = [[UIImage imageNamed:@"tables_top.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    }
    else
    {
        if ([[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"row"]count]== indexPath.row+1) {
            bgV.image = [[UIImage imageNamed:@"tables_bottom.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:1];
        }
        else{
            bgV.image = [[UIImage imageNamed:@"tables_middle.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:2];
        }
    }
    if(indexPath.section == 0)
    {
           bgV.image = [[UIImage imageNamed:@"tables_single.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    }
    cell.backgroundView = bgV;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 32)];
    titleLabel.textColor=UIColorFromRGB(0X666666);
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
    titleLabel.text = [[_dataArray objectAtIndex:section]objectForKey:@"section"];
    [bgView addSubview:titleLabel];
    return bgView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    if (indexPath.section == 0) {
        [self settingSectionFunctionWithIndexpath:indexPath];
    }
    if (indexPath.section == 1) {
        [self recommendSectionFunctionWithIndexpath:indexPath];
    }
    if (indexPath.section == 2) {
        if(indexPath.row == 0)
        {
            [self showTableView];
        }
        if(indexPath.row == 1)
        {
            [self showFeedBack];
        }
         
        if(indexPath.row == 2)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否清除图片缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认清除", nil];
            alertView.tag =20001;
            [alertView show];
        }
    }
}
#pragma mark 绑定设置处理方法
#pragma mark 推荐处理方法
- (void)showTableView {
    
    UMTableViewController *controller = [[UMTableViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)settingSectionFunctionWithIndexpath:(NSIndexPath *)path
{
    switch (path.row) {
        case 2:
        {
            
        }
            break;
        case 1:
        {

        }
            break;
        case 0:
        {
            GKStateChooseViewController *VC = [[GKStateChooseViewController alloc]init];
            UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
            [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
            [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
            UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
            [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
            [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
            [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            VC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
        {
            
        }
            break;
    }
}
- (void)recommendSectionFunctionWithIndexpath:(NSIndexPath *)path
{
    switch (path.row) {
        case 0:
        {
            NSString* url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kGK_AppID_iPhone];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            
        }
            break;
        case 1:
        {
            [self followGouku];
        }
            break;
        case 2:
        {
            [self wxShare:0];
        }
            break;
        case 3:
        {
            [self wxShare:1];
        }
            break;
            
        default:
        {
            
        }
            break;
    }
}
-(void)wxShare:(int)scene;
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"妈妈清单 - iPhone上最好用的妈妈购物APP";
    message.description= @"从备孕开始，「妈妈清单」为你设想所有所需，待你自由选择。随时参考好友的经验，构建全面适合你的购物清单。";
    [message setThumbImage:[UIImage imageNamed:@"wxshare.png"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.Url = [NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kGK_AppID_iPhone];;
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}
#pragma mark 系统处理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==20001)
    {
    if(buttonIndex == 1)
    {
        [self clearPicCache];
    }
    }
    
}
- (void)clearPicCache
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [self performSelectorOnMainThread:@selector(showClearPicCacheFinish) withObject:nil waitUntilDone:YES];
}
- (void)showClearPicCacheFinish
{
    [GKMessageBoard showMBWithText:@"清除完成" customView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] delayTime:0.8];
}
- (void)showFeedBack
{
    [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
    //GKFeedBackViewController *feedBackVC= [[GKFeedBackViewController alloc]init];
    //[self.navigationController pushViewController:feedBackVC animated:YES];
    
}
- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    [self presentModalViewController:navigationController animated:YES];
}
- (void)followGouku
{
    [GKMessageBoard showActivity];
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"friendships/create.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               @"3562485445", @"uid", nil]
                   httpMethod:@"POST"
                     delegate:self];
}
- (SinaWeibo *)sinaweibo
{
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [GKMessageBoard hideActivity];
    if((error.code ==21315)||(error.code == 10006))
    {
        SinaWeibo *sinaweibo = [self sinaweibo];
        [sinaweibo logIn];
    }
    else if(error.code ==20506)
    {
        [GKMessageBoard showMBWithText:@"已关注妈妈清单\U0001F603" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
    else
    {
    [GKMessageBoard showMBWithText:[NSString  stringWithFormat:@"网络错误,错误代码%u",error.code]customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    GKLog(@"%@",result);
    [GKMessageBoard hideActivity];
    [GKMessageBoard showMBWithText:@"成功关注妈妈清单\U0001F603" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
   
}
- (void)switchButtonAction:(id)sender
{
    UISwitch * switchBtn = (UISwitch *)sender;
    if(switchBtn.on == YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"useBigImg"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:@"useBigImg"];
    }
}

- (void)logoutButtonAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSession];
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.sinaweibo logOut];
    [kUserDefault removeObjectForKey:@"sina_user_id"];
    [kUserDefault removeObjectForKey:@"sina_access_token"];
    [kUserDefault removeObjectForKey:@"sina_expires_in"];
    [GKEntity deleteAllEntity];
    [[NSNotificationCenter defaultCenter] postNotificationName:GKUserLogoutNotification object:nil];
    [GKUser globalUserLogoutWithBlock:^(BOOL is_logout, NSError *error) {

    }];
    [kAppDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:NULL];
    GKLoginViewController * _loginVC = [[GKLoginViewController alloc] init];
    [delegate.window.rootViewController presentViewController: _loginVC animated:NO completion:NULL];
}
- (void)showLeftMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
}
- (void)showRightMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:NULL];
}

@end
