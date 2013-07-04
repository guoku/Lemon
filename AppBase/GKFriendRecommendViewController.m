//
//  GKFriendRecommendViewController.m
//  Grape
//
//  Created by huiter on 13-5-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKFriendRecommendViewController.h"
#import "GKRecommendFriend.h"
#import "FollowUserCell.h"
#import "GKAppDelegate.h"
#import "GKFileManager.h"
#import "PinyinTools.h"
#define kSearchString @"abcdefghijklmnopqrstuvwxyz#"
@interface GKFriendRecommendViewController ()

@end

@implementation GKFriendRecommendViewController
{
@private
    NSUInteger page;
    UIActivityIndicatorView *indicator;
    BOOL _loadMoreflag;
    UIImageView *cate_arrow;

    NSInteger _cursor;
    BOOL _recieveData;
}
@synthesize table = _table;
@synthesize searchBar = _searchBar;
@synthesize searchDC = _searchDC;
@synthesize allFriends = _allFriends;
@synthesize filteredArray = _filteredArray;
@synthesize sectionDic = _sectionDic;
@synthesize allKeys = _allKeys;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"邀请好友";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowChange:) name:@"UserFollowChange" object:nil];
    
    self.view.backgroundColor =UIColorFromRGB(0xf2f2f2);
	// Do any additional setup after loading the view.
    self.sectionDic = [NSMutableDictionary dictionaryWithCapacity:10];
    self.allFriends = [NSMutableArray arrayWithCapacity:5];
    self.filteredArray = [NSMutableArray arrayWithCapacity:5];
    _cursor = 1;
    

    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    UIButton *refreshBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [refreshBTN setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
    [refreshBTN addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBTN];
    
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"邀请好友"];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    bg.backgroundColor =UIColorFromRGB(0xf1f1f1);
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 40)];
    [button setImage:[UIImage imageNamed:@"icon_sina.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_sina.png"] forState:UIControlStateHighlighted];
    
    [button.titleLabel setTextAlignment:UITextAlignmentLeft];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [button setTitle:@"邀请微博好友" forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 4001;
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(160, 0, 160, 40)];
    [button2 setImage:[UIImage imageNamed:@"icon_weixin.png"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"icon_weixin.png"] forState:UIControlStateHighlighted];
    [button2.titleLabel setTextAlignment:UITextAlignmentLeft];
    button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button2 setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [button2 setTitle:@"邀请微信好友" forState:UIControlStateNormal];
    [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button2 addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 4002;
        
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrow.frame = CGRectMake(300, 13, 8, 14);
    arrow.backgroundColor = [UIColor clearColor];
    [bg addSubview:button];
    [bg addSubview:button2];
    [bg addSubview:arrow];
    
    UIView *V1 = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 1, 40)];
    V1.backgroundColor =UIColorFromRGB(0xe4e4e4);
    UIView *H1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    H1.backgroundColor =UIColorFromRGB(0xe4e4e4);
    
    [bg addSubview:H1];
    [bg addSubview:V1];
    
    cate_arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"category_arrow.png"]];
    cate_arrow.frame = CGRectMake(0,39, 15,8);
    cate_arrow.center = CGPointMake(80, cate_arrow.center.y);
    cate_arrow.backgroundColor = [UIColor clearColor];
         [view addSubview:cate_arrow];
    [view addSubview:bg];
    [view addSubview:cate_arrow];

    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-44-40) style:UITableViewStylePlain];
    _table.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = NO;
    [_table setDelegate:self];
    [_table setDataSource:self];
    
    [self.view addSubview:_table];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 215.0f, 44.0f)];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.showsSearchResultsButton = NO;
    //self.table.tableHeaderView = _searchBar;
    
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDC.searchResultsDataSource = self;
    _searchDC.searchResultsDelegate = self;
    
    [self.view addSubview:view];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserFollowChange" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(loadData) withObject:self afterDelay:0.3];
}
- (void)loadData
{
    NSArray *friendsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[GKFileManager getFullFileNameWithName:[NSString stringWithFormat:@"friends_%@", [self sinaweibo].userID]]];
    if (!friendsArray || (0 == [friendsArray count])) {
        [self reload:nil];
    } else {
        [_allFriends addObjectsFromArray:friendsArray];
        [self loadAllFriends];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonAction:(id)sender
{ 
    
    GKAppDelegate *delegate = ((GKAppDelegate *)[UIApplication sharedApplication].delegate);
    UIGraphicsBeginImageContext(delegate.window.bounds.size);
    
    [delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    delegate.window.rootViewController = delegate.drawerController;
    UIGraphicsBeginImageContext(delegate.window.bounds.size);
    
    [delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:image2];

    
    imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    imageView2.frame = CGRectMake(-320, 0, imageView2.frame.size.width, imageView2.frame.size.height);
    
    [delegate.window addSubview:imageView];
    [delegate.window addSubview:imageView2];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.frame = CGRectMake(320, 0, imageView.frame.size.width, imageView.frame.size.height);
        imageView2.frame = CGRectMake(0, 0, imageView2.frame.size.width, imageView2.frame.size.height);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [imageView2 removeFromSuperview];
    }];
}
- (void)TapButtonAction:(id)sender
{
    NSLog(@"%d",((UIButton *)sender).tag);
    switch (((UIButton *)sender).tag) {
        case 4001:
        {
            [UIView animateWithDuration:0.3 animations:^{
                cate_arrow.center = CGPointMake(80, cate_arrow.center.y);
            }completion:^(BOOL finished) {
                
            }];
            
        }
            break;
        case 4002:
        {
            [self wxShare:0];
        }
            break;
        default:
            break;
    }
}
-(void)wxShare:(int)scene;
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"分享「妈妈清单」应用";
    message.description= @"「妈妈清单」，养孩子必备。";
    [message setThumbImage:[UIImage imageNamed:@"wxshare.png"]];
        
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.Url = [NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kGK_AppID_iPhone];;
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (SinaWeibo *)sinaweibo
{
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}
- (void)refresh
{
    _cursor = 1;
    [GKFileManager removeFileWithName:[NSString stringWithFormat:@"friends_%@", [self sinaweibo].userID]];
    [self.sectionDic removeAllObjects];
    [self.filteredArray removeAllObjects];
    [self.allFriends removeAllObjects];
    
    
    [self reload:nil];
}
- (void)reload:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [GKMessageBoard showActivity];
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"friendships/friends.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [self sinaweibo].userID, @"uid",[NSString stringWithFormat:@"%u",_cursor],@"cursor",@"200",@"count", nil]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [GKMessageBoard hideActivity];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if(error.code ==21315)
    {
        SinaWeibo *sinaweibo = [self sinaweibo];
        [sinaweibo logIn];
    }
    else
    {
        [GKMessageBoard showMBWithText:[NSString  stringWithFormat:@"网络错误,错误代码%u",error.code]customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    GKLog(@"%@",result);
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = (NSDictionary *)result;
        
        _cursor = [[data objectForKey:@"next_cursor"] intValue];
        [_allFriends addObjectsFromArray:[data objectForKey:@"users"]];
        
        int next_cursor = [[data objectForKey:@"next_cursor"] intValue];
        if (next_cursor == 0) {
            _cursor = -1;
            [NSKeyedArchiver archiveRootObject:_allFriends toFile:[GKFileManager getFullFileNameWithName:[NSString stringWithFormat:@"friends_%@",[self sinaweibo].userID]]];
            [self loadAllFriends];
            _recieveData = NO;
            [GKMessageBoard hideActivity];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            return;
        }
        else {
            [self reload:nil];
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedUser = nil;
    
    if (tableView == self.table) {
        NSDictionary *dic = [_sectionDic objectForKey:[_allKeys objectAtIndex:indexPath.section]];
        NSArray *data = [dic objectForKey:@"data"];
        selectedUser = [data objectAtIndex:indexPath.row];
    } else {
        selectedUser = [_filteredArray objectAtIndex:indexPath.row];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addWeiboFriend" object:nil userInfo:selectedUser];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.table) {
        return [_allKeys count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == self.table) {
        NSDictionary *dic = [_sectionDic objectForKey:[_allKeys objectAtIndex:section]];
        NSArray *array = [dic objectForKey:@"data"];
        count = [array count];
        if (section == [_allKeys count] - 1) {
        }
    } else {
        if ([_filteredArray count] > 0) {
            [_filteredArray removeAllObjects];
        }
        [self searchBar:_searchBar textDidChange:_searchBar.text];
        count = [_filteredArray count];
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.table) {
        return 20.0f;
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch) {
        [self.table scrollRectToVisible:_searchBar.frame animated:NO];
        return -1;
    }
    
    return [kSearchString rangeOfString:title].location;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.table) {
        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        for (int i = 0; i < 27; i++) {
            [index addObject:[kSearchString substringWithRange:NSMakeRange(i, 1)]];
        }
        return index;
    } else return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    if (tableView == self.table) {
        title = [[_allKeys objectAtIndex:section] lowercaseString];
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeiboFriendsCell";
    
    UIImageView * userAvatar;
    UILabel * screenName;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } else {
        for (UIView * view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        [[SDImageCache sharedImageCache] clearMemory];
    }
    // Configure the cell...
    cell.backgroundColor =UIColorFromRGB(0xf9f9f9);
    userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 4.0f, 32.0f, 32.0f)];
    userAvatar.layer.cornerRadius = 3.0f;
    userAvatar.layer.masksToBounds = YES;
    [cell.contentView addSubview:userAvatar];
    
    screenName = [[UILabel alloc] initWithFrame:CGRectMake(55.0f, 0.0f, 150.0f, 42.0f)];
    [screenName setBackgroundColor:[UIColor clearColor]];
    [screenName setTextAlignment:UITextAlignmentLeft];
    [screenName setFont:[UIFont systemFontOfSize:15.0f]];
    [cell.contentView addSubview:screenName];
    
    NSDictionary *user = nil;
    if (tableView == self.table) {
        NSDictionary *dic = [_sectionDic objectForKey:[_allKeys objectAtIndex:indexPath.section]];
        NSArray *data = [dic objectForKey:@"data"];
        user = [data objectAtIndex:indexPath.row];
        [userAvatar setImageWithURL:[NSURL URLWithString:[user valueForKey:@"profile_image_url"]]];
        [screenName setText:[user valueForKey:@"screen_name"]];
    } else {
        user = [_filteredArray objectAtIndex:indexPath.row];
    }
    [userAvatar setImageWithURL:[NSURL URLWithString:[user valueForKey:@"profile_image_url"]]];
    [screenName setText:[user valueForKey:@"screen_name"]];
    
    UIButton *_invite= [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, 6, 50, 30)];
    [_invite setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_invite setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] forState:UIControlStateHighlighted];
    [_invite setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_invite setTitle:@"邀请" forState:UIControlStateNormal];
    [_invite.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    //[_invite addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    [_invite.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:_invite];
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        return;
    }
    [self handleSearchText:searchText];
}

- (void)handleSearchText:(NSString *)searchText
{
    for (NSDictionary *friend in _allFriends) {
        NSString *screenName = [friend objectForKey:@"screen_name"];
        if ([PinyinTools ifNameString:screenName SearchString:searchText]) {
            [_filteredArray addObject:friend];
        }
    }
}


- (void)loadAllFriends
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    for (NSDictionary *user in _allFriends) {
        NSString *screenName = [user objectForKey:@"screen_name"];
        NSString *firstLetter = nil;
        
        if ([screenName length] > 0) {
            firstLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([screenName characterAtIndex:0])] lowercaseString];
            if ([kSearchString rangeOfString:firstLetter].location == NSNotFound) {
                firstLetter = @"#";
            }
        }
        if (firstLetter != nil) {
            NSMutableDictionary *dic = [_sectionDic objectForKey:firstLetter];
            if (!dic || (0 == [dic count])) {
                dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"data"];
            }
            NSMutableArray *arr = [dic objectForKey:@"data"];
            [arr addObject:user];
            [_sectionDic setObject:dic forKey:firstLetter];
        }
    }
    self.allKeys = [NSMutableArray arrayWithArray:[[_sectionDic allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    if (([_allKeys count] > 0) && ([[_allKeys objectAtIndex:0] isEqualToString:@"#"])) {
        [_allKeys removeObjectAtIndex:0];
        [_allKeys addObject:@"#"];
    }
    
    [self.table reloadData];
}



@end
