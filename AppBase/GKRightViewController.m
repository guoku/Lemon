//
//  GKRightViewController.m
//  MMM
//
//  Created by huiter on 13-6-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKRightViewController.h"
#import "GKUser.h"
#import "MMMRightCell.h"
#import "GKUserViewController.h"
#import "GKAppDotNetAPIClient.h"
#import "GKFriendRecommendViewController.h"
#import "GKAppDelegate.h"
#import "GKCenterViewController.h"

@interface GKRightViewController ()

@end

@implementation GKRightViewController
{
@private
    UIActivityIndicatorView *indicator;
    BOOL _loadMoreflag;
    NSString * _group;
    int _pageForFollow;
    int _pageForFans;
    CGFloat YoffsetForFollow;
    CGFloat YoffsetForFan;
    GKUser *me;
    NSUInteger _user_id;
    UIView *tableFooterView;
    UIButton * findFriend;
    UILabel * tip;
}
@synthesize segmentedControl = _segmentedControl;
@synthesize table = _table;
@synthesize dataArrayDic = _dataArrayDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        me = [[GKUser alloc]initFromNSU];
        _user_id = me.user_id;
        _group = @"follow";
        _loadMoreflag = NO;
        YoffsetForFan = 0;
        YoffsetForFollow = 0;
        
    }
    return self;
}

- (void)reload:(id)sender
{
    _pageForFans = 1;
    _pageForFollow = 1;
    if([_group isEqual: @"follow"])
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"RelationAction"
                                                        withAction:@"关注"
                                                         withLabel:nil
                                                         withValue:nil];
        [GKUser globalUserFollowingsWithUserID:_user_id Page:1 Block:^(NSArray *following_list, NSError * error){
            if(!error)
            {
                [_dataArrayDic setObject: [NSMutableArray arrayWithArray:following_list] forKey:@"follow"];
                [self.table reloadData];
                [self setFooterView:YES];
            }
            else
            {
                switch (error.code) {
                    case -999:
                        [GKMessageBoard hideMB];
                        break;
                    default:
                    {
                        NSString * errorMsg = [error localizedDescription];
                        [GKMessageBoard showMBWithText:@"" detailText:errorMsg  lableFont:nil detailFont:nil customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2 atHigher:NO];
                    }
                        break;
                }
            }
            [self doneLoadingTableViewData:@"follow"];
            
        }];
    }
    if([_group isEqual: @"fan"])
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"RelationAction"
                                                        withAction:@"粉丝"
                                                         withLabel:nil
                                                         withValue:nil];
        [GKUser globalUserFansWithUserID:_user_id Page:1 Block:^(NSArray *fans_list, NSError * error){
            if(!error)
            {
                [_dataArrayDic setObject: [NSMutableArray arrayWithArray:fans_list] forKey:@"fan"];
                [self.table reloadData];
            }
            else
            {
                switch (error.code) {
                    case -999:
                        [GKMessageBoard hideMB];
                        break;
                    default:
                    {
                        NSString * errorMsg = [error localizedDescription];
                        [GKMessageBoard showMBWithText:@"" detailText:errorMsg  lableFont:nil detailFont:nil customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2 atHigher:NO];
                    }
                        break;
                }
            }
            [self doneLoadingTableViewData:@"fan"];
            
        }];
    }
}
- (void)loadView
{
    [super loadView];
    self.view.frame = CGRectMake(0, 0, 220,kScreenHeight);
    self.view.backgroundColor = UIColorFromRGB(0x403b3b);
    
    _segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0.0,0, 181.0, 28.0)];
    [_segmentedControl setDelegate:self];
    [self setupSegmentedControl];
    _segmentedControl.center = CGPointMake(self.view.frame.size.width/2, 22);
    [self.view addSubview:_segmentedControl];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0,44, self.view.frame.size.width, kScreenHeight-44-44) style:UITableViewStylePlain];
    _table.backgroundColor = UIColorFromRGB(0x403b3b);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = YES;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
        view.backgroundColor = UIColorFromRGB(0x403b3b);
        view.delegate = self;
        _refreshHeaderView = view;
        [self.table addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    [self setFindFriendView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"navigation_bar_button_enable"];
    self.trackedViewName = @"关注页";
    self.dataArrayDic = [[NSMutableDictionary alloc]init];
    _pageForFans = 1;
    _pageForFollow = 1;
    if([_group isEqual: @"follow"])
    {
        _segmentedControl.selectedIndex = 0;
    }
    if([_group isEqual: @"fan"])
    {
        _segmentedControl.selectedIndex = 1;
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
    [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:@"navigation_bar_button_enable"];
    if(([[_dataArrayDic objectForKey:_group] count] == 0)&&(!_reloading))
    {
        [self refresh];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"navigation_bar_button_enable"];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserFollowChange" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 重载tableview必选方法
//返回一共有多少个Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回每个Section有多少Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
    {
        return [[_dataArrayDic objectForKey:_group ] count];
    }
    return 0;
}

//定义每个Row
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FollowTableIdentifier = @"Follow";
    
    MMMRightCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            FollowTableIdentifier];
    if (cell == nil) {
        cell = [[MMMRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: FollowTableIdentifier];
    }
    cell.delegate = self;
    cell.user = [[_dataArrayDic objectForKey:_group] objectAtIndex:indexPath.row];
    [[cell viewWithTag:4003]removeFromSuperview];

        UIImageView *_seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 260, 2)];
        _seperatorLineImageView.tag = 4003;
        [_seperatorLineImageView setImage:[UIImage imageNamed:@"sidebar_divider.png"]];
        [cell addSubview:_seperatorLineImageView];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKUser *user = [[_dataArrayDic objectForKey:_group] objectAtIndex:indexPath.row];
    [self showUserWithUserID:user.user_id];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,220, 30)];
    view.backgroundColor = UIColorFromRGB(0x363131);
    
    UIImageView *H1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,view.frame.size.width, 2)];
    [H1 setImage:[UIImage imageNamed:@"sidebar_shadow.png"]];
    [view addSubview:H1];
    
    tip = [[UILabel alloc]initWithFrame:CGRectMake(10,0,view.frame.size.width,20)];
    tip.center = CGPointMake(tip.center.x,view.frame.size.height/2);
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentLeft;
    [tip setFont:[UIFont fontWithName:@"Helvetica-Bold" size:9.0f]];
    tip.textColor = UIColorFromRGB(0x777777);
    tip.text = @"共10个人";
    [view addSubview:tip];
    
    UIImageView *_seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, view.frame.size.width, 2)];
    [_seperatorLineImageView setImage:[UIImage imageNamed:@"sidebar_shadow_down@2x.png"]];
    [view addSubview:_seperatorLineImageView];
    
    return view;
}

//以下部分不用管。

- (void)refresh
{
    _reloading = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.table.tableFooterView.hidden = YES;
    [self makeHearderReloading];
    [self performSelector:@selector(reload:) withObject:nil afterDelay:0.3];
}
-(void)reloadTableViewDataSource
{
    _reloading = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.table.tableFooterView.hidden = YES;
    [self reload:nil];
    
}
- (void)doneLoadingTableViewData:(NSString *)group{
    _reloading = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.table.tableFooterView.hidden = NO;
    CGPoint offset = self.table.contentOffset;
    if([group isEqualToString: _group])
    {
        offset.y = 0.0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentOffset = offset;
    }completion:^(BOOL finished) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    }];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if (scrollView.contentOffset.y+scrollView.frame.size.height >= scrollView.contentSize.height) {
        if(!_loadMoreflag&&!_reloading)
        {
            _loadMoreflag = YES;
            [self loadMore];
        }
	}
	
}
#pragma mark -
#pragma mark 重载EGORefreshTableHeaderView必选方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    //[self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:3.0];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}
- (void)makeHearderReloading
{
    [_refreshHeaderView setState:EGOOPullRefreshNormal];
    if (self.table.isDecelerating) {
        [self.table setContentOffset:self.table.contentOffset animated:NO];
    }
    CGPoint offset = self.table.contentOffset;
    if (offset.y >= 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.table.contentOffset = CGPointMake(offset.x, -65.);
        }completion:^(BOOL finished) {
            [_refreshHeaderView setState:EGOOPullRefreshLoading];
        }];
    }
    
    
}
- (void)setupSegmentedControl
{
    UIImage *backgroundImage = [[UIImage imageNamed:@"sidebar_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [_segmentedControl setBackgroundImage:backgroundImage];
    [_segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [_segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"sidebar_tab_button_left.png"]
                                                 stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"sidebar_tab_button_right.png"]
                                                  stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    // Button 1
    UIButton *buttonForFollow = [[UIButton alloc] init];
    buttonForFollow.frame = CGRectMake(0, 0, 90, 30);
    [buttonForFollow setTitle:@"关注" forState:UIControlStateNormal];
    [buttonForFollow setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [buttonForFollow.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    [buttonForFollow setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonForFollow setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [buttonForFollow setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *buttonForFans = [[UIButton alloc] init];
    buttonForFans.frame = CGRectMake(0, 0, 90, 30);
    [buttonForFans setTitle:@"粉丝" forState:UIControlStateNormal];
    [buttonForFans setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [buttonForFans.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    [buttonForFans setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [buttonForFans setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [buttonForFans setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [_segmentedControl setButtonsArray:@[buttonForFollow, buttonForFans]];
    [self.view addSubview:_segmentedControl];
    
    UIImageView *H2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 220, 1)];
    [H2 setImage:[UIImage imageNamed:@"sidebar_divider.png"]];
    
    [self.view addSubview:H2];
}
- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            YoffsetForFan = (self.table.contentOffset.y>0)?self.table.contentOffset.y:0;
            _group = @"follow";
            [self.table reloadData];
            break;
        case 1:
            YoffsetForFollow = (self.table.contentOffset.y>0)?self.table.contentOffset.y:0;
            _group = @"fan";
            [self.table reloadData];
            break;
        default:
            break;
    }
    
    if([[_dataArrayDic objectForKey:_group] count] == 0)
    {
        [[GKAppDotNetAPIClient sharedClient]cancelAllHTTPOperationsWithMethod:@"GET" path:@"user/following/"];
        [[GKAppDotNetAPIClient sharedClient]cancelAllHTTPOperationsWithMethod:@"GET" path:@"user/fans/"];
        [self AllReset];
        [self refresh];
    }
    else
    {
        [self reloadDataWithYoffset];
    }
}
- (void)reloadDataWithYoffset
{
    [self.table reloadData];
    
    if([_group isEqualToString:@"follow"])
    {
        if (YoffsetForFollow <= self.table.contentSize.height - self.table.frame.size.height) {
            [self.table setContentOffset:CGPointMake(0, YoffsetForFollow) animated:NO];
        }
    }
    else if ([_group isEqualToString:@"fan"])
    {
        if (YoffsetForFan <= self.table.contentSize.height - self.table.frame.size.height) {
            [self.table setContentOffset:CGPointMake(0, YoffsetForFan) animated:NO];
        }
    }
}
- (void)AllReset{
    _reloading = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    CGPoint offset = self.table.contentOffset;
    offset.y = 0.0;
    [UIView animateWithDuration:0.0 animations:^{
        self.table.contentOffset = offset;
    }completion:^(BOOL finished) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    }];
}

- (void)setFooterView:(BOOL)yes
{
    if (yes) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220.0f, 44.0f)];
        UIButton * LoadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        LoadMoreBtn.frame = CGRectMake(0, 0, 220.0f, 44.0f);
        [LoadMoreBtn setBackgroundColor:[UIColor clearColor]];
        [LoadMoreBtn setUserInteractionEnabled:YES];
        [LoadMoreBtn setTitle:@"点击查看更多" forState:UIControlStateNormal];
        [LoadMoreBtn setTitleColor:UIColorFromRGB(0xf2f2f2) forState:UIControlStateNormal];
        [LoadMoreBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateHighlighted];
        LoadMoreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        LoadMoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [LoadMoreBtn addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:LoadMoreBtn];
        
        self.table.tableFooterView = footerView;
    }
    else {
        self.table.tableFooterView = nil;
    }
}

- (void)loadMore
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, 220, 44);
    indicator.backgroundColor = UIColorFromRGB(0x403b3b);
    indicator.center = CGPointMake(220/2, 22.0f);
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    [self.table.tableFooterView addSubview:indicator];
    
    if([_group isEqual: @"follow"])
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"RelationAction"
                                                        withAction:@"关注"
                                                         withLabel:nil
                                                         withValue:nil];
        [GKUser globalUserFollowingsWithUserID:_user_id Page:_pageForFollow+1 Block:^(NSArray *following_list, NSError * error){
            if(!error)
            {
                [[_dataArrayDic objectForKey:@"follow"] addObjectsFromArray: [NSMutableArray arrayWithArray:following_list]];
                _pageForFollow = _pageForFollow+1;
                [self.table reloadData];
            }
            else
            {
                switch (error.code) {
                    case -999:
                        [GKMessageBoard hideMB];
                        break;
                    default:
                    {
                        NSString * errorMsg = [error localizedDescription];
                        [GKMessageBoard showMBWithText:@"" detailText:errorMsg  lableFont:nil detailFont:nil customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2 atHigher:NO];
                    }
                        break;
                }
            }
            [indicator stopAnimating];
            _loadMoreflag = NO;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    }
    if([_group isEqual: @"fan"])
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"RelationAction"
                                                        withAction:@"粉丝"
                                                         withLabel:nil
                                                         withValue:nil];
        [GKUser globalUserFansWithUserID:_user_id Page:_pageForFans+1 Block:^(NSArray *fans_list, NSError * error){
            if(!error)
            {
                _pageForFans = _pageForFans+1;
                [[_dataArrayDic objectForKey:@"fan"] addObjectsFromArray: [NSMutableArray arrayWithArray:fans_list]];
                [self.table reloadData];
            }
            else
            {
                switch (error.code) {
                    case -999:
                        [GKMessageBoard hideMB];
                        break;
                    default:
                    {
                        NSString * errorMsg = [error localizedDescription];
                        [GKMessageBoard showMBWithText:@"" detailText:errorMsg  lableFont:nil detailFont:nil customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2 atHigher:NO];
                    }
                        break;
                }
            }
            [indicator stopAnimating];
            _loadMoreflag = NO;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    }
}

- (void)setFindFriendView
{
    tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 220, 44)];
    tableFooterView.backgroundColor = UIColorFromRGB(0x403B3B);
    
    findFriend = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 34)];
    findFriend.center = CGPointMake(tableFooterView.frame.size.width/2, 23);
    [findFriend setBackgroundImage:[[UIImage imageNamed:@"sidebar_button.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [findFriend setBackgroundImage:[[UIImage imageNamed:@"sidebar_button_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] forState:UIControlStateHighlighted];
    [findFriend setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [findFriend setTitle:@"邀请好友" forState:UIControlStateNormal];
    [findFriend.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    [findFriend addTarget:self action:@selector(showFriendRecommend) forControlEvents:UIControlEventTouchUpInside];
    [findFriend.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tableFooterView addSubview:findFriend];
    
    UIImageView *H2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 2)];
    [H2 setImage:[UIImage imageNamed:@"sidebar_divider.png"]];
    
    [tableFooterView addSubview:H2];
    
    [self.view addSubview:tableFooterView];
    
}
- (void)showFriendRecommend
{
    GKFriendRecommendViewController *VC = [[GKFriendRecommendViewController alloc]init];
    VC .hidesBottomBarWhenPushed = YES;
    GKAppDelegate *delegate = ((GKAppDelegate *)[UIApplication sharedApplication].delegate);
    UIGraphicsBeginImageContext(delegate.window.bounds.size);
    
    [delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
   

    GKNavigationController *nav = [[GKNavigationController alloc]initWithRootViewController:VC];
  
    delegate.window.rootViewController = nav;
    UIGraphicsBeginImageContext(delegate.window.bounds.size);
    
    [delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:image2];
    
    imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    imageView2.frame = CGRectMake(320, 0, imageView2.frame.size.width, imageView2.frame.size.height);
    [delegate.window addSubview:imageView];
    [delegate.window addSubview:imageView2];
 
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.frame = CGRectMake(-320, 0, imageView.frame.size.width, imageView.frame.size.height);
        imageView2.frame = CGRectMake(0, 0, imageView2.frame.size.width, imageView2.frame.size.height);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [imageView2 removeFromSuperview];
    }];
}

@end