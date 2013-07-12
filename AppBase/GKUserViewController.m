//
//  GKUserViewController.m
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserViewController.h"
#import "GKCenterViewController.h"
#import "GKAppDelegate.h"
#import "TMLStage.h"
#import "TMLCate.h"
#import "TMLKeyWord.h"
#import "GKEntity.h"
#import "MMMCalendar.h"
#import "TMLCell.h"
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
    float y;
}
@synthesize user = _user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
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
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:kGKN_EntityLikeChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowChange:) name:kGKN_UserFollowChange object:nil];
    
    HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    HeaderView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    UIView * timelineBG = [[UIView alloc]initWithFrame:CGRectMake(0,0,40,HeaderView.frame.size.height)];
    timelineBG.backgroundColor = UIColorFromRGB(0xebe7e4);
    [HeaderView addSubview:timelineBG];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 2,150)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor = UIColorFromRGB(0xe2ddd9);
    [HeaderView addSubview:line];
    
    MMMCalendar * calendar = [[MMMCalendar alloc]initWithFrame:CGRectMake(0, 0, 30, 30) kind:1];
    calendar.center = CGPointMake(20, 30);
    calendar.date = [NSDate dateFromString:@"2013-11-23" WithFormatter:@"yyyy-MM-dd"];
    [self.view addSubview:calendar];
    
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
    likeNumBTN.userInteractionEnabled = NO;
    [user_bg addSubview:likeNumBTN];
    
    followBTN =  [[GKFollowButton alloc]initWithFrame:CGRectMake(203, user_bg.frame.size.height-40, 50, 30)];
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
    _table.allowsSelection = NO;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    [self setTableHeaderView];
    [self setTableFooterView];
    y = self.table.contentOffset.y;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGKN_UserFollowChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:kGKN_EntityLikeChange object:nil];
}

- (void)reload:(id)sender
{
    [GKUser globalUserProfileWithUserID:_user_id Block:^(NSDictionary *dict, NSError *error) {
        if (!error){
            _user = [dict valueForKeyPath:@"content"];
            avatar.user = _user;
            followBTN.data = _user;
            name.text = _user.nickname;
            description.text = _user.bio;
            [followNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.follows_count] forState:UIControlStateNormal];
            [fanNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.fans_count] forState:UIControlStateNormal];
            [likeNumBTN setTitle:[NSString stringWithFormat:@"%d",_user.liked_count] forState:UIControlStateNormal];
            [self loadEntityList];
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
    if([_dataArray count]==0)
    {
    [GKVisitedUser visitedUserWithUserID:_user_id Page:1 Block:^(NSArray *entitylist, NSError *error) {
        if(!error)
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
            
            NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table2"];
            _dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            for (GKEntity * entity in _entityArray) {
                NSMutableArray *array =  [[_dataArray objectAtIndex:entity.pid]objectForKey:@"row"];
                for (NSObject * object  in array ) {
                    if([object isKindOfClass:[TMLKeyWord class]])
                    {
                        if(((TMLKeyWord *)object).kid == entity.cid)
                        {
                            
                            [array insertObject:entity atIndex:[array indexOfObjectIdenticalTo:object]];
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
                        NSLog(@"%d",i);
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
    }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_dataArray objectAtIndex:section]objectForKey:@"row"]count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    TMLCell *cell = [tableView dequeueReusableCellWithIdentifier:
                     SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[TMLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier];
    }
    cell.delegate = self;
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    NSObject *object = [[[_dataArray objectAtIndex:section]objectForKey:@"row" ]objectAtIndex:row];
    
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
    NSLog(@"%@",indexPath);
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
    GKLog(@"offset:%f",scrollView.contentOffset.y);
    GKLog(@"height:%f",scrollView.contentSize.height);
}

- (void)goFollowButtonAction:(id)sender
{

        [self showUserFollowWithUserID:_user_id];
    
}
- (void)goFansButtonAction:(id)sender
{
        [self showUserFansWithUserID:_user_id];
}

- (void)userFollowChange:(NSNotification *)noti
{
    NSDictionary *data = [noti userInfo];
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
- (void)cardLikeChange:(NSNotification *)noti
{
    /*
    NSDictionary *notidata = [noti userInfo];
    NSUInteger entity_id = [[notidata objectForKey:@"entityID"]integerValue];
    GKEntityLike * entitylike = [notidata objectForKey:@"likeStatus"];
    if(entitylike.status)
    {
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
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table2"];
        _dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        for (GKEntity * entity in _entityArray) {
            NSMutableArray *array =  [[_dataArray objectAtIndex:entity.pid]objectForKey:@"row"];
            for (NSObject * object  in array ) {
                if([object isKindOfClass:[TMLKeyWord class]])
                {
                    if(((TMLKeyWord *)object).kid == entity.cid)
                    {
                        
                        [array insertObject:entity atIndex:[array indexOfObjectIdenticalTo:object]];
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
                    NSLog(@"%d",i);
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
    }
    else
    {
        bool flag = NO;
        for (NSMutableDictionary * dic in _dataArray) {
            NSMutableArray *array =  [dic objectForKey:@"row"];
            for (NSObject * object  in array ) {
                
                if([object isKindOfClass:[GKEntity class]])
                {
                    if(((GKEntity *)object).entity_id == entity_id)
                    {
                        [array removeObject:object];
                        flag = YES;
                        break;
                    }
                }
            }
            if (flag) {
                break;
            }
        }
     
        for (GKEntity * entity in _entityArray) {
            if(entity.entity_id == entity_id)
            {
                [_entityArray removeObject:entity];
            }
        }
       
    }
    [self.table reloadData];
*/

}

@end
