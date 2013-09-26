//
//  GKUserViewController.m
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserViewController.h"
#import "GKCenterViewController.h"
#import "TMLCellForUser.h"
#import "GKAppDelegate.h"
#import "TMLStage.h"
#import "TMLCate.h"
#import "TMLKeyWord.h"
#import "GKEntity.h"
#import "MMMCalendar.h"
#import "GKDetailViewController.h"
#import "GKEDCSettingViewController.h"
#import "GKVisitedUser.h"
#import "GKFollowButton.h"
@interface GKUserViewController ()

@end

@implementation GKUserViewController
{
@private
    NSMutableArray * _dataArray;
    NSMutableArray * _titleArray;
    NSMutableArray * _entityArray;
    UIView *HeaderView;
    GKUserButton * avatar;
    UILabel * name;
    UILabel * description;
    GKFollowButton *followBTN;
    UIButton *followNumBTN;
    UIButton *fanNumBTN;
    UIButton *likeNumBTN;
    NSIndexPath *indexPathTmp;
    BOOL headerChange;
    MMMCalendar * calendar;
    UIButton * _shareButton;
    float y;
    UIActivityIndicatorView *indicator;
    UIActivityIndicatorView *loading;
    BOOL _loadMoreflag;
    BOOL _canLoadMore;
}
@synthesize user = _user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        self.navigationItem.titleView = [GKTitleView setTitleLabel:@"TA的清单"];
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
- (id)initWithUserID:(NSUInteger)user_id
{
    self = [super init];
    {
        _user_id = user_id;        
    }
    return self;
}
- (id)initWithData:(GKUser *)data
{
    self = [super init];
    {
        if ([data isKindOfClass:[GKUser class]])
        {
            _user_id = data.user_id;
            _user = data;
        }
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"用户清单页";
    _titleArray = [NSMutableArray arrayWithObjects:
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"准备怀孕",@"name",@"1",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"孕期",@"name",@"2",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"待产与产后",@"name",@"5",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0-6个月",@"name",@"6",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6-12个月",@"name",@"8",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1-3岁",@"name",@"9",@"pid",nil]
                   , nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:kGKN_EntityLikeChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowChange:) name:kGKN_UserFollowChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entityChange:) name:kGKN_EntityChange object:nil];
    
    HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    HeaderView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    UIView * timelineBG = [[UIView alloc]initWithFrame:CGRectMake(0,0,40,HeaderView.frame.size.height)];
    timelineBG.backgroundColor = UIColorFromRGB(0xebe7e4);
    [HeaderView addSubview:timelineBG];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 2,150)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor = UIColorFromRGB(0xe2ddd9);
    [HeaderView addSubview:line];
    
    calendar = [[MMMCalendar alloc]initWithFrame:CGRectMake(0, 0, 30, 30) kind:1];
    calendar.center = CGPointMake(20, 30);
 
    
    UIView * user_bg = [[UIView alloc]initWithFrame:CGRectMake(50, 20,260, 110)];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, user_bg.frame.size.width, user_bg.frame.size.height)];
    img.image = [[UIImage imageNamed:@"tables_single.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [user_bg addSubview:img];
    
    UIView * H = [[UIView alloc]initWithFrame:CGRectMake(0, user_bg.frame.size.height-50, user_bg.frame.size.width, 1)];
    H.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [user_bg addSubview:H];
    
    UIView * V1 = [[UIView alloc]initWithFrame:CGRectMake(65, user_bg.frame.size.height-50,1, 50)];
    V1.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [user_bg  addSubview:V1];
    
    UIView * V2 = [[UIView alloc]initWithFrame:CGRectMake(130, user_bg.frame.size.height-50,1, 50)];
    V2.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [user_bg  addSubview:V2];
    
    UIView * V3 = [[UIView alloc]initWithFrame:CGRectMake(195, user_bg.frame.size.height-50,1, 50)];
    V3.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [user_bg  addSubview:V3];
    
    UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(0, user_bg.frame.size.height-20, 65,12)];
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentCenter;
    [tip setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    tip.textColor = UIColorFromRGB(0x999999);
    tip.text = @"关注";
    [user_bg addSubview:tip];
    
    UILabel * tip2 = [[UILabel alloc]initWithFrame:CGRectMake(65,user_bg.frame.size.height-20, 65,12)];
    tip2.backgroundColor = [UIColor clearColor];
    tip2.numberOfLines = 0;
    tip2.textAlignment = NSTextAlignmentCenter;
    [tip2 setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    tip2.textColor = UIColorFromRGB(0x999999);
    tip2.text = @"粉丝";
    [user_bg addSubview:tip2];
    
    UILabel * tip3 = [[UILabel alloc]initWithFrame:CGRectMake(130,user_bg.frame.size.height-20, 65,12)];
    tip3.backgroundColor = [UIColor clearColor];
    tip3.numberOfLines = 0;
    tip3.textAlignment = NSTextAlignmentCenter;
    [tip3 setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    tip3.textColor = UIColorFromRGB(0x999999);
    tip3.text = @"收藏";
    [user_bg addSubview:tip3];
    
    followNumBTN= [[UIButton alloc]initWithFrame:CGRectMake(0, user_bg.frame.size.height-50, 65, 50)];
    followNumBTN.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    [followNumBTN.titleLabel setTextAlignment:NSTextAlignmentCenter];
    followNumBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [followNumBTN setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [followNumBTN setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
    [followNumBTN setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [followNumBTN addTarget:self action:@selector(goFollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [user_bg addSubview:followNumBTN];
    
    fanNumBTN = [[UIButton alloc]initWithFrame:CGRectMake(65, user_bg.frame.size.height-50, 65, 50)];
    fanNumBTN.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    [fanNumBTN.titleLabel setTextAlignment:NSTextAlignmentCenter];
    fanNumBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [fanNumBTN setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [fanNumBTN setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
    [fanNumBTN setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [fanNumBTN addTarget:self action:@selector(goFansButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [user_bg addSubview:fanNumBTN];
    
    likeNumBTN = [[UIButton alloc]initWithFrame:CGRectMake(130, user_bg.frame.size.height-50, 65, 50)];
    likeNumBTN.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    [likeNumBTN.titleLabel setTextAlignment:NSTextAlignmentCenter];
    likeNumBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [likeNumBTN setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [likeNumBTN setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
    [likeNumBTN setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [likeNumBTN addTarget:self action:@selector(showLikeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [user_bg addSubview:likeNumBTN];
    
    _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(203, user_bg.frame.size.height-40, 50, 30)];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
    [_shareButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_shareButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
    [_shareButton setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateNormal];
    [_shareButton setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateHighlighted];
    [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.hidden = YES;
    [user_bg addSubview:_shareButton];
    
    followBTN =  [[GKFollowButton alloc]initWithFrame:CGRectMake(203, user_bg.frame.size.height-40, 50, 30)];
    followBTN.hidden = YES;
    [user_bg addSubview:followBTN];
    
    [HeaderView addSubview:user_bg];
            
    avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
    avatar.center = CGPointMake(85, 40);
    avatar.user = _user;
    [HeaderView addSubview:avatar];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(120, 25, kScreenWidth-150, 25)];
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentLeft;
    [name setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
    name.textColor = [UIColor blackColor];
    name.text = _user.nickname;
    [HeaderView addSubview:name];
    
    description = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, kScreenWidth-100, 15)];
    description.backgroundColor = [UIColor clearColor];
    description.textAlignment = NSTextAlignmentLeft;
    [description setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
    description.textColor = UIColorFromRGB(0x555555);
    [HeaderView addSubview:description];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor = UIColorFromRGB(0xf9f9f9);
    _table.backgroundColor = UIColorFromRGB(0xf9f9f9);
    _table.tableHeaderView = HeaderView;
    _table.allowsSelection = YES;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    [self setTableHeaderView];
    //[self setTableFooterView];
    [self setFooterView:NO];
    y = self.table.contentOffset.y;
    
    UIView * calendarTimelineBG = [[UIView alloc]initWithFrame:CGRectMake(0,0,40,50)];
    calendarTimelineBG .backgroundColor = UIColorFromRGB(0xebe7e4);
    
    
    UIView * calendarLine = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 2,20)];
    calendarLine.center = CGPointMake(20, calendarLine.center.y);
    calendarLine.backgroundColor = UIColorFromRGB(0xe2ddd9);
    
    //[self.view addSubview:calendarTimelineBG];
    //[self.view addSubview:calendarLine];
       [HeaderView addSubview:calendar];
    
    loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.frame = CGRectMake(0, 0, 44, 44);
    loading.backgroundColor = UIColorFromRGB(0xf9f9f9);
    loading.center = CGPointMake(kScreenWidth/2+20, 200);
    loading.hidesWhenStopped = YES;
    [self.view addSubview:loading];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGKN_UserFollowChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGKN_EntityLikeChange object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
}
- (void)reload:(id)sender
{
    [loading startAnimating];
    [GKUser globalUserProfileWithUserID:_user_id Block:^(NSDictionary *dict, NSError *error) {
        if (!error){
            _user = [dict valueForKeyPath:@"content"];
            avatar.user = _user;
            followBTN.data = _user;
            name.text = _user.nickname;
            description.text = _user.bio;
            calendar.date = _user.birth_date;
            [followNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.follows_count] forState:UIControlStateNormal];
            [fanNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.fans_count] forState:UIControlStateNormal];
            [likeNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.liked_count] forState:UIControlStateNormal];
            if([_dataArray count]==0)
            {
                [self loadEntityList];
            }
            else
            {
                [loading stopAnimating];
            }
            GKUser * user = [[GKUser alloc]initFromNSU];
            if(user.user_id == _user.user_id)
            {
                followBTN.hidden = YES;
                _shareButton.hidden = NO;
            }
            else
            {
                followBTN.hidden = NO;
                _shareButton.hidden = YES;
            }
        }
        else
        {
            [loading stopAnimating];
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(!_user.user_id)
    {
        [self reload:nil];
    }
}
-(void)loadEntityList
{
    [loading startAnimating];
    [GKVisitedUser visitedUserWithUserID:_user_id Offset:0 Block:^(NSArray *entitylist, NSError *error) {
        if(!error)
        {
            if([entitylist count] != 0)
            {
            _entityArray = [NSMutableArray arrayWithCapacity:0];
            for (GKEntity * entity in entitylist) {
                BOOL flag = YES;
                for (GKEntity * e in _entityArray) {
                    if(e.entity_id == entity.entity_id)
                    {
                        flag = NO;
                        break;
                    }
                }
                if(flag)
                {
                    [_entityArray addObject:entity];
                }
            }
            [_entityArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"pid" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"cid" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"entity_id" ascending:NO]]];
            
            NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table2"];
            _dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                GKLog(@"%@",_dataArray);
            
                for (NSMutableDictionary * data  in _dataArray ) {
                    for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
                        
                        [[data objectForKey:@"row"] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"necessary" ascending:NO]]];
                    }
                }
            
            NSUInteger tmp_pid = 0;
            NSUInteger tmp_k = 0;
            for (int i = 0;i< [_entityArray count];i++) {
                GKEntity * entity = [_entityArray objectAtIndex:i];
                
                if(tmp_pid == 0)
                {
                    tmp_pid = entity.pid;
                }
                else
                {
                    if(entity.pid != tmp_pid)
                    {
                        tmp_pid = entity.pid;
                        tmp_k = 0;
                    }
                    else
                    {
                        tmp_k = tmp_k;
                    }
                }
                NSMutableArray *array =  [[_dataArray objectAtIndex:[self getIndexByPid:entity.pid]-1]objectForKey:@"row"];
                
                for (int k = tmp_k; k< [array count];k++ ) {
                    NSObject * object  =  [array objectAtIndex:k];
                    if([object isKindOfClass:[TMLKeyWord class]])
                    {
                        if(((TMLKeyWord *)object).kid == entity.cid)
                        {
                            ((TMLKeyWord *)object).count++;
                            [array insertObject:entity atIndex:([array indexOfObjectIdenticalTo:object]+1)];
                            break;
                        }
                    }
                }
                
            }
            NSMutableArray *s_array = [NSMutableArray arrayWithCapacity:0];
            for (NSMutableDictionary * dic in _dataArray) {
                NSMutableArray *array =  [dic objectForKey:@"row"];
                NSMutableArray *k_array = [NSMutableArray arrayWithCapacity:0];
                for (NSObject * object  in array ) {
                    if([object isKindOfClass:[TMLKeyWord class]])
                    {
                        
                        NSUInteger  i = [array indexOfObjectIdenticalTo:object];
                        if(i< ([array count]-1))
                        {
                            if([[array objectAtIndex:(i+1)]  isKindOfClass:[TMLKeyWord class]])
                            {
                                [k_array addObject:object];
                                
                            }
                        }
                        else if ((i == ([array count]-1))&&[[array objectAtIndex:i]  isKindOfClass:[TMLKeyWord class]] )
                        {
                            [k_array addObject:object];
                        }
                    }
                    
                }
                
                [array removeObjectsInArray:k_array];
                if([array count]==0)
                {
                    [s_array addObject:dic];
                }
            }
            [_dataArray removeObjectsInArray:s_array];
            
            if([_entityArray count] == _user.liked_count)
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
                [self setTableFooterView:@"暂时还没有任何喜爱" flag:YES];
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
        [loading stopAnimating];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if([_dataArray count]!=0)
    {
        return [[[_dataArray objectAtIndex:section]objectForKey:@"row"]count];
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    TMLCellForUser *cell = [tableView dequeueReusableCellWithIdentifier:
                     SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[TMLCellForUser alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TMLStage * stage = [[_dataArray objectAtIndex:indexPath.section]objectForKey:@"section"];
    cell.pid = stage.sid;
    cell.delegate = self;
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    NSObject *object = [[[_dataArray objectAtIndex:section]objectForKey:@"row" ]objectAtIndex:row];
    cell.user_id = _user_id;
    if([object isKindOfClass:[GKEntity class]])
    {
        cell.object = object;
    }
    else if ([object isKindOfClass:[TMLKeyWord class]])
    {
        cell.object = object;

        
    }
    else if ([object isKindOfClass:[TMLCate class]])
    {
        cell.object = ((TMLCate *)object);
    }
    else
    {
        cell = nil;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    CGFloat height;
    
    NSObject *object = [[[_dataArray objectAtIndex:section]objectForKey:@"row" ]objectAtIndex:row];
    if([object isKindOfClass:[GKEntity class]])
    {
        height = 98;
        if([[[_dataArray objectAtIndex:section]objectForKey:@"row" ]count]>(row+1))
        {
            NSObject *next = [[[_dataArray objectAtIndex:section]objectForKey:@"row" ]objectAtIndex:row+1];
            if([next isKindOfClass:[GKEntity class]])
            {
                height = 88;
            }
        }
        if(indexPath.row == [[[_dataArray objectAtIndex:section]objectForKey:@"row" ]count]-1)
        {
            height = height +10;
        }
    }
    else if ([object isKindOfClass:[TMLKeyWord class]])
    {
        height = 50;
        if([[[_dataArray objectAtIndex:section]objectForKey:@"row" ]count]>(row+1))
        {
            NSObject *next = [[[_dataArray objectAtIndex:section]objectForKey:@"row" ]objectAtIndex:row+1];
            if([next isKindOfClass:[GKEntity class]])
            {
                height = 44;
            }
        }
    }
    else
    {
        height = 0;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TMLStage * stage = [[_dataArray objectAtIndex:section]objectForKey:@"section"];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,30)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor = UIColorFromRGB(0xe2ddd9);
    [view addSubview:line];
    
    UIImageView * labelbg = [[UIImageView alloc]initWithFrame:CGRectMake(33, 0,kScreenWidth-33,30)];
    labelbg.image = [[UIImage imageNamed:@"timeline_arrow.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:5];
    [view addSubview:labelbg];
    
    UIButton * label = [[UIButton alloc]initWithFrame:CGRectMake(40, 0,kScreenWidth-30,30)];
    [label.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [label setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    label.backgroundColor = [UIColor clearColor];
    [label.titleLabel setTextAlignment:NSTextAlignmentLeft];
    label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [label setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    label.userInteractionEnabled = NO;
    [label setTitle:stage.name forState:UIControlStateNormal];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 14, 14)];
    image.center = CGPointMake(20, image.center.y);
    image.backgroundColor = [UIColor clearColor];
    image.image =[UIImage imageNamed:@"timeline_dot.png"];    
    [view addSubview:label];
    [view addSubview:image];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSObject *object = [[[_dataArray objectAtIndex:section]objectForKey:@"row" ]objectAtIndex:row];
    if([object isKindOfClass:[GKEntity class]])
    {
        [self showDetailWithData:(GKEntity *)object];
    }
    
}

- (void)setTableHeaderView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    view.backgroundColor = UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,view.frame.size.height)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor = UIColorFromRGB(0xe2ddd9);
    [view addSubview:line];
    
    UIView * colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectMake(40,0,view.frame.size.width-40,view.frame.size.height)];
    colorf9f9f9.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [view addSubview:colorf9f9f9];
    
    [_table addSubview:view];
}
- (void)setTableFooterView
{
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0,self.view.frame.size.width, self.view.bounds.size.height)];
    view.backgroundColor =UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,view.frame.size.height)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor =UIColorFromRGB(0xe2ddd9);
    [view addSubview:line];
    
    UIView * colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectMake(40,0,view.frame.size.width-40,view.frame.size.height)];
    colorf9f9f9.backgroundColor =UIColorFromRGB(0xf9f9f9);
    [view addSubview:colorf9f9f9];
    
    footerview.layer.masksToBounds = NO;
    [footerview addSubview:view];
    _table.tableFooterView = footerview;
    
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
- (void)goFollowButtonAction:(id)sender
{

        [self showUserFollowWithUserID:_user_id];
    
}
- (void)goFansButtonAction:(id)sender
{
        [self showUserFansWithUserID:_user_id];
}
- (void)showLikeButtonAction
{
    NSIndexPath * indexPath =  [NSIndexPath indexPathForRow:1 inSection:0];
    if([self tableView:self.table numberOfRowsInSection:0]>1)
    {
        [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)userFollowChange:(NSNotification *)noti
{
    NSDictionary *data = [noti userInfo];
    GKUser * me = [[GKUser alloc]initFromNSU];
    GKUserRelation *relation = [data objectForKey:@"relation"];
    if (_user_id == me.user_id) {
        followBTN.data = _user;
        switch (relation.status) {
            case kNoneRelation:
            {
                _user.follows_count--;
            }
                break;
            case kFOLLOWED:
            {
                _user.follows_count++;
            }
                break;
            case kFANS:
            {
                _user.follows_count--;
            }
                break;
            case kBothRelation:
            {
                _user.follows_count++;
            }
                break;
            case kMyself:
            {

            }
                break;
            default:
            {
    
            }
                break;
        }
        [me save];
        [followNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.follows_count] forState:UIControlStateNormal];
    }
    else
    {
        NSUInteger user_id = [[data objectForKey:@"userID"]integerValue];
        GKUserRelation *relation = [data objectForKey:@"relation"];
        if (_user.user_id == user_id) {
            _user.relation = relation;
            followBTN.data = _user;
            switch (relation.status) {
                case kNoneRelation:
                {
                    _user.fans_count--;
                }
                    break;
                case kFOLLOWED:
                {
                    _user.fans_count++;
                }
                    break;
                case kFANS:
                {
                    _user.fans_count--;
                }
                    break;
                case kBothRelation:
                {
                    _user.fans_count++;
                }
                    break;
                case kMyself:
                {
                    
                }
                    break;
                default:
                {
                    
                }
                    break;
            }
        }
        [fanNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.fans_count] forState:UIControlStateNormal];
    }

    
}
- (void)cardLikeChange:(NSNotification *)noti
{

    NSDictionary *notidata = [noti userInfo];
    NSUInteger entity_id = [[notidata objectForKey:@"entityID"]integerValue];
    GKEntityLike * entitylike = [notidata objectForKey:@"likeStatus"];
    GKUser * user = [[GKUser alloc]initFromNSU];
  if(_user_id != user.user_id)
  {
      return;
  }
    if(entitylike.status)
    {

        _user.liked_count++;
        GKEntity * entity = [notidata objectForKey:@"entity"];
        int pid = 20;
        for(NSString  * pidString in entity.pid_list ) {
            if(pid > [pidString integerValue])
            {
                pid = [pidString integerValue];
            }
        }
        entity.pid = pid;
        [_entityArray addObject:entity];
        
        [_entityArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"pid" ascending:YES],
         [NSSortDescriptor sortDescriptorWithKey:@"cid" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"entity_id" ascending:NO]]];
        
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table2"];
        _dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        for (NSMutableDictionary * data  in _dataArray ) {
            for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
                
                [[data objectForKey:@"row"] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"necessary" ascending:NO]]];
            }
        }
        NSUInteger tmp_pid = 0;
        NSUInteger tmp_k = 0;
        for (int i = 0;i< [_entityArray count];i++) {
            GKEntity * entity = [_entityArray objectAtIndex:i];
            
            if(tmp_pid == 0)
            {
                tmp_pid = entity.pid;
            }
            else
            {
                if(entity.pid != tmp_pid)
                {
                    tmp_pid = entity.pid;
                    tmp_k = 0;
                }
                else
                {
                    tmp_k = tmp_k;
                }
            }
            NSMutableArray *array =  [[_dataArray objectAtIndex:[self getIndexByPid:entity.pid]-1]objectForKey:@"row"];
            
            for (int k = tmp_k; k< [array count];k++ ) {
                NSObject * object  =  [array objectAtIndex:k];
                if([object isKindOfClass:[TMLKeyWord class]])
                {
                    if(((TMLKeyWord *)object).kid == entity.cid)
                    {
                        ((TMLKeyWord *)object).count++;
                        [array insertObject:entity atIndex:([array indexOfObjectIdenticalTo:object]+1)];
                        break;
                    }
                }
            }
            
        }
    }
    else
    {
        bool flag = NO;
        _user.liked_count--;
        int index = 0;
        for (NSMutableDictionary * dic in _dataArray) {
            NSMutableArray *array =  [dic objectForKey:@"row"];
            for (NSObject * object  in array ) {
                
                if([object isKindOfClass:[GKEntity class]])
                {
                    if(((GKEntity *)object).entity_id == entity_id)
                    {
                        index = [array indexOfObject:object];
                        [array removeObject:object];
                        flag = YES;
                        break;
                    }
                }
            }
            if (flag) {
                {
                    for (int k = index-1; k>=0; k--) {
                        NSObject * obj = [array objectAtIndex:k];
                        if([obj isKindOfClass:[TMLKeyWord class]])
                        {
                            ((TMLKeyWord *)obj).count--;
                            break;
                        }
                    }
                    break;
                }
            }
        }
        
        NSMutableArray * r_array = [[NSMutableArray alloc]initWithCapacity:0];
        for (GKEntity * entity in _entityArray) {
            if(entity.entity_id == entity_id)
            {
                [r_array addObject:entity];
            }
        }
        [_entityArray removeObjectsInArray:r_array];
       
    }
    NSMutableArray *s_array = [NSMutableArray arrayWithCapacity:0];
    for (NSMutableDictionary * dic in _dataArray) {
        NSMutableArray *array =  [dic objectForKey:@"row"];
        NSMutableArray *k_array = [NSMutableArray arrayWithCapacity:0];
        for (NSObject * object  in array ) {
            if([object isKindOfClass:[TMLKeyWord class]])
            {
                
                NSUInteger  i = [array indexOfObjectIdenticalTo:object];
                if(i< ([array count]-1))
                {
                    if([[array objectAtIndex:(i+1)]  isKindOfClass:[TMLKeyWord class]])
                    {
                        [k_array addObject:object];
                        
                    }
                }
                else if ((i == ([array count]-1))&&[[array objectAtIndex:i]  isKindOfClass:[TMLKeyWord class]] )
                {
                    [k_array addObject:object];
                }
            }
            
        }
        
        [array removeObjectsInArray:k_array];
        if([array count]==0)
        {
            [s_array addObject:dic];
        }
    }
    if([_entityArray count] == _user.liked_count)
    {
        [self setFooterView:NO];
    }
    else
    {
        [self setFooterView:YES];
    }
    if([_entityArray count]==0)
    {
        [self setTableFooterView:@"暂时还没有任何喜爱" flag:YES];
    }
    [_dataArray removeObjectsInArray:s_array];
    [self.table reloadData];
     [likeNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.liked_count] forState:UIControlStateNormal];

}
- (void)entityChange:(NSNotification *)noti
{
    
    NSDictionary *notidata = [noti userInfo];
    NSUInteger entity_id = [[notidata objectForKey:@"entityID"]integerValue];
    GKEntity * entity = [notidata objectForKey:@"entity"];
    int index = -1;
    for (GKEntity * e in  _entityArray) {
        if(e.entity_id == entity_id)
        {
            index = [_entityArray indexOfObject:e];
            entity.pid = e.pid;
            break;
        }
    }
    
    if(index!=-1)
    {
        [_entityArray replaceObjectAtIndex:index withObject:entity];
    }
    
    
    for (NSMutableDictionary *dic in _dataArray) {

    NSMutableArray *array =  [dic objectForKey:@"row"];
    int i = -1;
    for (int k = 0; k< [array count];k++ ) {
        NSObject * object  =  [array objectAtIndex:k];
        if([object isKindOfClass:[GKEntity class]])
        {
            if(((GKEntity*)object).entity_id == entity_id)
            {
                i = k;
                GKEntity * e =  (GKEntity * )object;
                entity.pid = e.pid;
                break;
            }
        }
    }
    if(i!=-1)
    {
        [[[_dataArray objectAtIndex:[_dataArray indexOfObject:dic]]objectForKey:@"row"] replaceObjectAtIndex:i withObject:entity];
        break;
    }

    }
    
    [self.table reloadData];
    
}

- (void)shareButtonAction:(id)sender
{
    UIActionSheet * shareOptionSheet = nil;
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        shareOptionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博",@"分享给微信好友",@"分享到朋友圈", nil];
    }
    else {
        shareOptionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博", nil];
    }
    
    [shareOptionSheet showInView:self.view];
    [shareOptionSheet setActionSheetStyle:UIActionSheetStyleDefault];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL wxShare = NO;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        wxShare = YES;
    }
    switch (buttonIndex) {
        case 0:
        {
            [self sinaShare];
        }
            break;
        case 1:
        {
            if (wxShare) {[self wxShare:0];}
        }
            break;
        case 2:
        {
            if (wxShare) {[self wxShare:1];}
        }
            break;
        default:
        {
        }
            
    }
}
- (void)sinaShare
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                    withAction:@"sina_share"
                                                     withLabel:nil
                                                     withValue:nil];
    NSString *clickUrl = [NSString stringWithFormat:@"%@的『妈妈清单』 http://mamaqingdan.com/u/%d/ (分享自@妈妈清单) ",_user.nickname,_user_id];
    NSString *postContent = [NSString stringWithFormat:@"%@%@",@"",clickUrl];
    [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/upload_url_text.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               postContent, @"status",
                               @"http://static.guoku.com/static/images/mm-weibo-share.png", @"url", nil]
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
    [GKMessageBoard hideMB];
    if((error.code ==21315)||(error.code == 10006))
    {
        SinaWeibo *sinaweibo = [self sinaweibo];
        [sinaweibo logIn];
    }
    else if(error.code ==10007)
    {
        [GKMessageBoard showMBWithText:@"图片加载异常，不能进行微博分享" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
    else
    {
        [GKMessageBoard showMBWithText:[NSString stringWithFormat:@"网络错误%u",error.code] customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [GKMessageBoard hideActivity];
    [GKMessageBoard showMBWithText:@"分享成功" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
}
- (void)wxShare:(int)scene
{
    if(scene ==0)
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"微信分享"
                                                        withAction:@"给好友"
                                                         withLabel:nil
                                                         withValue:nil];
    }
    else
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"微信分享"
                                                        withAction:@"到朋友圈"
                                                         withLabel:nil
                                                         withValue:nil];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    
    [message setThumbImage:[UIImage imageNamed: @"wxshare.png"]];

    WXWebpageObject *webPage = [WXWebpageObject object];
    webPage.webpageUrl = [NSString stringWithFormat:@"%@u/%u/",kGK_WeixinShareURL,_user.user_id];
    GKLog(@"webpageUrl---%@",webPage.webpageUrl);
    message.mediaObject = webPage;
    message.title = @"妈妈清单 - iPhone上最好用的妈妈购物APP";
    if(scene ==1)
    {
        message.title = [NSString stringWithFormat:@"%@的清单",_user.nickname];
        message.description = @"";
    }
    else
    {
        message.title = @"妈妈清单 - iPhone上最好用的妈妈购物APP";
        message.description = [NSString stringWithFormat:@"%@的清单",_user.nickname];
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene =scene;
    
    if ([WXApi sendReq:req]) {
        GKLog(@"wei xin");
    }
    else{
        [GKMessageBoard showMBWithText:@"图片太大，请关闭高清图片按钮" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
}
- (void)setFooterView:(BOOL)yes
{
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0,self.view.frame.size.width, self.view.bounds.size.height)];
    view.backgroundColor =UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,view.frame.size.height)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor =UIColorFromRGB(0xe2ddd9);
    [view addSubview:line];
    
    UIView * colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectMake(40,0,view.frame.size.width-40,view.frame.size.height)];
    colorf9f9f9.backgroundColor =UIColorFromRGB(0xf9f9f9);
    [view addSubview:colorf9f9f9];
    
    footerview.layer.masksToBounds = NO;
    [footerview addSubview:view];
    _table.tableFooterView = footerview;
    if (yes) {
        _canLoadMore =YES;
        UIButton * LoadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        LoadMoreBtn.frame = CGRectMake(40, 0, 320.0f-40, 44.0f);
        [LoadMoreBtn setBackgroundColor:[UIColor clearColor]];
        [LoadMoreBtn setUserInteractionEnabled:YES];
        [LoadMoreBtn setTitle:@"点击查看更多" forState:UIControlStateNormal];
        [LoadMoreBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [LoadMoreBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateHighlighted];
        LoadMoreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        LoadMoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        LoadMoreBtn.tag = 9090;
        [LoadMoreBtn addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
        [footerview addSubview:LoadMoreBtn];
    }
    else {
        _canLoadMore =NO;
        [[footerview viewWithTag:9090]removeFromSuperview];

    }
}
- (void)loadMore
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(40, 0, kScreenWidth-40, 44);
    indicator.backgroundColor = UIColorFromRGB(0xf9f9f9);
    indicator.center = CGPointMake(kScreenWidth/2+20, 22.0f);
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    [self.table.tableFooterView addSubview:indicator];
    

    [GKVisitedUser visitedUserWithUserID:_user_id Offset:[_entityArray count] Block:^(NSArray *entitylist, NSError *error) {
        if(!error)
        {
            if ([entitylist count] == 0) {
                [GKMessageBoard showMBWithText:@"没有更多。" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            }
            else
            {
            for (GKEntity * entity in entitylist) {
                BOOL flag = YES;
                for (GKEntity * e in _entityArray) {
                    if(e.entity_id == entity.entity_id)
                    {
                        flag = NO;
                        break;
                    }
                }
                if(flag)
                {
                    [_entityArray addObject:entity];
                }
            }
            [_entityArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"pid" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"cid" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"entity_id" ascending:NO]]];
            
            NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table2"];
            _dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                for (NSMutableDictionary * data  in _dataArray ) {
                    for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
                        
                        [[data objectForKey:@"row"] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"necessary" ascending:NO]]];
                    }
                }
            
            NSUInteger tmp_pid = 0;
            NSUInteger tmp_k = 0;
            for (int i = 0;i< [_entityArray count];i++) {
                GKEntity * entity = [_entityArray objectAtIndex:i];
                
                if(tmp_pid == 0)
                {
                    tmp_pid = entity.pid;
                }
                else
                {
                    if(entity.pid != tmp_pid)
                    {
                        tmp_pid = entity.pid;
                        tmp_k = 0;
                    }
                    else
                    {
                        tmp_k = tmp_k;
                    }
                }
                NSMutableArray *array =  [[_dataArray objectAtIndex:entity.pid-1]objectForKey:@"row"];
                
                for (int k = tmp_k; k< [array count];k++ ) {
                    NSObject * object  =  [array objectAtIndex:k];
                    if([object isKindOfClass:[TMLKeyWord class]])
                    {
                        if(((TMLKeyWord *)object).kid == entity.cid)
                        {
                            ((TMLKeyWord *)object).count++;
                            [array insertObject:entity atIndex:([array indexOfObjectIdenticalTo:object]+1)];
                            break;
                        }
                    }
                }
                
            }
            NSMutableArray *s_array = [NSMutableArray arrayWithCapacity:0];
            for (NSMutableDictionary * dic in _dataArray) {
                NSMutableArray *array =  [dic objectForKey:@"row"];
                NSMutableArray *k_array = [NSMutableArray arrayWithCapacity:0];
                for (NSObject * object  in array ) {
                    if([object isKindOfClass:[TMLKeyWord class]])
                    {
                        
                        NSUInteger  i = [array indexOfObjectIdenticalTo:object];
                        if(i< ([array count]-1))
                        {
                            if([[array objectAtIndex:(i+1)]  isKindOfClass:[TMLKeyWord class]])
                            {
                                [k_array addObject:object];
                                
                            }
                        }
                        else if ((i == ([array count]-1))&&[[array objectAtIndex:i]  isKindOfClass:[TMLKeyWord class]] )
                        {
                            [k_array addObject:object];
                        }
                    }
                    
                }
                
                [array removeObjectsInArray:k_array];
                if([array count]==0)
                {
                    [s_array addObject:dic];
                }
            }
            [_dataArray removeObjectsInArray:s_array];
            [self.table reloadData];
            }
            [indicator stopAnimating];
            _loadMoreflag = NO;
            if([_entityArray count] == _user.liked_count)
            {
                [self setFooterView:NO];
            }
            else
            {
                [self setFooterView:YES];
            }
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
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0,self.view.frame.size.width, self.view.bounds.size.height)];
    view.backgroundColor =UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,view.frame.size.height)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor =UIColorFromRGB(0xe2ddd9);
    [view addSubview:line];
    
    UIView * colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectMake(40,0,view.frame.size.width-40,view.frame.size.height)];
    colorf9f9f9.backgroundColor =UIColorFromRGB(0xf9f9f9);
    [view addSubview:colorf9f9f9];
    
    footerview.layer.masksToBounds = NO;
    [footerview addSubview:view];
    _table.tableFooterView = footerview;
    if (flag) {
        UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 130, 113)];
        [imageview1 setCenter:CGPointMake(160+20.0f,60)];
        [imageview1 setImage:[UIImage imageNamed:@"nomore.png"]];
        imageview1.userInteractionEnabled = YES;
        [footerview addSubview:imageview1];
        
        UIButton * tip = [UIButton buttonWithType:UIButtonTypeCustom];
        tip.userInteractionEnabled = NO;
        tip.frame = CGRectMake(45, imageview1.frame.size.height+imageview1.frame.origin.y+15, kScreenWidth-45, 20.0f);
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setUserInteractionEnabled:YES];
        [tip setTitle:@"暂时还没有收藏" forState:UIControlStateNormal];
        [tip setTitleColor:UIColorFromRGB(0xe4ded7) forState:UIControlStateNormal];
        [tip setTitleColor:UIColorFromRGB(0xe4ded7) forState:UIControlStateHighlighted];
        tip.titleLabel.textAlignment = NSTextAlignmentCenter;
        tip.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        tip.tag = 9090;
        [footerview addSubview:tip];
        

    }
    self.table.tableFooterView = footerview;

}
- (NSUInteger)getIndexByPid:(NSUInteger)pid
{
    for (NSDictionary * dic in _titleArray) {
        if([[dic objectForKey:@"pid"] integerValue] == pid)
        {
            return [_titleArray indexOfObject:dic]+1;
        }
    }
    return 1;
}

@end
