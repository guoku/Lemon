//
//  GKLeftViewController.m
//  MMM
//
//  Created by huiter on 13-6-11.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKLeftViewController.h"

@interface GKLeftViewController ()

@end
@implementation GKLeftViewController
{
@private
    NSMutableDictionary *dictionary;
}
@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"1.png"]];

    
    
    //个人信息
    UIView *UserInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    //头像
    UIButton *avatar = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [avatar setImage:[UIImage imageNamed:@"Icon.png"] forState:UIControlStateNormal];
    [UserInfo addSubview:avatar];
    [avatar addTarget:self action:@selector(buttonclick) forControlEvents:UIControlEventTouchUpInside];
    //昵称
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 100, 50)];
    name.font = [UIFont boldSystemFontOfSize:16.0f];
    name.textColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    name.backgroundColor = [UIColor clearColor];
    [name setText: @"huiter"];
    [UserInfo addSubview:name];
    //设置button
    UIButton *setting =[[UIButton alloc] initWithFrame:CGRectMake(200, 10, 50, 50)];
    [setting setImage:[UIImage imageNamed:@"tabbar_icon_setting.png"] forState:UIControlStateNormal];
    [UserInfo addSubview:setting];
    
    //菜单列表
    NSDictionary *one = [NSDictionary dictionaryWithObjectsAndKeys:@"icon-star.png",@"icon",@"我喜爱的(635)",@"text",nil];
    NSDictionary *two = [NSDictionary dictionaryWithObjectsAndKeys:@"icon-star.png",@"icon",@"我添加的(54)",@"text",nil];
    NSDictionary *three = [NSDictionary dictionaryWithObjectsAndKeys:@"icon-star.png",@"icon",@"我关注的清单(4)",@"text",nil];
    NSDictionary *four = [NSDictionary dictionaryWithObjectsAndKeys:@"icon-star.png",@"icon",@"我关注的人",@"text",nil];
    dictionary = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dictionary setObject:[[NSArray alloc] initWithObjects:one,two,three,four,nil] forKey:@(0)];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _table.backgroundColor = kColorf9f9f9;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor = kColorf9f9f9;
    _table.allowsSelection = NO;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dictionary objectForKey:@(section)]count];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    switch (section) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:[[[dictionary objectForKey:@(section)] objectAtIndex:row] objectForKey:@"icon"]];
            cell.textLabel.text = [[[dictionary objectForKey:@(section)] objectAtIndex:row] objectForKey:@"text"];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            cell.textLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            cell = nil;
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shouldrestoreViewLocation" object:nil];
    NSInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                {
                    //[self performSelector:@selector() withObject:nil afterDelay:0.3];
                }
                    break;
                case 1:
                {
                    //[self performSelector:@selector() withObject:nil afterDelay:0.3];
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

@end
