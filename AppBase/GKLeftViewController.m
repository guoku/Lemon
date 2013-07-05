//
//  GKLeftViewController.m
//  MMM
//
//  Created by huiter on 13-6-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKLeftViewController.h"
#import "MMMCalendar.h"
#import "MMMLeftCell.h"
#import "UIViewController+MMDrawerController.h"
#import "GKLoginViewController.h"
#import "GKAppDelegate.h"

@interface GKLeftViewController ()

@end
@implementation GKLeftViewController
{
@private
    NSMutableArray * _dataArray;
    NSMutableDictionary *dictionary;
    UIView *tableHeaderView;
    UIView *tipView;
    UIView *tableFooterView;
    UIButton * message;
    UIButton * setting;
    GKUser *user;
}
@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        self.view.backgroundColor= UIColorFromRGB(0x403b3b);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    _dataArray = [[NSMutableArray alloc]init];

         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileChange) name:@"UserProfileChange" object:nil];
    _dataArray = [NSMutableArray arrayWithObjects:
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"准备怀孕",@"name",@"NO",@"open",@"YES",@"necessary",@"10",@"count",@"1",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"孕早期",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"2",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"孕中期",@"name",@"NO",@"open",@"YES",@"necessary",@"20",@"count",@"3",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"孕晚期",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"4",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"待产准备",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"5",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"初生",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"6",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0-3个月",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"7",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3-6个月",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"8",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6-12个月",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"9",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1-2岁",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"10",@"pid",nil],
                  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2-3岁",@"name",@"NO",@"open",@"YES",@"necessary",@"0",@"count",@"11",@"pid",nil]
                  , nil];
    
    NSUInteger i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userstage"]integerValue];
    for (NSMutableDictionary *dic in _dataArray) {
        
        if([[dic objectForKey:@"pid"] intValue]<i)
        {
            [dic setObject:@"NO" forKey:@"open"];
        }
        else
        {
            [dic setObject:@"YES" forKey:@"open"];
        }
        
    }
    user =[[GKUser alloc ]initFromSQLite];
    
    tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 120)];
    tableHeaderView.backgroundColor = UIColorFromRGB(0x403B3B);
    
    GKUserButton * avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
    avatar.center = CGPointMake(40, 40);
    avatar.user = user;
    [tableHeaderView addSubview:avatar];
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, tableHeaderView.frame.size.width-100, 20)];
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentLeft;
    [name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0f]];
    name.textColor = UIColorFromRGB(0xFFFFFF);
    name.text = user.nickname;
    [tableHeaderView addSubview:name];
    
    UILabel * description = [[UILabel alloc]initWithFrame:CGRectMake(80, 35, tableHeaderView.frame.size.width-100,30)];
    description.backgroundColor = [UIColor clearColor];
    description.numberOfLines = 0;
    description.textAlignment = NSTextAlignmentLeft;
    [description setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    description.textColor = UIColorFromRGB(0x999999);
    description.text = user.bio;
    [tableHeaderView addSubview:description];
    
    tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 260, 40)];
    tipView.backgroundColor = UIColorFromRGB(0x363131);
    
    UIImageView *H1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,tipView.frame.size.width, 2)];
    [H1 setImage:[UIImage imageNamed:@"sidebar_shadow.png"]];
    [tipView addSubview:H1];
    
    MMMCalendar * calendar = [[MMMCalendar alloc]initWithFrame:CGRectMake(0, 0, 30, 30) kind:0];
    calendar.center = CGPointMake(20, 20);
    calendar.date = [NSDate dateFromString:@"2013-11-23" WithFormatter:@"yyyy-MM-dd"];
    [tipView addSubview:calendar];
    
    UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(40,0,tipView.frame.size.width-100,40)];
    tip.center = CGPointMake(tip.center.x, tipView.frame.size.height/2);
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentLeft;
    [tip setFont:[UIFont fontWithName:@"Helvetica" size:9.0f]];
    tip.textColor = UIColorFromRGB(0x777777);
    tip.text = @"宝宝现在3个月零5天，预计要花费￥22,727";
    [tipView addSubview:tip];
    
    UIImageView *_seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, tipView.frame.size.width, 2)];
    [_seperatorLineImageView setImage:[UIImage imageNamed:@"sidebar_shadow_down@2x.png"]];
    [tipView addSubview:_seperatorLineImageView];
    
    [tableHeaderView addSubview:tipView];
    [self.view addSubview:tableHeaderView];
    
    tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 260, 44)];
    tableFooterView.backgroundColor = UIColorFromRGB(0x403B3B);
    
    message = [[UIButton alloc]initWithFrame:CGRectMake(0, 0 , 116 , 34)];
    message.center = CGPointMake(65, 23);
    [message setBackgroundImage:[[UIImage imageNamed:@"sidebar_button.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [message setBackgroundImage:[[UIImage imageNamed:@"sidebar_button_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] forState:UIControlStateHighlighted];
    [message setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [message setTitle:@"消息" forState:UIControlStateNormal];
    [message.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    [message.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tableFooterView addSubview:message];

    
    setting = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 116, 34)];
    setting.center = CGPointMake(190, 23);
    [setting setBackgroundImage:[[UIImage imageNamed:@"sidebar_button.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [setting setBackgroundImage:[[UIImage imageNamed:@"sidebar_button_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] forState:UIControlStateHighlighted];
    [setting setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [setting setTitle:@"设置" forState:UIControlStateNormal];
    [setting.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    [setting addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [setting.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tableFooterView addSubview:setting];
    
    UIImageView *H2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 2)];
    [H2 setImage:[UIImage imageNamed:@"sidebar_divider.png"]];
    
    [tableFooterView addSubview:H2];
    
    [self.view addSubview:tableFooterView];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, tableHeaderView.frame.origin.y+tableHeaderView.frame.size.height, 260, kScreenHeight-(tableHeaderView.frame.origin.y+tableHeaderView.frame.size.height)-(tableFooterView.frame.size.height)) style:UITableViewStylePlain];
    
    _table.backgroundColor = UIColorFromRGB(0x403B3B);
    _table.separatorStyle =  UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = YES;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    NSUInteger stage =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"stage"]]integerValue];
    [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:stage-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:@"navigation_bar_button_enable"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"navigation_bar_button_enable"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    MMMLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[MMMLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier];
    }
    cell.backgroundColor = UIColorFromRGB(0x403B3B);
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    //UIImageView * selectedBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    //selectedBackgroundView.image = [[UIImage imageNamed:@"bg363131.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10 ];
    //cell.selectedBackgroundView = selectedBackgroundView;
    
    NSUInteger row = [indexPath row];
    //NSUInteger section = [indexPath section];
    
    NSDictionary *data = [_dataArray objectAtIndex:row];
    cell.data = data;
    
    [[cell viewWithTag:4003]removeFromSuperview];
    [[cell viewWithTag:4004]removeFromSuperview];
    
    if(row != 0)
    {
        UIImageView *_seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 2)];
        _seperatorLineImageView.tag = 4003;
        [_seperatorLineImageView setImage:[UIImage imageNamed:@"sidebar_divider.png"]];
        [cell addSubview:_seperatorLineImageView];
    }
    if(row == ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userstage"]integerValue]-1))
    {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 14)];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        CGSize size = [[data objectForKey:@"name"] sizeWithFont:font constrainedToSize:CGSizeMake(260, 44) lineBreakMode:NSLineBreakByWordWrapping];
        image.center = CGPointMake(50+size.width, cell.frame.size.height/2);
        image.image = [UIImage imageNamed:@"sidebar_dot@2x.png"];
        image.tag = 4004;
    
        [cell addSubview:image];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row+1) forKey:@"stage"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stageChange" object:nil userInfo:nil];
    [self performSelector:@selector(work) withObject:self afterDelay:0.25];

    NSInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
            
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
}
- (void)work
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}
- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSession];
    GKLoginViewController *loginVC = [[GKLoginViewController alloc] init];
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController: loginVC animated:YES completion:NULL];
}
- (void)profileChange
{

    NSUInteger i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userstage"]integerValue];
    for (NSMutableDictionary *dic in _dataArray) {
        
        if([[dic objectForKey:@"pid"] intValue]<i)
        {
            [dic setObject:@"NO" forKey:@"open"];
        }
        else
        {
            [dic setObject:@"YES" forKey:@"open"];
        }
        
    }
    [self.table reloadData];
    NSUInteger stage =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"stage"]]integerValue];
    [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:stage-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

@end
