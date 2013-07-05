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
#import "RatingView.h"
#import "DPCardWebViewController.h"

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
    UIImageView *tabArrow;
    UIView * store;
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
        friendonly = NO;
        self.detailHeaderView = [[GKDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 205)];
        self.detailHeaderView.delegate =self;
        self.navigationItem.titleView = [GKTitleView  setTitleLabel:@"详情"];
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
    [self.detailHeaderView.shareButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailHeaderView.buyInfoButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
                /*
                for (GKNote *note in _data.notes_list) {
                    //if (note.creator.relation !=nil) 
                    if(0)
                    {
                        [_friendarray addObject:note];
                    }
                }
                 */
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
    
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    UIButton *moreBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [moreBTN setImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [moreBTN addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBTN];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor whiteColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = NO;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    
    tableheaderview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 205)];
    [tableheaderview addSubview:self.detailHeaderView];
    _table.tableHeaderView = tableheaderview;
    
        
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];    
    _table.tableFooterView = tableFooterView;
    _table.tableFooterView.hidden = YES;
}
-(void) setFooterViewText
{
    GKUser *user = [[GKUser alloc] initFromSQLite];
    /*
    for (GKNote * note in _data.notes_list) {
        if(note.creator.user_id == user.user_id)
        {
            [noteBTN setTitle:@"修改我的点评" forState:UIControlStateNormal];
            [noteBTN setImage:nil forState:UIControlStateNormal];
            [noteBTN setImage:nil forState:UIControlStateHighlighted];
            break;
        }
    }
     */
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
    /*
    if([_data.notes_list count] == 0)
        return 0;
    else
        return 1;
     */
    return 0;
}

//返回每个Section有多少Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(friendonly == NO)
    {
        //return [_data.notes_list count];
        return 0;
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
    if(friendonly == NO)
    {
    //cell.noteData = [_data.notes_list objectAtIndex:indexPath.row];
    }
    else
    {
    cell.noteData = [_friendarray objectAtIndex:indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CGFloat height = [GKDetailNoteCellView height:[_data.notes_list objectAtIndex:indexPath.row]];
    //return height;
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *f5f4f4bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    f5f4f4bg.backgroundColor =UIColorFromRGB(0xf5f4f4);
    
    UILabel *allnotelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-80, 40)];
    allnotelabel.textAlignment = NSTextAlignmentLeft;
    allnotelabel.textColor =UIColorFromRGB(0x999999);
    allnotelabel.backgroundColor = [UIColor clearColor];
    allnotelabel.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    allnotelabel.text = @"  总体评价";
    [f5f4f4bg addSubview:allnotelabel];
    
    RatingView *_ratingView = [[RatingView alloc]initWithFrame:CGRectMake(60, 0, 80, 40)];
    [_ratingView setImagesDeselected:@"star_m.png" partlySelected:@"star_m_half.png" fullSelected:@"star_m_full.png" andDelegate:nil];
    _ratingView.center = CGPointMake(_ratingView.center.x, 20);
    _ratingView.userInteractionEnabled = NO;
    [_ratingView displayRating:8/2];
    [f5f4f4bg addSubview:_ratingView];
    
    UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 20, 40)];
    score.textAlignment = NSTextAlignmentLeft;
    score.backgroundColor = [UIColor clearColor];
    score.textColor =UIColorFromRGB(0x999999);
    score.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    score.text = @"8.0";
    [f5f4f4bg addSubview:score];
    
    
    
    if(1)
    {
        tabArrow.hidden = NO;
        UILabel *friendtab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-80, 0, 80, 40)];
        friendtab.textAlignment = NSTextAlignmentCenter;
        friendtab.backgroundColor = [UIColor clearColor];
        friendtab.textColor =UIColorFromRGB(0x999999);
        friendtab.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
        friendtab.text = @"好友推荐 3";
        [f5f4f4bg addSubview:friendtab];
        friendtab.backgroundColor =UIColorFromRGB(0xf1f1f1);
        
        UIView * V = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-80, 0, 1, 40)];
        V.backgroundColor = [UIColor colorWithRed:220.0f / 255.0f green:219.0f / 255.0f blue:219.0 / 255.0f alpha:1.0f];
        [f5f4f4bg addSubview:V];
        
        UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectZero];
        button1.frame = allnotelabel.frame;
        button1.tag = 4001;
        
        UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectZero];
        button2.frame = friendtab.frame;
        button2.tag = 4002;
        [button1 addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(TapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [f5f4f4bg addSubview:button1];
        [f5f4f4bg addSubview:button2];
    }
    else
    {
        //tabArrow.hidden = YES;
    }
    
    tabArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"review_arrow.png"]];
    tabArrow.frame = CGRectMake(0, 33, 12, 7);
    if(friendonly)
    {
        tabArrow.center = CGPointMake(kScreenWidth-40, tabArrow.center.y);
    }
    else
    {
        tabArrow.center = CGPointMake(36, tabArrow.center.y); 
    }
    [f5f4f4bg addSubview:tabArrow];

    
    
    return f5f4f4bg;
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
        /*
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
     */
    }
}


#pragma mark - button action
- (void)TapButtonAction:(id)sender
{
    switch (((UIButton *)sender).tag) {
        case 4001:
        {
            [UIView animateWithDuration:0.3 animations:^{
                tabArrow.center = CGPointMake(36, tabArrow.center.y);
            }completion:^(BOOL finished) {
                friendonly = NO;
                [_table reloadData];
            }];
        }
            break;
        case 4002:
        {
            [UIView animateWithDuration:0.3 animations:^{
                tabArrow.center = CGPointMake(kScreenWidth-40, tabArrow.center.y);
            }completion:^(BOOL finished) {
                friendonly = YES;
                [_table reloadData];
            }];
        }
            break;
        default:
            break;
    }

}
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
- (void)buyButtonAction:(id)sender
{
    store = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight+20, kScreenWidth, 200)];
    store.backgroundColor = [UIColor whiteColor];
    int i =0;
    for (i=1; i<3; i++) {

        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10, 10+i*50, kScreenWidth-20, 40)];
        button.backgroundColor = [UIColor redColor];
        button.tag = i;
        [button addTarget:self action:@selector(shopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [store addSubview:button];
    }
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:store];
    [UIView animateWithDuration:0.3 animations:^{
        store.frame = CGRectMake(0, kScreenHeight-200+20, kScreenWidth, 200);
    }completion:^(BOOL finished) {

    }];
}
- (void)shopButtonAction:(id)sender
{
    //NSUInteger *shopIndex = ((UIButton *)sender).tag;
    [UIView animateWithDuration:0.3 animations:^{
        store.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        for (UIView *view in store.subviews) {
            view.alpha = 0;
        }
    }completion:^(BOOL finished) {
        //[self showWebViewWithTaobaoUrl:_detailHeaderView.detailData.urlString];
    }];

}
- (void)showWebViewWithTaobaoUrl:(NSString *)taobao_url
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                    withAction:@"go_taobao"
                                                     withLabel:nil
                                                     withValue:nil];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    NSString * TTID = [NSString stringWithFormat:@"%@_%@",kTTID_IPHONE,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *sid = @"";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginTaobaoUserInfo"] objectForKey:@"sid"])
    {
        sid = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginTaobaoUserInfo"] objectForKey:@"sid"]];
    }
    taobao_url = [taobao_url stringByReplacingOccurrencesOfString:@"&type=mobile" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@&ttid=%@&sid=%@&type=mobile&outer_code=IPE",taobao_url, TTID,sid];
    GKUser *user = [[GKUser alloc ]initFromSQLite];
    if(user.user_id !=0)
    {
        url = [NSString stringWithFormat:@"%@%u",url,user.user_id];
    }
    NSLog(@"%@",url);
    DPCardWebViewController * _webVC = [DPCardWebViewController linksWebViewControllerWithURL:[NSURL URLWithString:url]];
    
    _webVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController * _navi = [[UINavigationController alloc] initWithRootViewController:_webVC] ;
    [self presentViewController:_navi animated:NO completion:^{
        [store removeFromSuperview];
    }];
    
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
