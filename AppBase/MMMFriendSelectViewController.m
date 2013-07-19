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
    NSUInteger _pid;
    NSUInteger _cid;
    NSMutableArray * _dataArray;
}
@end

@implementation MMMFriendSelectViewController
@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        
    }
    return self;
}
-(id)initWithPid:(NSUInteger)pid Category:(TMLKeyWord *)cate
{
    self = [super init];
    {
        _pid = pid;
        _cid = cate.kid;
        self.navigationItem.titleView = [GKTitleView  setTitleLabel:cate.name];
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
    [_table setDelegate:self];
    [_table setDataSource:self];
    
    [self.view addSubview:_table];
}
- (void)reload:(id)sender
{
    [MMMKWDFS globalKWDFSWithPid:_pid Cid:_cid Page:1 Block:^(NSArray *array, NSError *error) {
        
        if(!error)
        {
            _dataArray = [[NSMutableArray alloc]initWithArray:array];
            [self.table reloadData];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self reload:nil];
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
/*
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
 */


@end
