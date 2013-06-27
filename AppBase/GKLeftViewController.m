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
    NSMutableArray * _dataArray;
    NSMutableDictionary *dictionary;
    UIView *tableHeaderView;
    GKUser *user;
}
@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        self.view.backgroundColor= UIColorFromRGB(363131);


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    _dataArray = [[NSMutableArray alloc]init];
    NSDictionary *one = [NSDictionary dictionaryWithObjectsAndKeys:@"icon-star.png",@"icon",@"备孕",@"text",nil];

    
    user =[[GKUser alloc ]initFromSQLite];
    
    GKUserButton * avatar = [[GKUserButton alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
    avatar.center = CGPointMake(80, 40);
    avatar.user = user;
    [tableHeaderView addSubview:avatar];
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(120, 15, kScreenWidth-150, 25)];
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentLeft;
    [name setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
    name.textColor = [UIColor blackColor];
    name.text = user.nickname;
    [tableHeaderView addSubview:name];
    
    UILabel * description = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, kScreenWidth-100, 15)];
    description.backgroundColor = [UIColor clearColor];
    description.textAlignment = NSTextAlignmentLeft;
    [description setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
    description.textColor = kColor555555;
    description.text = @"宝宝3个月零5天，预计要花费￥22,727";
    [tableHeaderView addSubview:description];

    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _table.backgroundColor = kColorf9f9f9;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor = kColorf9f9f9;
    _table.allowsSelection = NO;
    _table.tableHeaderView = tableHeaderView;
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
    
            UIButton *label = [[UIButton alloc]initWithFrame:CGRectZero];
            [label setImage:[UIImage imageNamed:@"icon_clock"] forState:UIControlStateNormal];
            [label.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0f]];
            [label setTitleColor:kColor666666 forState:UIControlStateNormal];
            [label.titleLabel setTextAlignment:UITextAlignmentLeft];
            [label setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
            label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            label.userInteractionEnabled = NO;
            [label setTitle:@"孕早期" forState:UIControlStateNormal];
            [cell addSubview:label];
    
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

@end
