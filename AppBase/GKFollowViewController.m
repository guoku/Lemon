//
//  GKFollowViewController.m
//  Grape
//
//  Created by huiter on 13-4-2.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKFollowViewController.h"
#import "GKUser.h"
#import "FollowUserCell.h"
#import "GKUserViewController.h"
#import "GKAppDotNetAPIClient.h"
#import "GKFriendRecommendViewController.h"

@interface GKFollowViewController ()

@end

@implementation GKFollowViewController
{
@private
    UIActivityIndicatorView *indicator;
    BOOL _loadMoreflag;
    NSString * _group;
    int _pageForFollow;
    int _pageForFans;
    CGFloat YoffsetForFollow;
    CGFloat YoffsetForFan;
    NSMutableDictionary *loadMoreBoolDictionary;
}
@synthesize user_id = _user_id;
@synthesize segmentedControl = _segmentedControl;
@synthesize table = _table;
@synthesize dataArrayDic = _dataArrayDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        _group = @"follow";
        _loadMoreflag = NO;
        [loadMoreBoolDictionary setObject:@(NO) forKey:@"follow"];
        [loadMoreBoolDictionary setObject:@(NO) forKey:@"fan"];
    }
    return self;
}
- (id)initWithUserID:(NSUInteger)user_id withGroup:(NSString *)group
{
    self = [super init];
    {
        _user_id = user_id;
        _group = group;
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
            if([following_list count] >25)
            {
                [loadMoreBoolDictionary setObject:@(YES) forKey:_group];
            }
            else
            {
                [loadMoreBoolDictionary setObject:@(NO) forKey:_group];
            }
            [self setLoadMore];
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
                if([fans_list count] >25)
                {
                    [loadMoreBoolDictionary setObject:@(YES) forKey:_group];
                }
                else
                {
                    [loadMoreBoolDictionary setObject:@(NO) forKey:_group];
                }
                [self setLoadMore];
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
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];


    _segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0.0,0, 181.0, 28.0)];
    [_segmentedControl setDelegate:self];
    [self setupSegmentedControl];
    self.navigationItem.titleView = _segmentedControl;
    
    UIButton *refreshBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [refreshBTN setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
    [refreshBTN addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBTN];
    
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStylePlain];
    _table.backgroundColor = UIColorFromRGB(0xfaf9f6);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = YES;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
        view.delegate = self;
        _refreshHeaderView = view;
        [self.table addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"关注页";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowChange:) name:kGKN_UserFollowChange object:nil];
	// Do any additional setup after loading the view.
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
    if(([[_dataArrayDic objectForKey:_group] count] == 0)&&(!_reloading))
    {
        [self refresh];
    }

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGKN_UserFollowChange object:nil];
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
    
    FollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     FollowTableIdentifier];
    if (cell == nil) {
        cell = [[FollowUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: FollowTableIdentifier];
    }
    cell.delegate = self;
    cell.user = [[_dataArrayDic objectForKey:_group] objectAtIndex:indexPath.row];
    UIView *bg =[[UIView alloc]initWithFrame:CGRectZero];
    [bg setBackgroundColor:UIColorFromRGB(0xb0a498)];
    cell.selectedBackgroundView =bg;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    GKUser *user = [[_dataArrayDic objectForKey:_group] objectAtIndex:indexPath.row];
    [self showUserWithUserID:user.user_id];
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
    UIImage *backgroundImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [_segmentedControl setBackgroundImage:backgroundImage];
    [_segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [_segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"tab_button_left.png"]
                                                 stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"tab_button_right.png"]
                                                  stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    // Button 1
    UIButton *buttonForFollow = [[UIButton alloc] init];
    buttonForFollow.frame = CGRectMake(0, 0, 90, 28);
    [buttonForFollow setTitle:@"关注" forState:UIControlStateNormal];
    [buttonForFollow setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    //[buttonForFollow setTitleColor:[UIColor colorWithRed:253.0f / 255.0f green:62.0f / 255.0f blue:55.0 / 255.0f alpha:1.0f] forState:UIControlStateSelected];
    [buttonForFollow.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    [buttonForFollow setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
    [buttonForFollow setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonForFollow setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [buttonForFollow setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *buttonForFans = [[UIButton alloc] init];
    buttonForFans.frame = CGRectMake(0, 0, 90, 28);
    [buttonForFans setTitle:@"粉丝" forState:UIControlStateNormal];
    [buttonForFans setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    //[buttonForFans setTitleColor:[UIColor colorWithRed:253.0f / 255.0f green:62.0f / 255.0f blue:55.0 / 255.0f alpha:1.0f] forState:UIControlStateSelected];
    [buttonForFans.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    [buttonForFans setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [buttonForFans setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [buttonForFans setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [_segmentedControl setButtonsArray:@[buttonForFollow, buttonForFans]];
    [self.view addSubview:_segmentedControl];
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
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
        UIButton * LoadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        LoadMoreBtn.frame = CGRectMake(0, 0, 320.0f, 44.0f);
        [LoadMoreBtn setBackgroundColor:[UIColor clearColor]];
        [LoadMoreBtn setUserInteractionEnabled:YES];
        [LoadMoreBtn setTitle:@"点击查看更多" forState:UIControlStateNormal];
        [LoadMoreBtn setTitleColor:UIColorFromRGB(0x898989) forState:UIControlStateNormal];
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
    indicator.frame = CGRectMake(0, 0, kScreenWidth, 44);
    indicator.backgroundColor = UIColorFromRGB(0xfaf9f6);
    indicator.center = CGPointMake(kScreenWidth/2, 22.0f);
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
                if([following_list count]>25)
                {
                    [loadMoreBoolDictionary setObject:@(YES) forKey:_group];
                }
                else
                {
                    [loadMoreBoolDictionary setObject:@(NO) forKey:_group];
                }
                [self setLoadMore];
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
                if([fans_list count]>25)
                {
                    [loadMoreBoolDictionary setObject:@(YES) forKey:_group];
                }
                else
                {
                    [loadMoreBoolDictionary setObject:@(NO) forKey:_group];
                }
                [self setLoadMore];
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

- (void)userFollowChange:(NSNotification *)noti
{
    NSDictionary *data = [noti userInfo];
    NSUInteger user_id = [[data objectForKey:@"userID"]integerValue];
    GKUserRelation *relation = [data objectForKey:@"relation"];
    for (GKUser * user in [_dataArrayDic objectForKey:@"follow"] ) {
        
        if (user_id == user.user_id) {
            user.relation = relation;
            [self.table reloadData];
            break;
        }
    }
    for (GKUser * user in [_dataArrayDic objectForKey:@"fan"] ) {
        
        if (user_id == user.user_id) {
            user.relation = relation;
            [self.table reloadData];
            break;
        }
    }

}
- (void)setLoadMore
{
    if ([[loadMoreBoolDictionary objectForKey:_group]boolValue]) {
        [self setFooterView:YES];
    }
    else
    {
        [self setFooterView:NO];
    }
}


@end
