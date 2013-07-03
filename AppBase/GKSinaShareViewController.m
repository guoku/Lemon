//
//  GKSinaShareViewController.m
//  Grape
//
//  Created by huiter on 13-4-13.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKSinaShareViewController.h"
#import "GKWeiboFriendsViewController.h"
#import "GKAppDelegate.h"
@interface GKSinaShareViewController ()

@end

@implementation GKSinaShareViewController
{
@private
    __strong GKEntity * _detailData;
    CGFloat y;
}
@synthesize entityImageView= _entityImageView;
@synthesize avatar = _avatar;
@synthesize nickname = _nickname;
@synthesize seperatorLineImageView = _seperatorLineImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.titleView = [GKTitleView setTitleLabel:@"微博分享"];
    }
    return self;
}
- (id)initWithDetailData:(GKEntity *)data
{
    self = [super init];
    {
        _detailData = data;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.trackedViewName = @"商品微博页";
    _textView.text = [NSString stringWithFormat:@"在果库里发现「%@」",_detailData.title];
    NSURL *_imgURL = [_detailData imageURL];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"useBigImg"])
    {
        _imgURL = [NSURL URLWithString:[[_imgURL absoluteString]stringByReplacingOccurrencesOfString:@"310x310" withString:@"640x640"]];
    }
    [self.entityImageView setImageWithURL:_imgURL];
    [_textLengthLabel setText:[NSString stringWithFormat:@"%d", 140 - [self countWord:_textView.text] - 30]];
    if(110<[self countWord:_textView.text] )
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GKMessageBoard hideActivity];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFriends:) name:@"addWeiboFriend" object:nil];
}
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = kColorf9f9f9;
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    UIButton *sendBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [sendBTN setTitle:@"发送" forState:UIControlStateNormal];
    [sendBTN.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"green_btn_bg.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [sendBTN setImageEdgeInsets:UIEdgeInsetsMake(0, -20.0f, 0, 0)];
    [sendBTN addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *followBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sendBTN];
    [self.navigationItem setRightBarButtonItem:followBtnItem animated:YES];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    
    UIImageView * BgImg = [[UIImageView alloc] initWithFrame:CGRectMake(8,8,kScreenWidth-16,kScreenHeight-320)];
    [BgImg setImage:[[UIImage imageNamed:@"cell_bg_all.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:2]];
    [BgImg setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:BgImg];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15.0f,15.0f,295, BgImg.frame.size.height-65-15)];
    [_textView setKeyboardType:UIKeyboardTypeDefault];
    [_textView setReturnKeyType:UIReturnKeyDefault];
    [_textView setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [_textView setScrollEnabled:YES];
    [_textView setEditable:YES];
    [_textView becomeFirstResponder];
    [_textView setBounces:NO];
    _textView.delegate = self;
    _textView.textColor = kColor666666;
    _textView.spellCheckingType = UITextSpellCheckingTypeNo;
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:_textView];
    
    _seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,BgImg.frame.size.height-20, kScreenWidth-16, 2)];
    [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
    [self.view addSubview:_seperatorLineImageView];
    
   UILabel *noteL = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, BgImg.frame.size.height-15, self.view.frame.size.width - 40.0f, 20.0f)];
    [noteL setBackgroundColor:[UIColor clearColor]];
    [noteL setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
    [noteL setTextAlignment:UITextAlignmentLeft];
    [noteL setLineBreakMode:UILineBreakModeWordWrap];
    [noteL setNumberOfLines:2];
    [noteL setTextColor:kColor666666];
    //noteL.text = _detailData.description;
    [self.view addSubview:noteL];
    
    self.entityImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_entityImageView setFrame:CGRectMake(250, BgImg.frame.size.height-60, 50, 50)];
    [_entityImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.view addSubview:_entityImageView];
    
    
    UIImageView * _cardBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(_entityImageView.frame.origin.x - 5.0f, _entityImageView.frame.origin.y - 5.0f, _entityImageView.frame.size.width + 10.0f, _entityImageView.frame.size.height + 10.0f)];
    [_cardBgImg setImage:[[UIImage imageNamed:@"item_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    
    [self.view insertSubview:_cardBgImg belowSubview:_entityImageView];
    
    UILabel *textNumLeftL_text1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, BgImg.frame.size.height-14, 90.0f, 15.0f)];
    [textNumLeftL_text1 setBackgroundColor:[UIColor clearColor]];
    [textNumLeftL_text1 setTextColor:kColor666666];
    [textNumLeftL_text1 setText:@"还可以输入"];
    [textNumLeftL_text1 setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [textNumLeftL_text1 setShadowColor:[UIColor whiteColor]];
    [textNumLeftL_text1 setShadowOffset:CGSizeMake(0.5f, 0.5f)];
    [self.view addSubview:textNumLeftL_text1];
    
    UILabel *textNumLeftL_text2 = [[UILabel alloc] initWithFrame:CGRectMake(110.0f, textNumLeftL_text1.frame.origin.y, 120.0f, 15.0f)];
    [textNumLeftL_text2 setBackgroundColor:[UIColor clearColor]];
    [textNumLeftL_text2 setTextColor:kColor666666];
    [textNumLeftL_text2 setText:@"字"];
    [textNumLeftL_text2 setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [textNumLeftL_text2 setShadowColor:[UIColor whiteColor]];
    [textNumLeftL_text2 setShadowOffset:CGSizeMake(0.5f, 0.5f)];
    [self.view addSubview:textNumLeftL_text2];
    
    self.textLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, textNumLeftL_text1.frame.origin.y, 35.0f, 15.0f)];
    [_textLengthLabel setBackgroundColor:[UIColor clearColor]];
    [_textLengthLabel setTextAlignment:UITextAlignmentCenter];
    [_textLengthLabel setTextColor:kColor666666];
    [_textLengthLabel setFont:[UIFont fontWithName:@"Georgia" size:14.0f]];
    [_textLengthLabel setShadowColor:[UIColor whiteColor]];
    [_textLengthLabel setShadowOffset:CGSizeMake(0.5f, 0.5f)];
    [self.view addSubview:_textLengthLabel];
    
    UIButton *weiboFriendsBtn = [[UIButton alloc] initWithFrame:CGRectMake(textNumLeftL_text2.frame.origin.x + 20.0f, textNumLeftL_text2.frame.origin.y - 2.0f, 53.0f, 20.0f)] ;
    [weiboFriendsBtn setBackgroundColor:[UIColor clearColor]];
    [weiboFriendsBtn setBackgroundImage:[UIImage imageNamed:@"share_at_f.png"] forState:UIControlStateNormal];
    [weiboFriendsBtn setBackgroundImage:[UIImage imageNamed:@"share_at_f_press.png"] forState:UIControlStateHighlighted];
    [weiboFriendsBtn setTitle:@"@好友" forState:UIControlStateNormal];
    [weiboFriendsBtn setTitleColor:kColor666666 forState:UIControlStateNormal];
    [weiboFriendsBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weiboFriendsBtn.titleLabel setShadowOffset:CGSizeMake(0.5f, 0.5f)];
    [weiboFriendsBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [weiboFriendsBtn addTarget:self action:@selector(showWeiboFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboFriendsBtn];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonAction:(id)sender
{
    if ([self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)resignTextView:(id)sender
{
    [_textView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    _textLengthLabel.text = [NSString stringWithFormat:@"%d", 140 - [self countWord:_textView.text]  - 30];
    if(110<[self countWord:_textView.text] )
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}
- (void)sendButtonAction:(id)sender
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                    withAction:@"sina_share"
                                                     withLabel:nil
                                                     withValue:nil];
        [self resignTextView:nil];
    NSString *clickUrl = [NSString stringWithFormat:@" 详情 http://guoku.com/detail/%@ (分享自@果库) ",_detailData.entity_hash];
    NSString *postContent = [NSString stringWithFormat:@"%@%@",_textView.text,clickUrl];
    [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
            SinaWeibo *sinaweibo = [self sinaweibo];
            [sinaweibo requestWithURL:@"statuses/upload_url_text.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       postContent, @"status",
                                       [_detailData.imageURL absoluteString], @"url", nil]
                           httpMethod:@"POST"
                             delegate:self];
}
- (SinaWeibo *)sinaweibo
{
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [GKMessageBoard hideMB];
    if(error.code ==21315)
    {
        SinaWeibo *sinaweibo = [self sinaweibo];
        [sinaweibo logIn];
    }
    else if(error.code ==10007)
    {
        [GKMessageBoard showMBWithText:@"图片加载异常，不能进行微博分享" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
    else
    {
    [GKMessageBoard showMBWithText:[NSString stringWithFormat:@"网络错误%u",error.code] customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
    }
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [GKMessageBoard hideActivity];
    [GKMessageBoard showMBWithText:@"分享成功" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
}
- (void)showWeiboFriends:(id)sender
{
    GKWeiboFriendsViewController *weiboFriends = [[GKWeiboFriendsViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:weiboFriends];
    [self presentViewController:navi animated:YES completion:NULL];
}
- (void)addFriends:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSString *screen_name = [userInfo objectForKey:@"screen_name"];
    if (screen_name.length > 0) {
        NSString *newText = [NSString stringWithFormat:@"@%@",screen_name];
        [self addText:newText];
    }
}
- (void)addText:(NSString *)text
{
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,text];
    _textLengthLabel.text = [NSString stringWithFormat:@"%d", 140 - [self countWord:_textView.text] - 30];
    if(110<[self countWord:_textView.text] )
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}
- (int)countWord:(NSString*)s
{
    int i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}
@end
