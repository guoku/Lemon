//
//  GKFriendRecommendViewController.m
//  Grape
//
//  Created by huiter on 13-5-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKFriendRecommendViewController.h"
#import "GKRecommendFriend.h"
#import "FollowUserCell.h"
#import "GKAppDelegate.h"
@interface GKFriendRecommendViewController ()

@end

@implementation GKFriendRecommendViewController
{
@private
    NSUInteger page;
    UIActivityIndicatorView *indicator;
    BOOL _loadMoreflag;
    UIImageView *cate_arrow;
}
@synthesize dataArray = _dataArray;
@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc]init];
        page  = 1;
        _loadMoreflag = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"邀请好友";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowChange:) name:@"UserFollowChange" object:nil];
    
    self.view.backgroundColor = kColorf2f2f2;
    

    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    UIButton *refreshBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [refreshBTN setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
    [refreshBTN addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBTN];
    
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"邀请好友"];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    bg.backgroundColor = kColorf1f1f1;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 40)];
    [button setImage:[UIImage imageNamed:@"icon_sina.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_sina.png"] forState:UIControlStateHighlighted];
    
    [button.titleLabel setTextAlignment:UITextAlignmentLeft];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitleColor:kColor555555 forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [button setTitle:@"邀请微博好友" forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 4001;
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(160, 0, 160, 40)];
    [button2 setImage:[UIImage imageNamed:@"icon_weixin.png"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"icon_weixin.png"] forState:UIControlStateHighlighted];
    [button2.titleLabel setTextAlignment:UITextAlignmentLeft];
    button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button2 setTitleColor:kColor555555 forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [button2 setTitle:@"邀请微信好友" forState:UIControlStateNormal];
    [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button2 addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 4002;
        
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrow.frame = CGRectMake(300, 13, 8, 14);
    arrow.backgroundColor = [UIColor clearColor];
    [bg addSubview:button];
    [bg addSubview:button2];
    [bg addSubview:arrow];
    
    UIView *V1 = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 1, 40)];
    V1.backgroundColor = kColore4e4e4;
    UIView *H1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    H1.backgroundColor = kColore4e4e4;
    
    [bg addSubview:H1];
    [bg addSubview:V1];
    
    cate_arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"category_arrow.png"]];
    cate_arrow.frame = CGRectMake(0,39, 15,8);
    cate_arrow.center = CGPointMake(80, cate_arrow.center.y);
    cate_arrow.backgroundColor = [UIColor clearColor];
         [view addSubview:cate_arrow];
    [view addSubview:bg];
    [view addSubview:cate_arrow];

    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-44-40) style:UITableViewStylePlain];
    _table.backgroundColor = kColorf2f2f2;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = NO;
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
	// Do any additional setup after loading the view.
    [self.view addSubview:view];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserFollowChange" object:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([_dataArray count]==0)
    {
        [self refresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload:(id)sender
{
    page = 1;
    [GKRecommendFriend RecommendFriendWithPage:page Block:^(NSArray *friendList, NSError *error){
        if (!error)
        {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:friendList];
            [self.table reloadData];
            if([_dataArray count]!=0)
            {
                [self setFooterView:YES];
            }
            page += 1;
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
        [self doneLoadingTableViewData];
    }];
}
- (void)loadView
{
    [super loadView];

}
- (void)refresh
{
    _reloading = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self makeHearderReloading];
    [self performSelector:@selector(reload:) withObject:nil afterDelay:0.3];
}
-(void)reloadTableViewDataSource
{
    _reloading = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self reload:nil];
    
}
- (void)doneLoadingTableViewData{
    _reloading = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
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
        return [_dataArray count];
    }
    return 0;
}

//定义每个Row
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FollowTableIdentifier = @"FindFriend";
    
    FollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            FollowTableIdentifier];
    if (cell == nil) {
        cell = [[FollowUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: FollowTableIdentifier];
    }
    cell.delegate = self;
    cell.user = [_dataArray objectAtIndex:indexPath.row];
    UIView *bg =[[UIView alloc]initWithFrame:CGRectZero];
    [bg setBackgroundColor:kColorf2f2f2];
    cell.selectedBackgroundView =bg;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    GKUser *user = [_dataArray objectAtIndex:indexPath.row];
    [self showUserWithUserID:user.user_id];
}
- (void)userFollowChange:(NSNotification *)noti
{
    NSDictionary *data = [noti userInfo];
    NSUInteger user_id = [[data objectForKey:@"userID"]integerValue];
    GKUserRelation *relation = [data objectForKey:@"relation"];
    for (GKUser * user in _dataArray ) {
        
        if (user_id == user.user_id) {
            user.relation = relation;
            [self.table reloadData];
            break;
        }
    }
    
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
        [LoadMoreBtn setTitleColor:kColor666666 forState:UIControlStateNormal];
        [LoadMoreBtn setTitleColor:kColor666666 forState:UIControlStateHighlighted];
        LoadMoreBtn.titleLabel.textAlignment = UITextAlignmentCenter;
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
    indicator.backgroundColor = kColorf2f2f2;
    indicator.center = CGPointMake(kScreenWidth/2, 22.0f);
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    [self.table.tableFooterView addSubview:indicator];
    [GKRecommendFriend RecommendFriendWithPage:page Block:^(NSArray *friendList, NSError *error){
        if (!error)
        {

            [_dataArray addObjectsFromArray: [NSMutableArray arrayWithArray:friendList]];
            page += 1;
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
- (void)backButtonAction:(id)sender
{ 
    
    GKAppDelegate *delegate = ((GKAppDelegate *)[UIApplication sharedApplication].delegate);
    UIGraphicsBeginImageContext(delegate.window.bounds.size);
    
    [delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    delegate.window.rootViewController = delegate.drawerController;
    UIGraphicsBeginImageContext(delegate.window.bounds.size);
    
    [delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:image2];

    
    imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    imageView2.frame = CGRectMake(-320, 0, imageView2.frame.size.width, imageView2.frame.size.height);
    
    [delegate.window addSubview:imageView];
    [delegate.window addSubview:imageView2];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.frame = CGRectMake(320, 0, imageView.frame.size.width, imageView.frame.size.height);
        imageView2.frame = CGRectMake(0, 0, imageView2.frame.size.width, imageView2.frame.size.height);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [imageView2 removeFromSuperview];
    }];
}
- (void)TapButtonAction:(id)sender
{
    NSLog(@"%d",((UIButton *)sender).tag);
    switch (((UIButton *)sender).tag) {
        case 4001:
        {
            [UIView animateWithDuration:0.3 animations:^{
                cate_arrow.center = CGPointMake(80, cate_arrow.center.y);
            }completion:^(BOOL finished) {
                
            }];
            
        }
            break;
        case 4002:
        {
            [self wxShare:0];
        }
            break;
        default:
            break;
    }
}
-(void)wxShare:(int)scene;
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"分享「妈妈清单」应用";
    message.description= @"「妈妈清单」，养孩子必备。";
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


@end
