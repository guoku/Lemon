//
//  GKWeiboFriendsViewController.m
//  Grape
//
//  Created by huiter on 13-4-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKWeiboFriendsViewController.h"
#import "GKAppDelegate.h"
#import "GKFileManager.h"
#import "PinyinTools.h"
#define kSearchString @"abcdefghijklmnopqrstuvwxyz#"

@interface GKWeiboFriendsViewController ()
{
@private
    NSInteger _cursor;    
    BOOL _recieveData;
}
@end

@implementation GKWeiboFriendsViewController
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
        self.navigationItem.titleView = [GKTitleView setTitleLabel:@"你的好友"];
        self.view.backgroundColor = kColorf9f9f9;
        self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [backBTN setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backBTN setImageEdgeInsets:UIEdgeInsetsMake(0, -20.0f, 0, 0)];
        [backBTN addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBTN];
        [self.navigationItem setLeftBarButtonItem:back animated:YES];
        
        UIButton *refreshBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [refreshBTN setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
        [refreshBTN addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshBTN];
        [self.navigationItem setRightBarButtonItem:refresh animated:YES];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"@微博好友页";
	// Do any additional setup after loading the view.
    self.sectionDic = [NSMutableDictionary dictionaryWithCapacity:10];
    self.allFriends = [NSMutableArray arrayWithCapacity:5];
    self.filteredArray = [NSMutableArray arrayWithCapacity:5];
    _cursor = 1;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44) style:UITableViewStylePlain];
    _table.backgroundColor = kColorf9f9f9;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor = kColorf9f9f9;
    _table.allowsSelection = YES;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 215.0f, 44.0f)];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.showsSearchResultsButton = NO;
    self.table.tableHeaderView = _searchBar;
    
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDC.searchResultsDataSource = self;
    _searchDC.searchResultsDelegate = self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSArray *friendsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[GKFileManager getFullFileNameWithName:[NSString stringWithFormat:@"friends_%@", [self sinaweibo].userID]]];
    if (!friendsArray || (0 == [friendsArray count])) {
        [self reload:nil];
    } else {
        [_allFriends addObjectsFromArray:friendsArray];
        [self loadAllFriends];
    }

    
}
- (void)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
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
    cell.backgroundColor = kColorf9f9f9;
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
