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
#import "GKNotePostViewController.h"

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
    UIButton * mask;
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
            _detailHeaderView.detailData = data;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardLikeChange:) name:kGKN_EntityLikeChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewNote:) name:GKAddNewNoteNotification object:nil];
	// Do any additional setup after loading the view.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGKN_EntityLikeChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKAddNewNoteNotification object:nil];
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
                NSLog(@"%@",_data);
                _friendarray = [[NSMutableArray alloc]initWithCapacity:0];
              
                for (GKNote *note in _data.notes_list) {
                    if (note.creator.relation !=nil) 
                    {
                        switch (note.creator.relation.status) {
                            case kBothRelation:
                                [_friendarray addObject:note];
                                break;
                            case kFOLLOWED:
                                [_friendarray addObject:note];
                            default:
                                break;
                        }
                      
                    }
                }
             
                self.detailHeaderView.detailData = _data;
                GKEntity * entity = (GKEntity *)_data;
                
                if(entity.entitylike.status)
                {
                    NSLog(@"%@",entity.pid_list);
                    for(NSString  * pidString in entity.pid_list ) {
                        entity.pid = [pidString integerValue];
                        [entity save];
                    }
                }
                else
                {
                    [GKEntity deleteWithEntityID:entity.entity_id];
                }
                
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
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:NO];
    [GKMessageBoard hideActivity];
    [self HideShop];
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
    
    UIButton *moreBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 32)];
    [moreBTN setImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [moreBTN addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBTN];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor whiteColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = YES;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    
    tableheaderview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 205)];
    [tableheaderview addSubview:self.detailHeaderView];
    _table.tableHeaderView = tableheaderview;
    
    [self.detailHeaderView.usedButton addTarget:self action:@selector(showNotePostView) forControlEvents:UIControlEventTouchUpInside];
    
        
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];    
    _table.tableFooterView = tableFooterView;
    _table.tableFooterView.hidden = YES;
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
    cell.notedelegate = self;
    cell.selectedBackgroundView =[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"tables_bottom_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:2]];
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
    [_ratingView displayRating:_detailHeaderView.detailData.avg_score/2];
    [f5f4f4bg addSubview:_ratingView];
    
    UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 80, 40)];
    score.textAlignment = NSTextAlignmentLeft;
    score.backgroundColor = [UIColor clearColor];
    score.textColor =UIColorFromRGB(0x999999);
    score.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
    if(_detailHeaderView.detailData.avg_score !=0)
    {
    score.text = [NSString stringWithFormat:@"%0.1f",_detailHeaderView.detailData.avg_score];
    }
    else
    {
    score.text = @"木有评分";
    }
    [f5f4f4bg addSubview:score];
    
    
    
    if([_friendarray count]!=0)
    {
        tabArrow.hidden = NO;
        UILabel *friendtab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-80, 0, 80, 40)];
        friendtab.textAlignment = NSTextAlignmentCenter;
        friendtab.backgroundColor = [UIColor clearColor];
        friendtab.textColor =UIColorFromRGB(0x999999);
        friendtab.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
        friendtab.text = [NSString stringWithFormat:@"好友推荐 %u",[_friendarray count]];
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
         tabArrow.hidden = YES;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showCommentWithNote:[_data.notes_list objectAtIndex:indexPath.row] Entity:_data];
}

#pragma mark - NoteCellDelegate
- (void)addNewNote:(NSNotification *)noti
{
    NSDictionary *notidata = [noti userInfo];

    NSUInteger entity_id = [[notidata valueForKeyPath:@"entity_id"]integerValue];
    
    if([notidata valueForKeyPath:@"content"])
    {
        GKNote * newnote = [notidata valueForKeyPath:@"content"];
  
    BOOL IsNewNote = YES;
    int i=0;
    if(_data.entity_id == entity_id)
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
        }
        _data.my_score = newnote.score;
        self.detailHeaderView.detailData = _data;
        if(_data.entitylike.status)
        {
            //[self.detailHeaderView.detailData save];
        }
        [self.table reloadData];
        }
    }
    else
    {
        _data.my_score = [[notidata valueForKeyPath:@"score"]integerValue];
        self.detailHeaderView.detailData = _data;
    }
}
- (void)cardLikeChange:(NSNotification *)noti
{
    NSDictionary *notidata = [noti userInfo];
    NSUInteger entity_id = [[notidata objectForKey:@"entityID"]integerValue];
    
    GKEntity * entity = self.detailHeaderView.detailData;
    if (entity_id == entity.entity_id) {
        entity.liked_count = [[notidata objectForKey:@"likeCount"] integerValue];
        entity.entitylike = [notidata objectForKey:@"likeStatus"];
        self.detailHeaderView.detailData = entity;
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
    int num = [_detailHeaderView.detailData.purchase_list count];
    if(num >5)
    {
        num = 5;
    }
    mask = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+20)];
    mask.backgroundColor = [UIColor whiteColor];
    mask.alpha = 0.5;
    [mask addTarget:self action:@selector(HideShop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mask];
    
    store = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight+20, kScreenWidth, 44+30+num*55)];
    store.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    UIButton * _cancel = [[UIButton alloc]initWithFrame:CGRectMake(10, store.frame.size.height - 37, 50, 30)];
    [_cancel setTitle:@"完成" forState:UIControlStateNormal];
    [_cancel.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
    [_cancel setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_cancel setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
    [_cancel setBackgroundImage:[[UIImage imageNamed:@"button_normal.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateNormal];
    [_cancel setBackgroundImage:[[UIImage imageNamed:@"button_normal_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateHighlighted];
    [_cancel addTarget:self action:@selector(HideShop) forControlEvents:UIControlEventTouchUpInside];
    [store addSubview:_cancel];
    
    UIImageView *H1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, store.frame.size.height - 44, kScreenWidth, 2)];
    [H1 setImage:[UIImage imageNamed:@"review_divider.png"]];
    [store addSubview:H1];
    
    UIImageView *H2 = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth, 2)];
    [H2 setImage:[UIImage imageNamed:@"review_divider.png"]];
    [store addSubview:H2];
    
 
    
    UILabel * _shop_count_label = [[UILabel alloc]initWithFrame:CGRectMake(10,0,kScreenWidth-10 ,24)];
    _shop_count_label.backgroundColor = UIColorFromRGB(0xf9f9f9);
    _shop_count_label.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _shop_count_label.textAlignment = NSTextAlignmentLeft;
    _shop_count_label.textColor = UIColorFromRGB(0x666666);
    _shop_count_label.text = [NSString stringWithFormat:@"%u家店铺有售",num];
    [store addSubview:_shop_count_label];
    
    
    int i = 0;
    for (GKShop * shop in _detailHeaderView.detailData.purchase_list) {

        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10, 35+i*55, kScreenWidth-20, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tables_single_press.png"]forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        [button.titleLabel setTextAlignment:NSTextAlignmentRight];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"￥%.2f",shop.price] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(shopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(20,5,200 ,button.frame.size.height-10)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = UIColorFromRGB(0x666666);
        name.text = shop.title;
        [button addSubview:name];
        
        UIImageView * arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        arrow.center = CGPointMake(button.frame.size.width-20, button.frame.size.height/2);
        [button addSubview:arrow];
                
        [store addSubview:button];
        i++;
        if(i>5)
        {
            break;
        }
    }
    UIImageView *H3 = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    [H3 setImage:[UIImage imageNamed:@"review_divider.png"]];
    [store addSubview:H3];
    
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:store];
    [UIView animateWithDuration:0.3 animations:^{
        store.frame = CGRectMake(0, kScreenHeight-store.frame.size.height+20, kScreenWidth,store.frame.size.height);
    }completion:^(BOOL finished) {

    }];
}
- (void)displayShop
{
    [UIView animateWithDuration:0.3 animations:^{
        store.frame = CGRectMake(0, kScreenHeight-200+20, kScreenWidth, 200);
    }completion:^(BOOL finished) {
        [store removeFromSuperview];
        [mask removeFromSuperview];
    }];
}
- (void)HideShop
{
    [UIView animateWithDuration:0.3 animations:^{
        store.frame = CGRectMake(0,  kScreenHeight+20, kScreenWidth, store.frame.size.height);
    }completion:^(BOOL finished) {
        [store removeFromSuperview];
        [mask removeFromSuperview];
    }];
}
- (void)shopButtonAction:(id)sender
{
    NSUInteger shopIndex = ((UIButton *)sender).tag;
    [UIView animateWithDuration:0.3 animations:^{
        store.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight+20);
        for (UIView *view in store.subviews) {
            view.alpha = 0;
        }
    }completion:^(BOOL finished) {
        GKShop * shop = _detailHeaderView.detailData.purchase_list[shopIndex];
        NSLog(@"%@",shop.url);
        [self showWebViewWithTaobaoUrl:shop.url];
        [store removeFromSuperview];
        [mask removeFromSuperview];
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
    GKUser *user = [[GKUser alloc ]initFromNSU];
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
- (void)showNotePostView
{
    if(_data == nil)
    {
        return;
    }
    GKNotePostViewController *VC = [[GKNotePostViewController alloc] initWithDetailData:_data];
    VC.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
    [((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [((GKNavigationController *)((GKAppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController) presentViewController:nav animated:YES completion:NULL];
    }];
}
- (void)tapPokeRoHootButtonWithNote:(id)noteobj Poke:(id)poker;
{
    GKNote * noteData = noteobj;
    UIButton * pokeBtn = poker;
    
    [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
    [GKNote pokeEntityNoteWithNoteID:noteData.note_id Block:^(NSDictionary *dict, NSError *error) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
        if (!error)
        {
            [pokeBtn setTitle:[NSString stringWithFormat:@"%u", noteData.poker_count] forState:UIControlStateNormal];
            noteData.poker_already = YES;
            pokeBtn.selected = YES;
            pokeBtn.userInteractionEnabled = NO;
            
            [GKMessageBoard hideMB];
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

@end
