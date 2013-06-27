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
#import "TMLEntity.h"
#import "MMMTML.h"
#import "GKNotePostViewController.h"
#import "MMMCalendar.h"
#import "TMLCell.h"
#import "GKDetailViewController.h"
#import "GKEDCSettingViewController.h"
@interface GKCenterViewController ()

@end

@implementation GKCenterViewController
{
@private
    NSMutableArray * _dataArray;
    SMPageControl * pageControl;
    UIView *HeaderView;
    NSIndexPath *indexPathTmp;
    BOOL headerChange;
    float y;
    GKUser *user;
}

@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        indexPathTmp = [[NSIndexPath alloc]initWithIndex:0];
        NSLog(@"%d",indexPathTmp.section);
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        self.navigationItem.titleView = [GKTitleView  setTitleLabel:@"我的"];
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
        
    //数据
    TMLStage *stage1 = [[TMLStage alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"备孕",@"name",@"NO",@"on", nil]];
    TMLStage *stage2 = [[TMLStage alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"孕早期",@"name",@"YES",@"on", nil]];
    TMLStage *stage3 = [[TMLStage alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"孕中期",@"name",@"NO",@"on", nil]];
    
    TMLCate *cate1 = [[TMLCate alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"清洁",@"gtt",@"1",@"gid",nil]];
    TMLCate *cate2 = [[TMLCate alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"饮食",@"gtt",@"2",@"gid",nil]];
    
    TMLKeyWord *keyword1 = [[TMLKeyWord alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"婴儿摇篮",@"ctt",@"121",@"cid",@"NO",@"open",@"YES",@"necessary",@"10",@"count",nil]];
    TMLKeyWord *keyword2 = [[TMLKeyWord alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"备纸尿布",@"ctt",@"122",@"cid",@"NO",@"open",@"NO",@"necessary",@"100",@"count",nil]];
    TMLKeyWord *keyword3 = [[TMLKeyWord alloc]initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"湿疹防护",@"ctt",@"123",@"cid",@"NO",@"open",@"NO",@"necessary",@"100",@"count",nil]];
    
    NSMutableDictionary * argsDict = [NSMutableDictionary dictionaryWithCapacity:13];
    [argsDict setValue:[NSString stringWithFormat:@"%u", 83099] forKey:@"entity_id"];
    [argsDict setValue:@"18045653654" forKey:@"taobao_id"];
    [argsDict setValue:@"4300bb1e" forKey:@"entity_hash"];
    [argsDict setValue:@"home by ASA - 厨房陶瓷收纳罐" forKey:@"title"];
    [argsDict setValue:@"http://www.guoku.com/visit_item?item_id=18045653654&amp;outer_code=GWB18746" forKey:@"url"];
    [argsDict setValue:@"http://img01.taobaocdn.com/imgextra/i1/920964035/T2iuWMXk0bXXXXXXXX_!!920964035.jpg_310x310.jpg" forKey:@"image_url"];
    [argsDict setValue:@"home" forKey:@"brand"];
    [argsDict setValue:@"1" forKey:@"stuff_status"];
    [argsDict setValue:[NSString stringWithFormat:@"%.2f", 123.00] forKey:@"price"];
    [argsDict setValue:[NSString stringWithFormat:@"%u", 1] forKey:@"category_id"];
    [argsDict setValue:[NSString stringWithFormat:@"%u", 212] forKey:@"liked_count"];
    [argsDict setValue:@"2012-12-13 12:30" forKey:@"created_time"];
    [argsDict setValue:[NSNumber numberWithInteger:1] forKey:@"popularity"];
    GKEntity *entity = [[GKEntity alloc]initWithAttributes:argsDict];
    
    NSDictionary *one = [NSDictionary dictionaryWithObjectsAndKeys:cate1,@"section",[NSArray arrayWithObjects:keyword1,keyword2,keyword3,entity,entity,keyword1,entity,entity,entity,nil],@"row",nil];
    NSDictionary *two = [NSDictionary dictionaryWithObjectsAndKeys:cate2,@"section",[NSArray arrayWithObjects:keyword1,keyword2,keyword3,entity,entity,keyword1,entity,entity,entity,nil],@"row",nil];
       
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:one];
    [_dataArray addObject:two];

    
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor = kColorf9f9f9;
    _table.backgroundColor = kColorf9f9f9;

    _table.allowsSelection = NO;
    [_table setDelegate:self];
    [_table setDataSource:self];

    [self setTableHeaderView];
    //[self setTableFooterView];
    [self.view addSubview:_table];
    
    y = self.table.contentOffset.y;
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    icon.backgroundColor = [UIColor clearColor];
    icon.image = [UIImage imageNamed:@"timeline_dot_done.png"];
    [self.view addSubview:icon];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0,40, 10)];
    view.backgroundColor = kColorebe7e4;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,10)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor = kColore2ddd9;
    [view addSubview:line];
    
    [self.view addSubview:view];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //[self showDetailWithEntityID:75635];
    //[self showNotePostView];
    //[self showEDCSettingView];
   
}
-(void)viewDidDisappear:(BOOL)animated
{
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}
- (void)reload:(id)sender
{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                height = 48;
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
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TMLCate * stage = [[_dataArray objectAtIndex:section]objectForKey:@"section"];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = kColorebe7e4;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,40)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor = kColore2ddd9;
    [view addSubview:line];
    
    UIImageView * labelbg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0,kScreenWidth-30,40)];
    labelbg.image = [UIImage imageNamed:@"categorybar.png"];
    [view addSubview:labelbg];
    
    UIButton * label = [[UIButton alloc]initWithFrame:CGRectMake(40, 0,kScreenWidth-30,40)];
    [label.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [label setTitleColor:kColor555555 forState:UIControlStateNormal];
    label.backgroundColor = [UIColor clearColor];
    [label.titleLabel setTextAlignment:UITextAlignmentLeft];
    label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [label setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    label.userInteractionEnabled = NO;
    NSLog(@"%@",stage.name);
    [label setTitle:stage.name forState:UIControlStateNormal];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 14, 14)];
    image.center = CGPointMake(20, image.center.y);
    if(0)
    {
        image.image =[UIImage imageNamed:@"timeline_dot_done.png"];
    }
    else
    {
        image.image = [UIImage imageNamed:@"timeline_dot.png"];
    }
    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(35,16, 5, 8)];
    arrow.image = [UIImage imageNamed:@"timeline_arrow.png"];
    
    [view addSubview:label];
    [view addSubview:image];
    [view addSubview:arrow];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y <0)
    {
      //  scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x,0);
    }
	NSIndexPath * tmp = [_table indexPathForRowAtPoint:CGPointMake(160,scrollView.contentOffset.y)];
    if(tmp.section != indexPathTmp.section)
    {
    //    [self sectionChange:indexPathTmp and:tmp];
    }
    indexPathTmp = tmp;

}

- (void)setTableHeaderView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    view.backgroundColor = kColorebe7e4;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,view.frame.size.height)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor = kColore2ddd9;
    [view addSubview:line];
    
    UIView * colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectMake(40,0,view.frame.size.width-40,view.frame.size.height)];
    colorf9f9f9.backgroundColor = kColorf9f9f9;
    [view addSubview:colorf9f9f9];
    
    [_table addSubview:view];
}
- (void)setTableFooterView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0,self.view.frame.size.width, self.view.bounds.size.height)];
    view.backgroundColor = kColorebe7e4;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2,view.frame.size.height)];
    line.center = CGPointMake(20, line.center.y);
    line.backgroundColor = kColore2ddd9;
    [view addSubview:line];
    
    UIView * colorf9f9f9 = [[UIView alloc]initWithFrame:CGRectMake(40,0,view.frame.size.width-40,view.frame.size.height)];
    colorf9f9f9.backgroundColor = kColorf9f9f9;
    [view addSubview:colorf9f9f9];
   [_table addSubview:view];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    GKLog(@"offset:%f",scrollView.contentOffset.y);
    GKLog(@"height:%f",scrollView.contentSize.height);
}
- (void)sectionChange:(NSIndexPath *)indexPath1 and:(NSIndexPath *)indexPath2
{
    [[HeaderView viewWithTag:1]removeFromSuperview];
    UIView * view = [[UIView alloc]init];
  
    if(indexPath1.section < indexPath2.section)
    {
        view = [self tableView:_table viewForHeaderInSection:indexPath1.section];
        view.frame = CGRectMake(HeaderView.frame.origin.x, HeaderView.frame.origin.y+HeaderView.frame.size.height-30, kScreenWidth, 30);
        view.tag = 1;
        view.alpha = 0;
        [HeaderView addSubview: view];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        view.alpha=0.8;
        [UIView commitAnimations];
    }
    else
    {
        if(indexPath1.section >= 2)
        {
            view = [self tableView:_table viewForHeaderInSection:indexPath1.section-2];
            view.frame = CGRectMake(HeaderView.frame.origin.x, HeaderView.frame.origin.y+HeaderView.frame.size.height-30, kScreenWidth, 30);
            view.tag = 1;
            view.alpha = 0;
            [HeaderView addSubview: view];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            view.alpha=0.8;
            [UIView commitAnimations];
    
        }
    }


}
- (void)showNotePostView
{
    if (![kUserDefault stringForKey:kSession])
    {
        [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
    }
    else {
        GKNotePostViewController *notePostVC = [[GKNotePostViewController alloc]init];
        notePostVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notePostVC animated:YES];
    }
}
- (void)showEDCSettingView
{
    if (![kUserDefault stringForKey:kSession])
    {
        [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
    }
    else {
        GKEDCSettingViewController *notePostVC = [[GKEDCSettingViewController alloc]init];
        notePostVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notePostVC animated:YES];
    }
}
- (void)showLeftMenu
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"navigation_bar_button_enable"]) {
        [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
    }
    else
    {
        [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:NULL];
    }

}
- (void)showRightMenu
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"navigation_bar_button_enable"]) {
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:NULL];
    }
    else
    {
        [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:NULL];
    }
}
@end
