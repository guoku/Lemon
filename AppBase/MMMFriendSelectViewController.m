//
//  MMMFriendSelectViewController.m
//  MMM
//
//  Created by huiter on 13-7-19.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "MMMFriendSelectViewController.h"
#import "MMMKWDFS.h"
#import "TableViewCellForMMMFS.h"

@interface MMMFriendSelectViewController ()
{
@private
    NSDate * timestamp;
    NSUInteger _pid;
    NSUInteger _cid;
    NSMutableArray * _dataArray;
    UIActivityIndicatorView *indicator;
    BOOL _loadMoreflag;
        BOOL _canLoadMore;
    UIActivityIndicatorView * loading;
}
@end

@implementation MMMFriendSelectViewController
@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                _canLoadMore =NO;
        self.view.backgroundColor = UIColorFromRGB(0xf9f9f9);
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
        [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
        [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
        UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
        [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
        [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
        [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
        
    }
    return self;
}
-(id)initWithPid:(NSUInteger)pid cid:(NSUInteger)cid;
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
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
}
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"好友精选"];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40) style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = YES;
    _table.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self setFooterView:NO];
    
    [self.view addSubview:_table];
    
    loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.frame = CGRectMake(0, 0, 44, 44);
    loading.backgroundColor = UIColorFromRGB(0xf9f9f9);
    loading.center = CGPointMake(kScreenWidth/2, 150);
    loading.hidesWhenStopped = YES;
    [self.view addSubview:loading];
}
- (void)reload:(id)sender
{    [loading startAnimating];
    [MMMKWDFS globalKWDFSWithPid:_pid Cid:_cid Offset:0 Date:nil Block:^(NSDictionary *dic, NSError *error) {
        if(!error)
        {
            timestamp = [dic objectForKey:@"time"];
            if([[dic objectForKey:@"array"] count]!=0)
            {
            _dataArray = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"array"]];
                if([[dic objectForKey:@"array"] count]<30)
                {
                    [self setFooterView:NO];
                }
                else
                {
                    [self setFooterView:YES]; 
                }

                [self.table reloadData];
            }
            else
            {
                [self setTableFooterView:@"暂时还没有好友关注此类产品" flag:YES];
                //[GKMessageBoard showMBWithText:@"没有更多。" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            }
        }
         [loading stopAnimating];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(![_dataArray count])
    {
        [self reload:nil];
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
    
    TableViewCellForMMMFS *cell = [tableView dequeueReusableCellWithIdentifier:
                                     @"MMMFSCell"];
    if (cell == nil) {
        cell = [[TableViewCellForMMMFS alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"messageCell"];
    }
    cell.backgroundColor = UIColorFromRGB(0xf9f9f9);
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.data = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TableViewCellForMMMFS height:[_dataArray objectAtIndex:indexPath.row]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    

    if (scrollView.contentOffset.y+scrollView.frame.size.height >= scrollView.contentSize.height) {
        if((!_loadMoreflag)&&_canLoadMore)
        {
            _loadMoreflag = YES;
            [self loadMore];
        }
	}
	
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
    
    [MMMKWDFS globalKWDFSWithPid:_pid Cid:_cid Offset:[_dataArray count] Date:timestamp Block:^(NSDictionary *dic, NSError *error) {
        
        if(!error)
        {
            timestamp = [dic objectForKey:@"time"];
            if([[dic objectForKey:@"array"] count]!=0)
            {
                [_dataArray addObjectsFromArray:[dic objectForKey:@"array"]];
                [self setFooterView:YES];
            }
            else
            {
                [self setFooterView:NO];
                [GKMessageBoard showMBWithText:@"没有更多。" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            }
            [self.table reloadData];
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
- (void)setTableFooterView:(NSString *)string flag:(BOOL)flag
{
    if(!flag)
    {
        self.table.tableFooterView = nil;
        return ;
    }
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 130, 113)];
    [imageview1 setCenter:CGPointMake(160.0f,120)];
    [imageview1 setImage:[UIImage imageNamed:@"nomore.png"]];
    imageview1.userInteractionEnabled = YES;
    [footerview addSubview:imageview1];
    
    UIButton * tip = [UIButton buttonWithType:UIButtonTypeCustom];
    tip.userInteractionEnabled = NO;
    tip.frame = CGRectMake(5, imageview1.frame.size.height+imageview1.frame.origin.y+15, kScreenWidth-5, 20.0f);
    [tip setBackgroundColor:[UIColor clearColor]];
    [tip setUserInteractionEnabled:YES];
    [tip setTitle:@"这啥都没有！" forState:UIControlStateNormal];
    [tip setTitleColor:UIColorFromRGB(0xe4ded7) forState:UIControlStateNormal];
    [tip setTitleColor:UIColorFromRGB(0xe4ded7) forState:UIControlStateHighlighted];
    tip.titleLabel.textAlignment = NSTextAlignmentCenter;
    tip.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    tip.tag = 9090;
    [footerview addSubview:tip];
    
    self.table.tableFooterView = footerview;
}


@end
