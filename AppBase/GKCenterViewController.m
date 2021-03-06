//
//  GKCenterViewController.m
//  MMM
//
//  Created by huiter on 13-6-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKCenterViewController.h"
#import "CollapseClick.h"
#import "GKAppDelegate.h"
#import "SMPageControl.h"
#import "TMLStage.h"
#import "TMLCate.h"
#import "TMLKeyWord.h"
#import "GKEntity.h"
#import "GKNotePostViewController.h"
#import "MMMCalendar.h"
#import "TMLCell.h"
#import "GKDetailViewController.h"
#import "GKEDCSettingViewController.h"
#import "GKUserViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMMTML.h"
@interface GKCenterViewController ()

@end

@implementation GKCenterViewController
{
@private
    NSMutableDictionary * _dataDic;
    NSMutableArray * _dataArray;
    NSMutableArray * _entityArray;
    NSMutableArray * _titleArray;
    SMPageControl * pageControl;
    UIView *HeaderView;
    BOOL headerChange;
    float y;
    GKUser *user;
    BOOL reload;
}
@synthesize table = _table;
@synthesize icon = _icon;


#pragma mark - LifeCircle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _openLeftMenu = NO;
        _openRightMenu = NO;
        reload = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"阶段清单页";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GKLogin) name: GKUserLoginNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOpenRight) name: @"OpenRightMenu"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GKLogout) name: GKUserLogoutNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProfileChange) name:@"UserProfileChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stageChange) name:@"stageChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:kGKN_EntityLikeChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:kGKN_EntityChange  object:nil];
    _titleArray = [NSMutableArray arrayWithObjects:
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"准备怀孕",@"name",@"1",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"孕期",@"name",@"2",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"待产与产后",@"name",@"5",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0-6个月",@"name",@"6",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6-12个月",@"name",@"8",@"pid",nil],
                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1-3岁",@"name",@"9",@"pid",nil]
                   , nil];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor =UIColorFromRGB(0xf9f9f9);
    _table.backgroundColor =UIColorFromRGB(0xf9f9f9);

    _table.allowsSelection = YES;
    [_table setDelegate:self];
    [_table setDataSource:self];

    [self setTableHeaderView];
    [self setTableFooterView];
    [self.view addSubview:_table];
    
    y = self.table.contentOffset.y;
    
    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(7, 4, 26, 26)];
    _icon.backgroundColor = UIColorFromRGB(0xebe7e4);
    [self.view addSubview:_icon];
    [self stageChange];
    
    UIView *mask = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mask.png"]];
    mask.backgroundColor = [UIColor clearColor];
    mask.center =  CGPointMake(20, 45);
    //[self.view addSubview:mask];
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0,40, 4)];
    view.backgroundColor =UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,4)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor =UIColorFromRGB(0xe2ddd9);
    [view addSubview:line];
    
    [self.view addSubview:view];

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"table"])
    {
        if([_dataArray count] == 0)
        {
            NSInteger pid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"] intValue];
            //NSUInteger stage = [self getIndexByPid:pid];
            NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table"];
            _dataArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data]objectForKey:@(pid)];
            NSMutableDictionary * necessaryDic = [[NSMutableDictionary alloc]init];
            TMLCate *cate = [[TMLCate alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"必备",@"gtt",@"0",@"gid",nil]];
            [necessaryDic setObject:cate forKey:@"section"];
            NSMutableArray * necessaryArray = [[NSMutableArray alloc]init];
            [necessaryDic setObject:necessaryArray forKey:@"row"];
            /*
            NSMutableArray * removeArray = [[NSMutableArray alloc]init];
            for (NSMutableDictionary * data  in _dataArray ) {
                for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
                    
                    NSObject * object  = [[data objectForKey:@"row"]objectAtIndex:i];
                    
                    if([object isKindOfClass:[TMLKeyWord class]])
                    {
                        if(((TMLKeyWord *)object).necessary)
                        {
                            GKLog(@"必备%@",((TMLKeyWord *)object).name);
                            [necessaryArray addObject:object];
                            [removeArray addObject:object];
                            
                        }
                        else
                        {
                            GKLog(@"%@",((TMLKeyWord *)object).name);
                        }
                    }
                    
                }
                [[data objectForKey:@"row"] removeObjectsInArray:removeArray];
            }

            if([necessaryArray count]!=0)
            {
                [_dataArray insertObject:necessaryDic atIndex:0];
            }
             */
            for (NSMutableDictionary * data  in _dataArray ) {
                for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
                    
                    [[data objectForKey:@"row"] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"necessary" ascending:NO]]];
                }
            }
            
            _entityArray = [[NSMutableArray alloc]initWithArray:[GKEntity getEntityWithPid:pid]];
            bool flag = NO;
            
            for (GKEntity * entity in _entityArray)
            {
                for (NSMutableDictionary * data  in _dataArray ) {
                    for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
                        
                        NSObject * object  = [[data objectForKey:@"row"]objectAtIndex:i];
                        
                        if([object isKindOfClass:[TMLKeyWord class]])
                        {
                            if(((TMLKeyWord *)object).kid == entity.cid)
                            {
                                [[data objectForKey:@"row"] insertObject:entity atIndex:([[data objectForKey:@"row"]  indexOfObjectIdenticalTo:object]+1)];
                                ((TMLKeyWord *)object).count++;
                                i++;
                                flag = YES;
                                break;
                            }
                        }
                        
                    }
                    if(flag)
                    {
                        flag = NO;
                        break;
                    }
                    
                }
            }
            
            [self.table reloadData];
        }

    }
    else
    {
        [GKMessageBoard showMBWithText:@"稍等。" customView:[[UIView alloc]initWithFrame:CGRectZero] delayTime:10.0];
        [MMMTML globalTMLWithBlock:^(NSDictionary * dictionary, NSArray *array,NSError *error) {
            if(!error)
            {
                 _dataDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                 _dataArray= [NSMutableArray arrayWithArray:array];
                
                NSData *Data1 = [NSKeyedArchiver archivedDataWithRootObject:_dataArray];
                NSData *Data2 = [NSKeyedArchiver archivedDataWithRootObject:_dataDic];
                [[NSUserDefaults standardUserDefaults] setObject:Data1 forKey:@"table"];
                [[NSUserDefaults standardUserDefaults] setObject:Data2 forKey:@"table2"];
                reload = YES;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已同步完数据，页面即将刷新" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
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
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    [self performSelector:@selector(checkShouldOpenMenu) withObject:nil afterDelay:0.4];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
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
    cell.pid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"] intValue];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
   
            NSObject *object = [[[_dataArray objectAtIndex:section]objectForKey:@"row" ]objectAtIndex:row];
            
            if([object isKindOfClass:[GKEntity class]])
            {
                cell.object = object;
                GKEntity * entity = ((GKEntity *)object);
                if(entity.price == 0)
                {
                    entity.weight ++;
                    [entity saveLittle];
                }
            }
            else if ([object isKindOfClass:[TMLKeyWord class]])
            {
                cell.object = object;
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
    if([[[_dataArray objectAtIndex:section]objectForKey:@"row" ]count] == (row+1))
    {
        height = height +10;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ([[[_dataArray objectAtIndex:section]objectForKey:@"row" ]count]!=0) {
        return 30;
    }
    else
    {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TMLCate * stage = [[_dataArray objectAtIndex:section]objectForKey:@"section"];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor =UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,30)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor =UIColorFromRGB(0xe2ddd9);
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
    image.tag = 2;
    image.image = [UIImage imageNamed:@"timeline_dot.png"];
    
    [view addSubview:label];
    [view addSubview:image];
    view.tag = 1400+section;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10)];
    view.backgroundColor =UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,10)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor =UIColorFromRGB(0xe2ddd9);
    [view addSubview:line];
    
    UIView * colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectMake(40,0,view.frame.size.width-40,view.frame.size.height)];
    colorf9f9f9.backgroundColor =UIColorFromRGB(0xf9f9f9);
    [view addSubview:colorf9f9f9];
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
    view.backgroundColor =UIColorFromRGB(0xebe7e4);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,view.frame.size.height)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor =UIColorFromRGB(0xe2ddd9);
    [view addSubview:line];
    
    UIView * colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectMake(40,0,view.frame.size.width-40,view.frame.size.height)];
    colorf9f9f9.backgroundColor =UIColorFromRGB(0xf9f9f9);
    [view addSubview:colorf9f9f9];
    [_table addSubview:view];
}
- (void)setTableFooterView
{
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
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

}

#pragma mark - 通知处理
- (void)ProfileChange
{
    _openLeftMenu = YES;
    [self stageChange];
}
- (void)stageChange
{
    if(reload)
    {
        return; 
    }
    _icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"stage_list_%@.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"]]];
    NSInteger pid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"] intValue];
    NSUInteger stage = [self getIndexByPid:pid];
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table"];
    _dataArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data]objectForKey:@(pid)];
    NSMutableDictionary * necessaryDic = [[NSMutableDictionary alloc]init];
    TMLCate *cate = [[TMLCate alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"必备",@"gtt",@"0",@"gid",nil]];
    [necessaryDic setObject:cate forKey:@"section"];
    NSMutableArray * necessaryArray = [[NSMutableArray alloc]init];
    [necessaryDic setObject:necessaryArray forKey:@"row"];
     /*
    NSMutableArray * removeArray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary * data  in _dataArray ) {
        for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
            
            NSObject * object  = [[data objectForKey:@"row"]objectAtIndex:i];
            
            if([object isKindOfClass:[TMLKeyWord class]])
            {
                if(((TMLKeyWord *)object).necessary)
                {
                    GKLog(@"必备%@",((TMLKeyWord *)object).name);
                    [necessaryArray addObject:object];
                    [removeArray addObject:object];
                   
                }
                else
                {
                    GKLog(@"%@",((TMLKeyWord *)object).name);
                }
            }
            
        }
        [[data objectForKey:@"row"] removeObjectsInArray:removeArray];
    }
    if([necessaryArray count]!=0)
    {
        [_dataArray insertObject:necessaryDic atIndex:0];
    }
    */
    for (NSMutableDictionary * data  in _dataArray ) {
        for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
            
            [[data objectForKey:@"row"] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"necessary" ascending:NO]]];
        }
    }
    _entityArray = [[NSMutableArray alloc]initWithArray:[GKEntity getEntityWithPid:pid]];
    bool flag = NO;
    for (GKEntity * entity in _entityArray)
    {
        for (NSMutableDictionary * data  in _dataArray ) {
            for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
               
                NSObject * object  = [[data objectForKey:@"row"]objectAtIndex:i];
   
                if([object isKindOfClass:[TMLKeyWord class]])
                {
                    if(((TMLKeyWord *)object).kid == entity.cid)
                    {
                        [[data objectForKey:@"row"] insertObject:entity atIndex:([[data objectForKey:@"row"] indexOfObjectIdenticalTo:object]+1)];
                        ((TMLKeyWord *)object).count++;
                        i++;
                        flag = YES;
                        break;
                    }
                }

            }
            if(flag)
            {
                flag = NO;
                break;
            }
                
        }
    }

    [self.table reloadData];
    self.table.contentOffset = CGPointMake(self.table.contentOffset.x, 0);
    self.navigationItem.titleView = [GKTitleView setTitleLabel:[[_titleArray objectAtIndex:stage-1] objectForKey:@"name"]];

}
- (void)cardLikeChange:(NSNotification *)noti
{
    [self refresh];
}
- (void)refresh
{
    NSInteger pid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pid"] intValue];
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table"];
    _dataArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data]objectForKey:@(pid)];
    
    NSMutableDictionary * necessaryDic = [[NSMutableDictionary alloc]init];
    TMLCate *cate = [[TMLCate alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"必备",@"gtt",@"0",@"gid",nil]];
    [necessaryDic setObject:cate forKey:@"section"];
    NSMutableArray * necessaryArray = [[NSMutableArray alloc]init];
    [necessaryDic setObject:necessaryArray forKey:@"row"];
    /*
    NSMutableArray * removeArray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary * data  in _dataArray ) {
        for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
            
            NSObject * object  = [[data objectForKey:@"row"]objectAtIndex:i];
            
            if([object isKindOfClass:[TMLKeyWord class]])
            {
                if(((TMLKeyWord *)object).necessary)
                {
                    GKLog(@"必备%@",((TMLKeyWord *)object).name);
                    [necessaryArray addObject:object];
                    [removeArray addObject:object];
                    
                }
                else
                {
                    GKLog(@"%@",((TMLKeyWord *)object).name);
                }
            }
            
        }
        [[data objectForKey:@"row"] removeObjectsInArray:removeArray];
    }

    if([necessaryArray count]!=0)
    {
        [_dataArray insertObject:necessaryDic atIndex:0];
    }
    */
    for (NSMutableDictionary * data  in _dataArray ) {
        for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
            
            [[data objectForKey:@"row"] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"necessary" ascending:NO]]];
        }
    }
    _entityArray = [[NSMutableArray alloc]initWithArray:[GKEntity getEntityWithPid:pid]];
    bool flag = NO;
    for (GKEntity * entity in _entityArray)
    {
        for (NSMutableDictionary * data  in _dataArray ) {
            for (int i = 0 ; i<[[data objectForKey:@"row"]count]; i++) {
                
                NSObject * object  = [[data objectForKey:@"row"]objectAtIndex:i];
                
                if([object isKindOfClass:[TMLKeyWord class]])
                {
                    if(((TMLKeyWord *)object).kid == entity.cid)
                    {
                        [[data objectForKey:@"row"] insertObject:entity atIndex:([[data objectForKey:@"row"] indexOfObjectIdenticalTo:object]+1)];
                        ((TMLKeyWord *)object).count++;
                        i++;
                        flag = YES;
                        break;
                    }
                }
                
            }
            if(flag)
            {
                flag = NO;
                break;
            }
            
        }
    }
    
    [self.table reloadData];
    [GKMessageBoard hideMB];
    reload = NO;
}
- (void)showLeftMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
}
- (void)showRightMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:NULL];
}
- (void)checkShouldOpenMenu
{
    if(_openLeftMenu)
    {
        
        [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            _openLeftMenu = NO;
        }];
         
    }
    if(_openRightMenu)
    {
        /*
        [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            _openRightMenu = NO;
        }];Z
         */
    }
}
- (void)GKLogin
{
    _openLeftMenu = YES;
    [self refresh];
}
- (void)GKLogout
{
    [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
        _openLeftMenu = YES;
    }];
    [self refresh];
}
- (void)setOpenRight
{
    _openRightMenu = YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self refresh];
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
