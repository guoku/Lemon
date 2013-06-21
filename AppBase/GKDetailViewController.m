//
//  GKDetailViewController.m
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKDetailViewController.h"
#import "GKSinaShareViewController.h"
#import "GKDetailNoteCellView.h"
#import "GKAppDelegate.h"
#import "HMSegmentedControl.h"

@interface GKDetailViewController ()

@end

@implementation GKDetailViewController
{
@private
    UIActivityIndicatorView *indicator;
    UIButton* noteBTN;
    UIView *tableheaderview;
    NSMutableArray *_friendarray;
    BOOL friendonly;
}

@synthesize data = _data;
@synthesize entity_id = _entity_id;
@synthesize entity = _entity;
@synthesize table = _table;
@synthesize detailHeaderView = _detailHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        friendonly = YES;
        self.detailHeaderView = [[GKDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 410)];
        self.detailHeaderView.delegate =self;
    }
    return self;
}

- (id)initWithEntityID:(NSUInteger)entity_id
{
    self = [super init];
    {
        _entity_id = entity_id;
    }
    
    return self;
}
- (id)initWithDate:(GKEntity * )data
{
    self = [super init];
    {
        if ([data isKindOfClass:[GKEntity class]])
        {
            _entity_id = data.entity_id;
            _entity = data;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.detailHeaderView.detailData = _entity;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_data == nil)
    {
        GKLog(@"entity --- id --------------- %u", self.entity_id);
        [self showActivity];
        _table.tableFooterView.hidden = NO;
        [GKDetail globalDetailPageWithEntityId:_entity_id Block:^(NSDictionary *dict, NSError *error) {
            if(!error)
            {
                _data = [dict valueForKeyPath:@"content"];
                _friendarray = [[NSMutableArray alloc]initWithCapacity:0];
                for (GKNote *note in _data.notes_list) {
                    //if (note.creator.relation !=nil) 
                    if(0)
                    {
                        [_friendarray addObject:note];
                    }
                }
                [self setFooterViewText];
                self.detailHeaderView.detailData = _data;
                [self.table reloadData];
                [self hideActivity];
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
                        self.table.tableFooterView = nil;
                    }
                        break;
                }
                [self hideActivity];
            }
            
        }];
    }
    else
    {
        _table.tableFooterView.hidden = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GKMessageBoard hideActivity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backBTN setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBTN setImageEdgeInsets:UIEdgeInsetsMake(0, -20.0f, 0, 0)];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBTN];
    [self.navigationItem setLeftBarButtonItem:back animated:YES];
    
    UIButton *moreBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [moreBTN setImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [moreBTN addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBTN];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStylePlain];
    _table.backgroundColor = kColorf9f9f9;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = NO;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    
    tableheaderview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 447)];
    UIImageView *_bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 447)];
    [_bgImageView setImage:[[UIImage imageNamed:@"detail_cell_top"]stretchableImageWithLeftCapWidth:10 topCapHeight:1]];
    [tableheaderview addSubview:_bgImageView];
    UIImageView  *_seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 446, kScreenWidth,2)];
    [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
    [tableheaderview addSubview:_seperatorLineImageView];
    [tableheaderview addSubview:self.detailHeaderView];
    _table.tableHeaderView = tableheaderview;
    
    
    

    
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];    
    _table.tableFooterView = tableFooterView;
    _table.tableFooterView.hidden = YES;
}
-(void) setFooterViewText
{
    GKUser *user = [[GKUser alloc] initFromSQLite];
    
    for (GKNote * note in _data.notes_list) {
        if(note.creator.user_id == user.user_id)
        {
            [noteBTN setTitle:@"修改我的点评" forState:UIControlStateNormal];
            [noteBTN setImage:nil forState:UIControlStateNormal];
            [noteBTN setImage:nil forState:UIControlStateHighlighted];
            break;
        }
    }
}
-(void) showActivity
{
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, kScreenWidth-40, 30);
    indicator.backgroundColor = [UIColor whiteColor];
    indicator.center = CGPointMake(kScreenWidth/2, 18.0f);
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    [self.table.tableFooterView addSubview:indicator];
}
-(void) hideActivity
{
    [indicator stopAnimating];
}



#pragma mark 重载tableview必选方法
//返回一共有多少个Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([_data.notes_list count] == 0)
        return 0;
    else
        return 1;
}

//返回每个Section有多少Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(friendonly == NO)
    {
        return [_data.notes_list count];
    }
    else
    {
        return [_friendarray count];
    }
}

//定义每个Row
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *NoteTableIdentifier = @"NoteTableIdentifier";
    
    GKDetailNoteCellView *cell = [tableView dequeueReusableCellWithIdentifier:
                                  NoteTableIdentifier];
    if (cell == nil) {
        cell = [[GKDetailNoteCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: NoteTableIdentifier];
        
    }
    cell.delegate = self;
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_cell_top"]];
    if(friendonly == NO)
    {
    cell.noteData = [_data.notes_list objectAtIndex:indexPath.row];
    }
    else
    {
    cell.noteData = [_friendarray objectAtIndex:indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [GKDetailNoteCellView height:[_data.notes_list objectAtIndex:indexPath.row]];
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"总体评价",@"好友评价"]];
    segmentedControl.frame =CGRectMake(0, 0, kScreenWidth, 40);
    [segmentedControl setSelectedIndex:!friendonly];
    [segmentedControl setIndexChangeBlock:^(NSUInteger index) {
        if(index ==1)
        {
            friendonly = NO;
        }
        else
        {
            friendonly = YES;
        }
        [self.table reloadData];
    }];
    [segmentedControl setSelectionIndicatorHeight:4.0f];
    [segmentedControl setBackgroundColor:kColorf2f2f2];
    [segmentedControl setTextColor:[UIColor whiteColor]];
    [segmentedControl setSelectionIndicatorColor:[UIColor redColor]];
    [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [segmentedControl setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [segmentedControl setTag:2];
    
    return segmentedControl;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - NoteCellDelegate
- (void)cardLikeChange:(NSNotification *)noti
{
    NSDictionary *notidata = [noti userInfo];
    NSUInteger entity_id = [[notidata objectForKey:@"entityID"]integerValue];
    
    if (entity_id == _data.entity_id) {
        _data.liked_count = [[notidata objectForKey:@"likeCount"] integerValue];
        _data.entitylike = [notidata objectForKey:@"likeStatus"];
        self.detailHeaderView.detailData = _data;
        GKUser *user = [[GKUser alloc ]initFromSQLite];
        if(user.user_id !=0)
        {
            NSMutableArray *a = [NSMutableArray arrayWithCapacity:([_data.liker_list count]+1)];
            if(_data.entitylike.status == NO)
            {
                
                for (GKUserBase*userBase in _data.liker_list)
                {
                    if(userBase.user_id != user.user_id)
                    {
                        [a addObject:userBase];
                    }
                }
                
            }
            else
            {
                NSMutableDictionary *userBaseDictionary = [[NSMutableDictionary alloc]init];
                [userBaseDictionary setObject:@(user.user_id) forKey:@"user_id"];
                [userBaseDictionary setObject:user.nickname forKey:@"nickname"];
                [userBaseDictionary setObject:user.username forKey:@"username"];
                [userBaseDictionary setObject:user.gender forKey:@"gender"];
                [userBaseDictionary setObject:user.location forKey:@"location"];
                [userBaseDictionary setObject:user.email forKey:@"email"];
                [userBaseDictionary setObject:user.website forKey:@"website"];
                [userBaseDictionary setObject:user.bio forKey:@"bio"];
                [userBaseDictionary setObject:[[user.avatars avatarSmallURL] absoluteString] forKey:@"avatar_url"];
                GKUserBase *meBase = [[GKUserBase alloc] initWithAttributes:userBaseDictionary];
                [a addObject:meBase];
                [a addObjectsFromArray:_data.liker_list];
            }
            _data.liker_list = a;
            [self.table reloadData];
        }
    }
    
}

#pragma mark - notification
- (void)addNewNote:(NSNotification *)noti
{
    NSDictionary *notidata = [noti userInfo];
    //    GKLog(@"%@", notidata);
    GKNote * newnote = [notidata valueForKeyPath:@"content"];
    //    NSUInteger entity_id = [[notidata objectForKey:@"entityID"]integerValue];
    //    GKNote * newnote = [notidata objectForKey:@"note"];
    BOOL IsNewNote = YES;
    int i=0;
    if(_data.entity_id == newnote.entity_id)
    {
        for (GKNote *note in _data.notes_list) {
            
            if(note.note_id == newnote.note_id)
            {
                _data.notes_list[i] = newnote;
                IsNewNote = NO;
                break;
            }
            i++;
        }
        if(IsNewNote)
        {
            [_data.notes_list addObject:newnote];
            [self setFooterViewText];
        }
        self.detailHeaderView.detailData = _data;
        [self.table reloadData];
        
    }
}


#pragma mark - button action
- (void)moreButtonAction:(id)sender
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
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([delegate.sinaweibo isAuthValid]) {
        GKSinaShareViewController *sinaShareVc = [[GKSinaShareViewController alloc]initWithDetailData:_entity];
        sinaShareVc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:sinaShareVc animated:YES];
    }
    else
    {
        [delegate.sinaweibo logIn];
    }
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
    
    
    UIImage *image = [self.detailHeaderView image];
    NSData *oldData = UIImageJPEGRepresentation(image, 1.0);
    CGFloat size = oldData.length / 1024;
    GKLog(@"image size---%f",size);
    if (size > 25.0f) {
        CGFloat f = 25.0f / size;
        NSData *datas = UIImageJPEGRepresentation(image, f);
        //            float s = datas.length / 1024;
        //            GKLog(@"s---%f",s);
        UIImage *smallImage = [UIImage imageWithData:datas];
        [message setThumbImage:smallImage];
    }
    else{
        [message setThumbImage:image];
    }
    
    WXWebpageObject *webPage = [WXWebpageObject object];
    webPage.webpageUrl = [NSString stringWithFormat:@"%@%u",kGK_WeixinShareURL,_data.entity_id];
    GKLog(@"webpageUrl---%@",webPage.webpageUrl);
    message.mediaObject = webPage;
    message.title = @"果库 - 尽收世上好物";
    if(scene ==1)
    {
        message.title = _data.title;
        message.description = @"";
    }
    else
    {
        message.title = @"果库 - 尽收世上好物";
        message.description = _data.title;
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

@end
