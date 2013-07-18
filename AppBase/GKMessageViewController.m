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
    NSMutableArray * _dataArray;
}
@synthesize table = _table;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (void)reload:(id)sender
{
    [GKMessages getUserMessageWithPostBefore:nil Block:^(NSArray *messages, NSError *error) {
        if(!error)
        {
            _dataArray = [NSMutableArray arrayWithArray:messages];

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
    
    self.view.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"我的消息"];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40) style:UITableViewStylePlain];
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
    
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:@"EntityLikeChange" object:nil];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EntityLikeChange" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([_dataArray count] == 0)
    {
        [self refresh];
    }
    
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
    cell.delegate = self;
    cell.message = [_dataArray objectAtIndex:indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TableViewCellForMessage height:[_dataArray objectAtIndex:indexPath.row]];
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
    if([data.type isEqual:@"user_follow_message"])
    {

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
@end
