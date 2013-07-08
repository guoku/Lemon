//
//  TMLKeywordViewController.m
//  MMM
//
//  Created by huiter on 13-6-21.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "TMLKeywordViewController.h"
#import "GKPopular.h"
#import "GKAppDelegate.h"
#import "TableViewCellForTwo.h"
#import "MMMKWD.h"
@interface TMLKeywordViewController ()

@end

@implementation TMLKeywordViewController

{
@private
    NSMutableDictionary *dataArrayDic;
    UIActivityIndicatorView *indicator;
    BOOL _canLoadMore;
    BOOL _loadMoreflag;
    UIImageView *cate_arrow;
    NSUInteger _pid;
    NSUInteger _cid;
    NSMutableDictionary *yOffsetDictionary;
    NSMutableDictionary *pageDictionary;
    NSString *group;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        self.navigationItem.titleView = [GKTitleView  setTitleLabel:@"分类"];
        pageDictionary = [[NSMutableDictionary alloc] init];
        [pageDictionary setObject:@(1) forKey:@"best"];
        [pageDictionary setObject:@(1) forKey:@"new"];
        dataArrayDic = [[NSMutableDictionary alloc] init];
        yOffsetDictionary = [[NSMutableDictionary alloc] init];
        group = @"best";
        _canLoadMore = NO;
    }
    return self;
}
-(id)initWithPid:(NSUInteger)pid Cid:(NSUInteger)cid
{
    self = [super init];
    {
        _pid = pid;
        _cid = cid;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reload:(id)sender
{
    [pageDictionary setObject:@(1) forKey:@"best"];
    [pageDictionary setObject:@(1) forKey:@"new"];
    [MMMKWD globalKWDWithGroup:group Pid:_pid Cid:_cid Page:1 Block:^(NSArray *array, NSError *error) {
        if(!error)
        {
            [dataArrayDic setObject: [NSMutableArray arrayWithArray:array] forKey:group];
            [self.table reloadData];
            if([array count] >25 )
            {
                [self setFooterView:YES];
            }
            else
            {
                [self setFooterView:NO];
            }
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(([[dataArrayDic objectForKey:group] count] == 0)&&(!_reloading))
    {
        [self refresh];
    }
}

- (void)loadView
{
    [super loadView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    bg.backgroundColor =UIColorFromRGB(0xf1f1f1);
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
    [button setImage:[UIImage imageNamed:@"category_icon_star.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"category_icon_star.png"] forState:UIControlStateHighlighted];
    
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [button setTitle:@"高评价" forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 4001;
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(90, 0, 90, 40)];
    [button2 setImage:[UIImage imageNamed:@"category_icon_new.png"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"category_icon_new.png"] forState:UIControlStateHighlighted];
    [button2.titleLabel setTextAlignment:NSTextAlignmentLeft];
    button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button2 setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [button2 setTitle:@"新上架" forState:UIControlStateNormal];
    [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button2 addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 4002;
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(180, 0, 140, 40)];
    [button3 setImage:[UIImage imageNamed:@"category_icon_friends.png"] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"category_icon_friends.png"] forState:UIControlStateHighlighted];
    [button3.titleLabel setTextAlignment:NSTextAlignmentLeft];
    button3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button3.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [button3 setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [button3 setTitle:@"好友的精选" forState:UIControlStateNormal];
    [button3 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button3 addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag = 4003;
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrow.frame = CGRectMake(300, 13, 8, 14);
    [bg addSubview:button];
    [bg addSubview:button2];
    [bg addSubview:button3];
    [bg addSubview:arrow];
    
    UIView *V1 = [[UIView alloc]initWithFrame:CGRectMake(90, 0, 1, 40)];
    V1.backgroundColor =UIColorFromRGB(0xe4e4e4);
    UIView *V2 = [[UIView alloc]initWithFrame:CGRectMake(180, 0, 1, 40)];
    V2.backgroundColor =UIColorFromRGB(0xe4e4e4);
    UIView *H1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    H1.backgroundColor =UIColorFromRGB(0xe4e4e4);
    
    [bg addSubview:H1];
    [bg addSubview:V1];
    [bg addSubview:V2];
    
    cate_arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"category_arrow.png"]];
    cate_arrow.frame = CGRectMake(0,39, 15,8);
    cate_arrow.center = CGPointMake(45, cate_arrow.center.y);
    cate_arrow.backgroundColor = [UIColor clearColor];
    
    [view addSubview:bg];
    [view addSubview:cate_arrow];

    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 44-40) style:UITableViewStylePlain];
    _table.backgroundColor =UIColorFromRGB(0xf9f9f9);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor =UIColorFromRGB(0xf9f9f9);
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
    
    [self.view addSubview:view];
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
       return ceil([[dataArrayDic objectForKey:group] count]/2.0f);
    }
    return 0;
}

//定义每个Row
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PopularTableIdentifier = @"Popular";
    
    TableViewCellForTwo *cell = [tableView dequeueReusableCellWithIdentifier:
                                 PopularTableIdentifier];
    if (cell == nil) {
        cell = [[TableViewCellForTwo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: PopularTableIdentifier];
    }
    cell.delegate = self;
    NSMutableArray * a = [dataArrayDic objectForKey:group];
    cell.dataArray =[NSMutableArray arrayWithObjects:[a objectAtIndex:(indexPath.row*2)], [a objectAtIndex:(indexPath.row*2+1)],nil];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}
- (void)refresh
{
    _reloading = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.table.tableFooterView.hidden = YES;
    [self makeHearderReloading];
    [self performSelector:@selector(reload:) withObject:nil afterDelay:0.3];
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
#pragma mark - 刷新函数
-(void)reloadTableViewDataSource
{
    _reloading = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.table.tableFooterView.hidden = YES;
    [self reload:nil];
    
}
- (void)doneLoadingTableViewData{
    _reloading = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.table.tableFooterView.hidden = NO;
    CGPoint offset = self.table.contentOffset;
    offset.y = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentOffset = offset;
    }completion:^(BOOL finished) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    }];
}
- (void)AllReset{
    _reloading = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.table.tableFooterView.hidden = NO;
    CGPoint offset = self.table.contentOffset;
    offset.y = 0.0;
    [UIView animateWithDuration:0.0 animations:^{
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

- (void)TapButtonAction:(id)sender
{
    [yOffsetDictionary setObject:@(_table.contentOffset.y) forKey:group];
    switch (((UIButton *)sender).tag) {
        case 4001:
        {
            [UIView animateWithDuration:0.3 animations:^{
                cate_arrow.center = CGPointMake(45, cate_arrow.center.y);
            }completion:^(BOOL finished) {
                group = @"best";
                [self.table reloadData];
                if([[dataArrayDic objectForKey:group] count] == 0)
                {
                    [self refresh];
                }
                else
                {
                    [self reloadDataWithYoffset];
                }
            }];

        }
            break;
        case 4002:
        {
            [UIView animateWithDuration:0.3 animations:^{
                cate_arrow.center = CGPointMake(135, cate_arrow.center.y);
            }completion:^(BOOL finished) {
                group = @"new";
                [self.table reloadData];
                if([[dataArrayDic objectForKey:group] count] == 0)
                {
                    [self refresh];
                }
                else
                {
                    [self reloadDataWithYoffset];
                }
            }];
        }
            break;
        case 4003:
        {
            [UIView animateWithDuration:0.3 animations:^{
                //cate_arrow.center = CGPointMake(250, cate_arrow.center.y);
            }completion:^(BOOL finished) {
                
            }];
        }
            break;
        default:
            break;
    }
}
- (void)reloadDataWithYoffset
{
    [self.table reloadData];
    
    if ([[yOffsetDictionary objectForKey:group] floatValue] <= self.table.contentSize.height - self.table.frame.size.height) {
        [self.table setContentOffset:CGPointMake(0,[[yOffsetDictionary objectForKey:group]floatValue]) animated:NO];
    }
    [self.table reloadData];

}
- (void)setFooterView:(BOOL)yes
{
    if (yes) {
        _canLoadMore = YES;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
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
        _canLoadMore = NO;
        self.table.tableFooterView = nil;
    }
}

- (void)loadMore
{
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, kScreenWidth, 44);
    indicator.backgroundColor = UIColorFromRGB(0xf9f9f9);
    indicator.center = CGPointMake(kScreenWidth/2, 22.0f);
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    [self.table.tableFooterView addSubview:indicator];
    
    [MMMKWD globalKWDWithGroup:group Pid:_pid Cid:_cid Page:([[pageDictionary objectForKey:group] intValue]+1)  Block:^(NSArray *array, NSError *error) {
        if(!error)
        {
            
            [indicator stopAnimating];
            [pageDictionary setObject:@([[pageDictionary objectForKey:group] intValue]+1) forKey:group];
            [[dataArrayDic  objectForKey:group ] addObjectsFromArray:[NSMutableArray arrayWithArray:array] ];
            [self.table reloadData];
            if([array count] >25 )
            {
                [self setFooterView:YES];
            }
            else
            {
                [self setFooterView:NO];
            }
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
@end
