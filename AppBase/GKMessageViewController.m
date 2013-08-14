//
//  GKMessageViewController.m
//  MMM
//
//  Created by huiter on 13-7-16.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKMessageViewController.h"
#import "GKMessages.h"
#import "GKAppDelegate.h"
#import "TableViewCellForMessage.h"
#import "UIViewController+MMDrawerController.h"

@interface GKMessageViewController ()

@end

@implementation GKMessageViewController
{
@private
      UIActivityIndicatorView * loading;
    NSMutableArray * _dataArray;
        BOOL _loadMoreflag;
        UIActivityIndicatorView *indicator;
        BOOL _canLoadMore;
}
@synthesize table = _table;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
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
        
        _canLoadMore =NO;
    }
    return self;
}

- (void)reload:(id)sender
{
    [kAppDelegate hideMessageRemind];
    [GKMessages getUserMessageWithPostBefore:nil Block:^(NSArray *messages, NSError *error) {
        if(!error)
        {
            _dataArray = [NSMutableArray arrayWithArray:messages];
            [_dataArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"created_time" ascending:NO]]];
            if([messages count]!=0)
            {
             
            }
            else
            {
                
                [GKMessageBoard showMBWithText:@"没有更多。" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            }
            if([messages count]<30)
            {
                [self setFooterView:NO];
            }
            else
            {
                 [self setFooterView:YES];
            }
            

            [self.table reloadData];
            [self doneLoadingTableViewData];
       
        }
        else
        {
            switch (error.code) {
                case -999:
                    [GKMessageBoard hideMB];
                    break;
                case kUserSessionError:
                {
                    [GKMessageBoard hideMB];
                    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.sinaweibo logOut];
                    [[NSNotificationCenter defaultCenter] postNotificationName:GKUserLogoutNotification object:nil];
                    [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
                }
                    break;
                default:
                {
                    NSString * errorMsg = [error localizedDescription];
                    [GKMessageBoard showMBWithText:@"" detailText:errorMsg  lableFont:nil detailFont:nil customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2 atHigher:NO];
                }
                    break;
            }
            [self doneLoadingTableViewData];
            
        }
    }];

}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"我的消息"];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40) style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = YES;
    _table.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self setFooterView:NO];
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
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowChange:) name:kGKN_UserFollowChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:@"EntityLikeChange" object:nil];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EntityLikeChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGKN_UserFollowChange object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    if([_dataArray count] == 0)
    {
        [self refresh];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    //[((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
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
    return [_dataArray count];
}

//定义每个Row
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCellForMessage *cell = [tableView dequeueReusableCellWithIdentifier:
                                     @"messageCell"];
    if (cell == nil) {
        cell = [[TableViewCellForMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"messageCell"];
    }
    cell.backgroundColor = UIColorFromRGB(0xf9f9f9);
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.message = [_dataArray objectAtIndex:indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TableViewCellForMessage height:[_dataArray objectAtIndex:indexPath.row]];
    //return 100;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKMessages *data = [_dataArray objectAtIndex:indexPath.row];

    if([data.type isEqual:@"post_entity_note"])
    {
        GKNoteMessage *message = ((GKNoteMessage*)data.message_object);
        [self showDetailWithEntityID:message.entity.entity_id];
        return;
    }
    if([data.type isEqual:@"following"])
    {
        GKFollowerMessage *message =  ((GKFollowerMessage*)data.message_object);
        [self showUserWithUserID:message.user.user_id];
        return;
    }
    if([data.type isEqual:@"friend_joined"])
    {
        GKWeiboFriendJoinMessage *message =  ((GKWeiboFriendJoinMessage*)data.message_object);
        [self showUserWithUserID:message.recommended_user.user_id];
        return;
    }
    if([data.type isEqual:@"poke_note"])
    {
        GKNoteMessage *message = ((GKNoteMessage*)data.message_object);
        [self showCommentWithNoteID:message.note.note_id EntityID:message.entity.entity_id];
        return;
        
    }
    if([data.type isEqual:@"reply"])
    {
        GKNoteMessage *message = ((GKNoteMessage*)data.message_object);
        [self showCommentWithNoteID:message.note.note_id EntityID:message.entity.entity_id];
        return;
    
    }
}
#pragma mark Delegate

- (void)refresh
{
    _reloading = YES;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    [self makeHearderReloading];
    //[self reload:nil];
    [self performSelector:@selector(reload:) withObject:nil afterDelay:0.3];
}
-(void)reloadTableViewDataSource
{
    _reloading = YES;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    [self reload:nil];
    
}
- (void)doneLoadingTableViewData{
    _reloading = NO;
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    CGPoint offset = self.table.contentOffset;
    offset.y = 0.0;
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
        if((!_loadMoreflag&&!_reloading)&&_canLoadMore)
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
- (void)showLeftMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
}
- (void)showRightMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:NULL];
}
- (void)setFooterView:(BOOL)yes
{
    if (yes) {
               _canLoadMore =YES;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0f)];
        UIButton * LoadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        LoadMoreBtn.frame = CGRectMake(0, 0, 320.0f, 44.0f);
        [LoadMoreBtn setBackgroundColor:[UIColor clearColor]];
        [LoadMoreBtn setUserInteractionEnabled:YES];
        [LoadMoreBtn setTitle:@"点击查看更多" forState:UIControlStateNormal];
        [LoadMoreBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [LoadMoreBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateHighlighted];
        LoadMoreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        LoadMoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [LoadMoreBtn addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:LoadMoreBtn];
        
        self.table.tableFooterView = footerView;
    }
    else {
        _canLoadMore =NO;
        self.table.tableFooterView = nil;
    }
}
- (void)loadMore
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, kScreenWidth, 44);
    indicator.backgroundColor = UIColorFromRGB(0xf9f9f9);
    indicator.center = CGPointMake(kScreenWidth/2, 22.0f);
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    [self.table.tableFooterView addSubview:indicator];
    GKMessages *last = [_dataArray lastObject];
    NSDate * timestamp = last.created_time;
    
    [GKMessages getUserMessageWithPostBefore:timestamp Block:^(NSArray *messages, NSError *error) {
        if(!error)
        {
            if([messages count]!=0)
            {
                [_dataArray addObjectsFromArray:messages];
                [_dataArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"created_time" ascending:NO]]];
                [self setFooterView:YES];
                [self.table reloadData];
            }
            else
            {
              //  [self setFooterView:NO];
                [GKMessageBoard showMBWithText:@"没有更多。" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            }

            [indicator stopAnimating];
            _loadMoreflag = NO;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else
        {
            [indicator stopAnimating];
            _loadMoreflag = NO;
            self.navigationItem.rightBarButtonItem.enabled = YES;
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
    }];
    
}
- (void)userFollowChange:(NSNotification *)noti
{
    NSDictionary *data = [noti userInfo];
    NSUInteger user_id = [[data objectForKey:@"userID"]integerValue];
    GKUserRelation *relation = [data objectForKey:@"relation"];
    for (GKMessages * message in _dataArray) {
        
        if([message.type isEqual:@"following"])
        {
            GKFollowerMessage *followerMessage = ((GKFollowerMessage*)message.message_object);
            if (user_id == followerMessage.user.user_id) {
                followerMessage.user.relation = relation;
            }
        }
    }
    [self.table reloadData];
    
}
@end
