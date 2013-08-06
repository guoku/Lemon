//
//  TMLKeywordViewController.m
//  MMM
//
//  Created by huiter on 13-6-21.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "NewTMLKeywordViewController.h"
#import "GKPopular.h"
#import "GKAppDelegate.h"
#import "TableViewCellForTwo.h"
#import "MMMKWD.h"
#import "MMMFriendSelectViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "TMLCate.h"
@interface NewTMLKeywordViewController ()

@end

@implementation NewTMLKeywordViewController
{
@private
    NSMutableArray * _dataArray;
    
    UIActivityIndicatorView *indicator;
    BOOL _canLoadMore;
    BOOL _loadMoreflag;
    UIImageView *cate_arrow;
    NSUInteger _pid;
    NSUInteger _cid;
    NSUInteger _gid;
    NSUInteger _page;
    NSString *group;
    UIActivityIndicatorView *loading;
    UIButton *button;
    UIButton *button2;
    UIButton *button3;
    UIImageView *button3_arrow;
    UIView * menu;
    UIView * menu2;
    UIButton * mask;
    UIScrollView * cSV;
    UIScrollView * gSV;
    UIButton * Sortbutton; 
    UIButton * Sortbutton2;
    UIView *bg;
    NSMutableArray * _titleArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        _pid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"stage"] intValue];
        _cid = 0;
        _gid = 0;
        _page = 0;
        group = @"new";
        _canLoadMore = NO;
        [self setFooterView:NO];
        _titleArray = [NSMutableArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"准备怀孕",@"name",@"0",@"count",@"1",@"pid",nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"怀孕中",@"name",@"0",@"count",@"2",@"pid",nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"生啦",@"name",@"0",@"count",@"3",@"pid",nil],
                      nil];
        
        self.navigationItem.titleView = [GKTitleView setTitleLabel:[[_titleArray objectAtIndex:_pid -1] objectForKey:@"name"]];
        
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
        
        mask = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth,kScreenHeight)];
        [mask addTarget:self action:@selector(hideAll) forControlEvents:UIControlEventTouchUpInside];
        mask.hidden = YES;
        mask.backgroundColor = [UIColor blackColor];
        mask.alpha = 0.5;
        [self.view addSubview:mask];
        
        menu = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 308)];
        menu.hidden = YES;
        menu.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.view addSubview:menu];
        //UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 310)];
        //bg.image = [[UIImage imageNamed:@"category_bg.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        //[menu addSubview:bg];
        
        gSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0 , 130, 308)];
        gSV.backgroundColor = [UIColor whiteColor];
        gSV.showsVerticalScrollIndicator = NO;

        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table3"];
        NSMutableArray * pArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data]objectForKey:@(_pid)];
        UIButton * Cbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 130, 43)];
        Cbutton.backgroundColor = [UIColor whiteColor];
        
        
        //[Cbutton setBackgroundImage:[UIImage imageNamed:@"tables_middle.png"] forState:UIControlStateNormal];
        [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2] forState:UIControlStateNormal|UIControlStateHighlighted];
        [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateHighlighted|UIControlStateSelected];
        [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateSelected];
        
        [Cbutton setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [Cbutton setTitle:@"全部" forState:UIControlStateNormal];
        [Cbutton addTarget:self action:@selector(changeCateAction:) forControlEvents:UIControlEventTouchUpInside];
        [Cbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        Cbutton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [Cbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        Cbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        Cbutton.selected = YES;
        Cbutton.tag = 0;
        [gSV addSubview:Cbutton];
        
        int i =1;

        for (NSDictionary * dic in pArray) {
            TMLCate * cate= [dic objectForKey:@"section"];
            UIButton * Cbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, i*44, 130, 44)];
            Cbutton.backgroundColor = [UIColor whiteColor];
            
            
            //[Cbutton setBackgroundImage:[UIImage imageNamed:@"tables_middle.png"] forState:UIControlStateNormal];
            [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2] forState:UIControlStateNormal|UIControlStateHighlighted];
            [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateHighlighted|UIControlStateSelected];
            [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateSelected];
            
            [Cbutton setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
            Cbutton.tag = [pArray indexOfObject:dic]+1;
            [Cbutton setTitle:cate.name forState:UIControlStateNormal];
            [Cbutton addTarget:self action:@selector(changeCateAction:) forControlEvents:UIControlEventTouchUpInside];
            [Cbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            Cbutton.titleLabel.textAlignment = NSTextAlignmentLeft;
            [Cbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            Cbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [gSV addSubview:Cbutton];
            
            UIView * H = [[UIView alloc]initWithFrame:CGRectMake(0, i*44-1, 130, 1)];
            H.tag = 18746;
            H.backgroundColor = UIColorFromRGB(0xededed);
            [gSV addSubview:H];
            
            i++;
        }
        if(i*44>308)
        {
            gSV.contentSize = CGSizeMake(130, i*44);
        }
        else
        {
            gSV.contentSize = CGSizeMake(130, 308);
        }
        [menu addSubview:gSV];
        
        cSV = [[UIScrollView alloc]initWithFrame:CGRectMake(130,0 , 220,308)];
        cSV.backgroundColor = UIColorFromRGB(0xf3f3f3);
        cSV.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [menu addSubview:cSV];
        
        menu2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 87)];
        menu2.hidden = YES;
        menu2.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.view addSubview:menu2];
        
        Sortbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0*44, kScreenWidth, 44)];
        Sortbutton.backgroundColor = [UIColor whiteColor];
        
        [Sortbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2] forState:UIControlStateNormal|UIControlStateHighlighted];
        [Sortbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateHighlighted|UIControlStateSelected];
        [Sortbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateSelected];
        
        [Sortbutton setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        Sortbutton.tag = 1;
        [Sortbutton setTitle:@"按上架时间" forState:UIControlStateNormal];
        [Sortbutton addTarget:self action:@selector(changeSortAction:) forControlEvents:UIControlEventTouchUpInside];
        [Sortbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        Sortbutton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [Sortbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        Sortbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        Sortbutton.selected = YES;
        [menu2 addSubview:Sortbutton];
        
        Sortbutton2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 1*44, kScreenWidth, 44)];
        Sortbutton2.backgroundColor = [UIColor whiteColor];
        
        [Sortbutton2 setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2] forState:UIControlStateNormal|UIControlStateHighlighted];
        [Sortbutton2 setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateHighlighted|UIControlStateSelected];
        [Sortbutton2 setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateSelected];
        
        [Sortbutton2 setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        Sortbutton2.tag = 2;
        [Sortbutton2 setTitle:@"按评价排列" forState:UIControlStateNormal];
        [Sortbutton2 addTarget:self action:@selector(changeSortAction:) forControlEvents:UIControlEventTouchUpInside];
        [Sortbutton2.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        Sortbutton2.titleLabel.textAlignment = NSTextAlignmentLeft;
        [Sortbutton2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        Sortbutton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [menu2 addSubview:Sortbutton2];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
        view.backgroundColor = [UIColor clearColor];
        
        bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        bg.backgroundColor =[UIColor clearColor];
    
        button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 42)];
        [button setImage:[UIImage imageNamed:@"category_icon_category.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"category_icon_category_red.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"category_icon_category_red.png"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"category_icon_category_red.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setBackgroundImage:[[UIImage imageNamed:@"category_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]  forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"category_bg_press.png"]  stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateNormal|UIControlStateHighlighted];
        [button setBackgroundImage:[[UIImage imageNamed:@"category_bg_press.png"]  stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setBackgroundImage:[[UIImage imageNamed:@"category_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]  forState:UIControlStateSelected];
        [button addTarget:self action:@selector(changeArrowPress:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(changeArrowNormal:) forControlEvents:UIControlEventTouchDragOutside];
        [button addTarget:self action:@selector(changeArrowPress:) forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self action:@selector(changeArrowNormal:) forControlEvents:UIControlEventTouchUpOutside];
        
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [button setTitle:@"全部" forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-2, 10, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [button addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 4001;
        
        button2 = [[UIButton alloc]initWithFrame:CGRectMake(90, 0, 90, 42)];
        
        [button2 setImage:[UIImage imageNamed:@"category_icon_new.png"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
        [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateSelected];
        [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [button2 setBackgroundImage:[[UIImage imageNamed:@"category_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]  forState:UIControlStateNormal];
        [button2 setBackgroundImage:[[UIImage imageNamed:@"category_bg_press.png"]  stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateNormal|UIControlStateHighlighted];
        [button2 setBackgroundImage:[[UIImage imageNamed:@"category_bg_press.png"]  stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateSelected|UIControlStateHighlighted];
        [button2 setBackgroundImage:[[UIImage imageNamed:@"category_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]  forState:UIControlStateSelected];
        [button2.titleLabel setTextAlignment:NSTextAlignmentLeft];
        button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button2 setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [button2 setTitle:@"新上架" forState:UIControlStateNormal];
        [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [button2 addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(changeArrowPress:) forControlEvents:UIControlEventTouchDown];
        [button2 addTarget:self action:@selector(changeArrowNormal:) forControlEvents:UIControlEventTouchDragOutside];
        [button2 addTarget:self action:@selector(changeArrowPress:) forControlEvents:UIControlEventTouchDragInside];
        [button2 addTarget:self action:@selector(changeArrowNormal:) forControlEvents:UIControlEventTouchUpOutside];
        button2.tag = 4002;
        
        button3 = [[UIButton alloc]initWithFrame:CGRectMake(180, 0, 140, 42)];
        [button3 setImage:[UIImage imageNamed:@"category_icon_friends.png"] forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"category_icon_friends_red.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
        [button3 setImage:[UIImage imageNamed:@"category_icon_friends_red.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [button3 setImage:[UIImage imageNamed:@"category_icon_friends_red.png"] forState:UIControlStateSelected];
        [button3 setBackgroundImage:[[UIImage imageNamed:@"category_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]  forState:UIControlStateNormal];
        [button3 setBackgroundImage:[[UIImage imageNamed:@"category_bg_press.png"]  stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateNormal|UIControlStateHighlighted];
        [button3 setBackgroundImage:[[UIImage imageNamed:@"category_bg_press.png"]  stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateSelected|UIControlStateHighlighted];
        [button3 setBackgroundImage:[[UIImage imageNamed:@"category_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]  forState:UIControlStateSelected];
        [button3.titleLabel setTextAlignment:NSTextAlignmentLeft];
        button3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button3.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [button3 setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [button3 setTitle:@"好友的精选" forState:UIControlStateNormal];
        [button3 setImageEdgeInsets:UIEdgeInsetsMake(-2, -10, 0, 0)];
        [button3 setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [button3 addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button3 addTarget:self action:@selector(changeArrowPress:) forControlEvents:UIControlEventTouchDown];
        [button3 addTarget:self action:@selector(changeArrowNormal:) forControlEvents:UIControlEventTouchDragOutside];
        [button3 addTarget:self action:@selector(changeArrowPress:) forControlEvents:UIControlEventTouchDragInside];
        [button3 addTarget:self action:@selector(changeArrowNormal:) forControlEvents:UIControlEventTouchUpOutside];
        button3.tag = 4003;
        
        button3_arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        button3_arrow.frame = CGRectMake(300, 13, 8, 14);
        [bg addSubview:button];
        [bg addSubview:button2];
        [bg addSubview:button3];
        [bg addSubview:button3_arrow];
        
        UIView *V1 = [[UIView alloc]initWithFrame:CGRectMake(90, 0, 1, 39)];
        V1.backgroundColor =UIColorFromRGB(0xe4e4e4);
        UIView *V2 = [[UIView alloc]initWithFrame:CGRectMake(180, 0, 1, 39)];
        V2.backgroundColor =UIColorFromRGB(0xe4e4e4);
        //UIView *H1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
        //H1.backgroundColor =UIColorFromRGB(0xe4e4e4);
        
        //UIImageView *V1 = [[UIImageView alloc]initWithFrame:CGRectMake(90, 0, 2, 39)];
        //V1.image = [UIImage imageNamed:@"category_divider.png"];
        //UIImageView *V2 = [[UIImageView alloc]initWithFrame:CGRectMake(180, 0, 2, 39)];
        //V2.image = [UIImage imageNamed:@"category_divider.png"];
        //[bg addSubview:H1];
        [bg addSubview:V1];
        [bg addSubview:V2];
        
        cate_arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"category_arrow.png"]];
        cate_arrow.frame = CGRectMake(0,39, 15,10);
        cate_arrow.center = CGPointMake(45, cate_arrow.center.y);
        cate_arrow.backgroundColor = [UIColor clearColor];
        
        [view addSubview:bg];
        //[view addSubview:cate_arrow];
        
        
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44) style:UITableViewStylePlain];
        _table.backgroundColor =UIColorFromRGB(0xf9f9f9);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.separatorColor =UIColorFromRGB(0xf9f9f9);
        _table.allowsSelection = NO;
        _table.showsVerticalScrollIndicator = NO;
        [_table setDelegate:self];
        [_table setDataSource:self];
        [self.view  insertSubview:_table belowSubview:mask];
        
        /*
         if(_refreshHeaderView == nil)
         {
         EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
         view.delegate = self;
         _refreshHeaderView = view;
         [self.table addSubview:_refreshHeaderView];
         }
         [_refreshHeaderView refreshLastUpdatedDate];
         */
        UIView * tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        tableHeaderView.backgroundColor = UIColorFromRGB(0xf9f9f9);
        self.table.tableHeaderView = tableHeaderView;
        
        [self.view addSubview:view];
        
        UIView * fixBUG =[[UIView alloc] initWithFrame:CGRectMake(0, -100, kScreenWidth, 100)];
        fixBUG.backgroundColor = [UIColor blackColor];
        [self.view addSubview:fixBUG];
        
        
        loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loading.frame = CGRectMake(0, 0, 44, 44);
        //loading.backgroundColor = UIColorFromRGB(0xf9f9f9);
        loading.backgroundColor = [UIColor blackColor];
        loading.layer.cornerRadius = 4.0;
        loading.center = CGPointMake(kScreenWidth/2, 150);
        loading.hidesWhenStopped = YES;
        [self.view addSubview:loading];

        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GKLogin) name: GKUserLoginNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOpenRight) name: @"OpenRightMenu"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GKLogout) name: GKUserLogoutNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProfileChange) name:@"UserProfileChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stageChange) name:@"stageChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:kGKN_EntityLikeChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:kGKN_EntityChange object:nil];
    
    [self setFooterView:NO];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGKN_EntityLikeChange object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    button3_arrow.image = [UIImage imageNamed:@"arrow.png"];
    if([_dataArray count]==0)
    {
        [self refresh];
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
- (void)reload:(id)sender
{
    [loading startAnimating];

    [MMMKWD globalNewKWDWithGroup:group Pid:_pid Gid:_gid Cid:_cid Page:1 Block:^(NSArray *array, NSError *error) {
        if(!error)
        {
            _dataArray = [NSMutableArray arrayWithArray:array];
         
            if([array count] == 60 )
            {
                 [self setFooterView:YES];
            }
            else
            {
                 [self setFooterView:NO];
            }
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
        [self doneLoadingTableViewData];
 
    }];
}

- (void)loadView
{
    [super loadView];
   
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
       return ceil([_dataArray count]/2.0f);
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
    NSMutableArray * a = _dataArray;
    if([a count] > indexPath.row * 2 + 1)
    {
        cell.dataArray = nil;
        cell.dataArray = [NSMutableArray arrayWithObjects:[a objectAtIndex:(indexPath.row * 2)], [a objectAtIndex:(indexPath.row * 2 + 1)],nil];
    }
    else
    {
        cell.dataArray = nil;
        cell.dataArray = [NSMutableArray arrayWithObjects:[a objectAtIndex:(indexPath.row * 2)],nil];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}
- (void)refresh
{
    _page = 1;
    [_dataArray removeAllObjects];
    [self.table reloadData];
    button.selected = NO;
    button2.selected = NO;
    [loading startAnimating];

    _reloading = YES;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    self.table.tableFooterView.hidden = YES;
  
   // [self makeHearderReloading];
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
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    self.table.tableFooterView.hidden = YES;
    [self reload:nil];
    
}
- (void)doneLoadingTableViewData{
    _reloading = NO;
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    self.table.tableFooterView.hidden = NO;
    CGPoint offset = self.table.contentOffset;
    offset.y = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentOffset = offset;
    }completion:^(BOOL finished) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
               [loading stopAnimating];
    }];
}
- (void)AllReset{
    _reloading = NO;
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    self.table.tableFooterView.hidden = NO;
    CGPoint offset = self.table.contentOffset;
    offset.y = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentOffset = offset;
    }completion:^(BOOL finished) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    }];
}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	//[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	//[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if (scrollView.contentOffset.y+scrollView.frame.size.height >= scrollView.contentSize.height) {
        if((!_loadMoreflag)&&_canLoadMore)
        {
            _loadMoreflag = YES;
            [self loadMore];
        }
	}
}
#pragma mark -
#pragma mark 重载EGORefreshTableHeaderView必选方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
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

    switch (((UIButton *)sender).tag) {
        case 4001:
        {
    
            if(menu.hidden)
            {
            menu.hidden = YES;
            menu2.hidden = YES;
            button.selected = NO;
            button2.selected = NO;
            
            menu.hidden = NO;
            button.selected = YES;
            mask.hidden = NO;
            bg.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                menu.hidden = YES;
                menu2.hidden = YES;
                button.selected = NO;
                button2.selected = NO;
                
                menu.hidden = YES;
                button.selected = NO;
                mask.hidden = YES;
                bg.backgroundColor = [UIColor clearColor];
            }

            
            if(menu.hidden)
            {
                [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            }
            else
            {
                [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
            }
        }
            break;
        case 4002:
        {
            if(menu2.hidden)
            {
                menu.hidden = YES;
                menu2.hidden = YES;
                button.selected = NO;
                button2.selected = NO;
                
                menu2.hidden = NO;
                button2.selected = YES;
                mask.hidden = NO;
                bg.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                menu.hidden = YES;
                menu2.hidden = YES;
                button.selected = NO;
                button2.selected = NO;
                
                menu2.hidden = YES;
                button2.selected = NO;
                mask.hidden = YES;
                bg.backgroundColor = [UIColor clearColor];
            }


        }
            break;
        case 4003:
        {
            MMMFriendSelectViewController *VC =[[MMMFriendSelectViewController alloc]initWithPid:_pid cid:_cid];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
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
    
    [MMMKWD globalNewKWDWithGroup:group Pid:_pid Gid:_gid Cid:_cid Page:(_page+1)  Block:^(NSArray *array, NSError *error) {
        if(!error)
        {
            _page = _page+1;
            [_dataArray addObjectsFromArray:[NSMutableArray arrayWithArray:array] ];
         
            if([array count] == 60 )
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
    [self.table reloadData];
     [indicator stopAnimating];
     _loadMoreflag = NO;
     //self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}
- (void)showLeftMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
}
- (void)showRightMenu
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:NULL];
}
- (void)changeArrowNormal:(id)sender
{
    cate_arrow.image = [UIImage imageNamed:@"category_arrow.png"];
    button3_arrow.image = [UIImage imageNamed:@"arrow.png"];
    
}
- (void)changeArrowPress:(id)sender
{
    
    switch (((UIButton *)sender).tag) {
        case 4001:
        {
            if([group isEqualToString:@"best"])
            {
               // cate_arrow.image = [UIImage imageNamed:@"category_arrow_press.png"];
            }
        }
            break;
        case 4002:
        {
            if([group isEqualToString:@"new"])
            {
               // cate_arrow.image = [UIImage imageNamed:@"category_arrow_press.png"];
            }
            
        }
            break;
        case 4003:
        {
            button3_arrow.image = [UIImage imageNamed:@"arrow_press.png"];
        }
            break;
        default:
            break;
    }
}

- (void)changeCateAction:(id)sender
{

 
    for (UIView * view in gSV.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).selected = NO;
        }
    }
    UIButton * b = ((UIButton *)sender);
    b.selected = YES;
    NSUInteger index = b.tag-1;
    
    if(b.tag == 0)
    {
        _gid = 0;
        _cid = 0;
        for (UIView * view in cSV.subviews) {
            if([view isKindOfClass:[UIButton class]])
            {
                [view removeFromSuperview];
            }
        }
        [button setTitle:@"全部" forState:UIControlStateNormal];
        [self performSelector:@selector(hideAll) withObject:nil afterDelay:0.2];
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0.55];
        return;
    }
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table3"];
    NSMutableArray * pArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data]objectForKey:@(_pid)];
    TMLCate * cate= [[pArray objectAtIndex:index] objectForKey:@"section"];
    NSMutableArray * kArray = [[pArray objectAtIndex:index] objectForKey:@"row"];
    
    for (UIView * view in cSV.subviews) {
        if([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    UIButton * Cbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 220, 43)];
    Cbutton.backgroundColor = [UIColor clearColor];
    [Cbutton setBackgroundImage:[[self imageWithColor:UIColorFromRGB(0xed5c49)]stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted|UIControlStateNormal];
    [Cbutton setBackgroundImage:[[self imageWithColor:UIColorFromRGB(0xed5c49)]stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected];
    [Cbutton setBackgroundImage:[[self imageWithColor:UIColorFromRGB(0xed5c49)]stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted|UIControlStateSelected];
    [Cbutton setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [Cbutton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal|UIControlStateHighlighted];
    [Cbutton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected|UIControlStateHighlighted];
    [Cbutton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [Cbutton setTitle:@"全部" forState:UIControlStateNormal];
    [Cbutton addTarget:self action:@selector(changeKeyWordAction:) forControlEvents:UIControlEventTouchUpInside];
    [Cbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    Cbutton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [Cbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    Cbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    Cbutton.tag = cate.cid;;
    if((_cid == 0)&&(Cbutton.tag == _gid))
    {
        Cbutton.selected = YES;
    }
    else
    {
        Cbutton.selected = NO;
    }
    [cSV addSubview:Cbutton];

    int i =0;
    for (TMLKeyWord * keyword in kArray) {
    
        UIButton * Cbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, i*44+44, 220, 43)];
        Cbutton.backgroundColor = [UIColor clearColor];
        Cbutton.tag = keyword.kid;
        if(Cbutton.tag == _cid)
        {
            Cbutton.selected = YES;
        }
        else
        {
            Cbutton.selected = NO;
        }
        /*
        [Cbutton setBackgroundImage:[UIImage imageNamed:@"tables_middle.png"] forState:UIControlStateNormal];
        [Cbutton setBackgroundImage:[UIImage imageNamed:@"tables_middle_press.png"] forState:UIControlStateHighlighted|UIControlStateNormal];
        [Cbutton setBackgroundImage:[UIImage imageNamed:@"tables_middle_press.png"] forState:UIControlStateSelected];
        [Cbutton setBackgroundImage:[UIImage imageNamed:@"tables_middle_press.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
         */
        [Cbutton setBackgroundImage:[[self imageWithColor:UIColorFromRGB(0xed5c49)]stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted|UIControlStateNormal];
        [Cbutton setBackgroundImage:[[self imageWithColor:UIColorFromRGB(0xed5c49)]stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected];
        [Cbutton setBackgroundImage:[[self imageWithColor:UIColorFromRGB(0xed5c49)]stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted|UIControlStateSelected];
        [Cbutton setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
        [Cbutton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal|UIControlStateHighlighted];
        [Cbutton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected|UIControlStateHighlighted];
        [Cbutton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        [Cbutton setTitle:keyword.name forState:UIControlStateNormal];
        [Cbutton addTarget:self action:@selector(changeKeyWordAction:) forControlEvents:UIControlEventTouchUpInside];
        [Cbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        Cbutton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [Cbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        Cbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cSV addSubview:Cbutton];
        i++;
    }
    if(i*44>308+39)
    {
        cSV.contentSize = CGSizeMake(130, i*44+39);
    }
    else
    {
        cSV.contentSize = CGSizeMake(130, 310+39);
    }
    
}
- (void)changeKeyWordAction:(id)sender
{
    for (UIView * view in cSV.subviews) {
        if([view isKindOfClass:[UIButton class]])
        {
            ((UIButton *)view).selected = NO;
        }
    }
    UIButton * b = ((UIButton *)sender);
    if([b.titleLabel.text isEqualToString:@"全部"])
    {
        _gid =  b.tag;
        _cid = 0;
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table3"];
        NSMutableArray * pArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data]objectForKey:@(_pid)];
        for (NSDictionary * dic in pArray) {
            TMLCate * cate= [dic objectForKey:@"section"];
            if(cate.cid == _gid)
            {
                [button setTitle:cate.name forState:UIControlStateNormal];
                break;
            }
        }
    }
    else
    {
        _gid =  0;
        _cid =  b.tag;
        [button setTitle:b.titleLabel.text forState:UIControlStateNormal];
    }

 
    b.selected = YES;
    [self performSelector:@selector(hideAll) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.55];
}
- (void)changeSortAction:(id)sender
{
    NSUInteger i = (((UIButton *)sender).tag);
    if(i ==2)
    {
        group =@"best";
        
        [button2 setImage:[UIImage imageNamed:@"category_icon_star.png"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"category_icon_star_red.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
        [button2 setImage:[UIImage imageNamed:@"category_icon_star_red.png"] forState:UIControlStateSelected];
        [button2 setImage:[UIImage imageNamed:@"category_icon_star_red.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [button2 setTitle:@"高评价" forState:UIControlStateNormal];
        Sortbutton2.selected = YES;
        Sortbutton.selected = NO;
        
    }
    else
    {
        group =@"new";
        [button2 setImage:[UIImage imageNamed:@"category_icon_new.png"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
        [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateSelected];
        [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [button2 setTitle:@"新上架" forState:UIControlStateNormal];
        Sortbutton.selected = YES;
        Sortbutton2.selected = NO;
    }
    button2.selected = NO;
    [self performSelector:@selector(hideAll) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.55];


}
-(void)hideAll
{
    button.selected = NO;
    button2.selected = NO;
    bg.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        menu.frame = CGRectMake(0,-308, kScreenWidth, 308);
        menu2.frame = CGRectMake(0, -87, kScreenWidth, 87);
       
        mask.alpha = 0;
         /*
        menu.alpha = 0;
        menu2.alpha = 0;
        cSV.alpha = 0;
        gSV.alpha = 0;
         */
    } completion:^(BOOL finished) {

        mask.hidden = YES;
        menu.hidden = YES;
        menu2.hidden = YES;
        mask.alpha = 0.5;
        /*
        cSV.alpha = 1;
        gSV.alpha = 1;
        
        menu.alpha = 1;
        menu2.alpha = 1;
         */
        menu.frame = CGRectMake(0, 40, kScreenWidth, 308);
        menu2.frame = CGRectMake(0, 40, kScreenWidth, 87);
        bg.backgroundColor = [UIColor clearColor];

    }];
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 通知处理
- (void)ProfileChange
{
    _openLeftMenu = YES;
}
- (void)stageChange
{
    [_dataArray removeAllObjects];
    [self.table reloadData];
    _pid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"stage"] intValue];
    _cid = 0;
    _gid = 0;
    group =@"new";
    _canLoadMore = NO;
    [self setFooterView:NO];
    [button setTitle:@"全部" forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"category_icon_new.png"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
    [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateSelected];
    [button2 setImage:[UIImage imageNamed:@"category_icon_new_red.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [button2 setTitle:@"新上架" forState:UIControlStateNormal];
    Sortbutton.selected = YES;
    Sortbutton2.selected = NO;
    
    for (UIView * view in gSV.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
        if (view.tag == 18746) {
            [view removeFromSuperview];
        }
    }
    for (UIView * view in cSV.subviews) {
        if([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"table3"];
    NSMutableArray * pArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data]objectForKey:@(_pid)];
    UIButton * Cbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 130, 43)];
    Cbutton.backgroundColor = [UIColor whiteColor];
    
    
    //[Cbutton setBackgroundImage:[UIImage imageNamed:@"tables_middle.png"] forState:UIControlStateNormal];
    [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2] forState:UIControlStateNormal|UIControlStateHighlighted];
    [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateHighlighted|UIControlStateSelected];
    [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateSelected];
    
    [Cbutton setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [Cbutton setTitle:@"全部" forState:UIControlStateNormal];
    [Cbutton addTarget:self action:@selector(changeCateAction:) forControlEvents:UIControlEventTouchUpInside];
    [Cbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    Cbutton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [Cbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    Cbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    Cbutton.selected = YES;
    Cbutton.tag = 0;
    [gSV addSubview:Cbutton];
    
    int i =1;
    
    for (NSDictionary * dic in pArray) {
        TMLCate * cate= [dic objectForKey:@"section"];
        UIButton * Cbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, i*44, 130, 44)];
        Cbutton.backgroundColor = [UIColor whiteColor];
        
        
        //[Cbutton setBackgroundImage:[UIImage imageNamed:@"tables_middle.png"] forState:UIControlStateNormal];
        [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2] forState:UIControlStateNormal|UIControlStateHighlighted];
        [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateHighlighted|UIControlStateSelected];
        [Cbutton setBackgroundImage:[[UIImage imageNamed:@"category_select.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:2]  forState:UIControlStateSelected];
        
        [Cbutton setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        Cbutton.tag = [pArray indexOfObject:dic]+1;
        [Cbutton setTitle:cate.name forState:UIControlStateNormal];
        [Cbutton addTarget:self action:@selector(changeCateAction:) forControlEvents:UIControlEventTouchUpInside];
        [Cbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        Cbutton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [Cbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        Cbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [gSV addSubview:Cbutton];
        
        UIView * H = [[UIView alloc]initWithFrame:CGRectMake(0, i*44-1, 130, 1)];
        H.tag = 18746;
        H.backgroundColor = UIColorFromRGB(0xededed);
        [gSV addSubview:H];
        
        i++;
    }
    if(i*44>308)
    {
        gSV.contentSize = CGSizeMake(130, i*44);
    }
    else
    {
        gSV.contentSize = CGSizeMake(130, 308);
    }

    self.navigationItem.titleView = [GKTitleView setTitleLabel:[[_titleArray objectAtIndex:_pid -1] objectForKey:@"name"]];
    [self performSelector:@selector(hideAll) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.55];
}
- (void)cardLikeChange:(NSNotification *)noti
{
    NSDictionary *notidata = [noti userInfo];
    NSUInteger entity_id = [[notidata objectForKey:@"entityID"]integerValue];
    NSUInteger index = -1;
    GKEntity * e = [notidata objectForKey:@"entity"];
    
    for (GKEntity * entity in  _dataArray) {
        if(entity.entity_id == entity_id)
        {
            index = [_dataArray indexOfObject:entity];
            break;
        }
    }
    if(index!=-1)
    {
        [_dataArray setObject:e atIndexedSubscript:index];
    }
    [self.table reloadData];
}
- (void)checkShouldOpenMenu
{
    if(_openLeftMenu)
    {
        
        [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            _openLeftMenu = NO;
        }];
        
    }

}
- (void)GKLogin
{
    _openLeftMenu = YES;
    [self stageChange];
}
- (void)GKLogout
{
    [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
        _openLeftMenu = YES;
    }];

}
- (void)setOpenRight
{
    _openRightMenu = YES;
}

@end
