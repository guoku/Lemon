//
//  GKLoginViewController.m
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKLoginViewController.h"
#import "GKAppDelegate.h"
#import "SMPageControl.h"
@interface GKLoginViewController ()
{
    @private UIButton * _sinaBtn;
        UIScrollView *scrollView;
        SMPageControl *pageControl;
    UIImageView * logo;
    UILabel * slogan;
    CGFloat y1;
    CGFloat y2;
    CGFloat y3;
    CGFloat y4;
    CGFloat y5;
    CGFloat yoffest;
    
}

@end

@implementation GKLoginViewController

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
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%f",kScreenHeight);
    if(kScreenHeight == 548)
    {
        y1 = 67;
        y2 = 13;
        y3 = 37;
        y4 = 62;
        y5 = 17;
        yoffest = 170;
    }
    else
    {
        y1 = 35;
        y2 = 9;
        y3 = 23;
        y4 = 40;
        y5 = 17;
        yoffest = 135;
    }
    
    logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo.png"]];
    NSLog(@"y1%f",y1);
    logo.frame = CGRectMake(0, y1, 132, 50);
    logo.center = CGPointMake(kScreenWidth/2,logo.center.y);
    [self.view addSubview:logo];
    
    //slogan = [[UILabel alloc]initWithFrame:CGRectMake(0, logo.frame.origin.y+logo.frame.size.height+y2, kScreenWidth, 14)];
    //slogan.textAlignment = NSTextAlignmentCenter;
    //slogan.text = @"最贴心的母婴购物指南";
    //slogan.font = [UIFont fontWithName:@"Helvetica" size:14];
    //slogan.textColor = UIColorFromRGB(0x666666);
    //slogan.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:slogan];
    
	// Do any additional setup after loading the view.
    _sinaBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, logo.frame.origin.y+logo.frame.size.height+y3,285, 42)];
    _sinaBtn.center = CGPointMake(kScreenWidth/2, _sinaBtn.center.y);
    [_sinaBtn setTitle:@"请使用新浪微博登录" forState:UIControlStateNormal];
    [_sinaBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_sinaBtn setImage:[UIImage imageNamed:@"login_icon_sina.png" ]forState:UIControlStateNormal];
    [_sinaBtn setImage:[UIImage imageNamed:@"login_icon_sina.png" ]forState:UIControlStateHighlighted];
    [_sinaBtn setBackgroundImage:[[UIImage imageNamed:@"login_button.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10 ] forState:UIControlStateNormal];
    [_sinaBtn setBackgroundImage:[[UIImage imageNamed:@"login_button_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10 ] forState:UIControlStateHighlighted];
    [_sinaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sinaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [_sinaBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    [_sinaBtn.titleLabel setTextAlignment:UITextAlignmentLeft];
    _sinaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_sinaBtn addTarget:self action:@selector(sinaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sinaBtn];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,_sinaBtn.frame.size.height+_sinaBtn.frame.origin.y, 320,kScreenHeight- (_sinaBtn.frame.size.height+_sinaBtn.frame.origin.y))];
    [scrollView setContentSize:CGSizeMake(1600, 200)];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView setPagingEnabled:YES];
    [scrollView setBounces:YES];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.minimumZoomScale = 0.5f;
    
    pageControl = [[SMPageControl alloc] init];
    pageControl.frame = CGRectMake(100,kScreenHeight-210, 120, 20);
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"login_icon_press.png"];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"login_icon.png"];
    
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    
    UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(0,y4, kScreenWidth, 14)];
    title1.textAlignment = NSTextAlignmentCenter;
    title1.text = @"欢迎使用妈妈清单";
    title1.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    title1.textColor = UIColorFromRGB(0x898989);
    title1.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:title1];
    
    UILabel * title2 = [[UILabel alloc]initWithFrame:CGRectMake(320,y4, kScreenWidth, 14)];
    title2.textAlignment = NSTextAlignmentCenter;
    title2.text = @"明确各阶段需求";
    title2.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    title2.textColor = UIColorFromRGB(0x898989);
    title2.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:title2];
    
    UILabel * title3 = [[UILabel alloc]initWithFrame:CGRectMake(640,y4, kScreenWidth, 14)];
    title3.textAlignment = NSTextAlignmentCenter;
    title3.text = @"看看朋友们选什么";
    title3.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    title3.textColor = UIColorFromRGB(0x898989);
    title3.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:title3];
    
    UILabel * title4 = [[UILabel alloc]initWithFrame:CGRectMake(960, y4, kScreenWidth, 14)];
    title4.textAlignment = NSTextAlignmentCenter;
    title4.text = @"看看大家的评价";
    title4.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    title4.textColor = UIColorFromRGB(0x898989);
    title4.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:title4];
    
    UILabel * title5 = [[UILabel alloc]initWithFrame:CGRectMake(1280, y4, kScreenWidth, 14)];
    title5.textAlignment = NSTextAlignmentCenter;
    title5.text = @"一键收藏心仪商品，为你追踪价格";
    title5.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    title5.textColor = UIColorFromRGB(0x898989);
    title5.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:title5];
    
    UILabel * content1 = [[UILabel alloc]initWithFrame:CGRectMake(0+30, y4+20, kScreenWidth-60, 15)];
    content1.numberOfLines = 0;
    content1.textAlignment = NSTextAlignmentCenter;
    content1.text = @"买东西不再困惑，给自己与宝贝最恰当的宠爱。";
    content1.font = [UIFont fontWithName:@"Helvetica" size:12];
    content1.textColor = UIColorFromRGB(0xbbbbbb);
    content1.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content1];
    
    UILabel * content2 = [[UILabel alloc]initWithFrame:CGRectMake(320+35, y4+20, kScreenWidth-65, 30)];
    content2.numberOfLines = 0;
    content2.textAlignment = NSTextAlignmentCenter;
    content2.text = @"从准备怀孕到宝宝 3 岁，每个阶段的购物清单专业细致，一目了然。";
    content2.font = [UIFont fontWithName:@"Helvetica" size:12];
    content2.textColor = UIColorFromRGB(0xbbbbbb);
    content2.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content2];
    
    UILabel * content3 = [[UILabel alloc]initWithFrame:CGRectMake(640+35, y4+20, kScreenWidth-65, 30)];
    content3.numberOfLines = 0;
    content3.textAlignment = NSTextAlignmentCenter;
    content3.text = @"东西一多就不知道买什么，先看看朋友们怎么选，贴心又放心。";
    content3.font = [UIFont fontWithName:@"Helvetica" size:12];
    content3.textColor = UIColorFromRGB(0xbbbbbb);
    content3.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content3];
    
    UILabel * content4 = [[UILabel alloc]initWithFrame:CGRectMake(960+35, y4+20, kScreenWidth-65, 30)];
    content4.numberOfLines = 0;
    content4.textAlignment = NSTextAlignmentCenter;
    content4.text = @"东西好不好，安全不安全，用过的妈妈来评价。看看选选心中有数。";
    content4.font = [UIFont fontWithName:@"Helvetica" size:12];
    content4.textColor = UIColorFromRGB(0xbbbbbb);
    content4.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content4];
    
    UILabel * content5 = [[UILabel alloc]initWithFrame:CGRectMake(1280+35, y4+20, kScreenWidth-65, 30)];
    content5.numberOfLines = 0;
    content5.textAlignment = NSTextAlignmentCenter;
    content5.text = @"找到心仪商品，不一定第一时间出手，提前收藏，省钱更省心！";
    content5.font = [UIFont fontWithName:@"Helvetica" size:12];
    content5.textColor = UIColorFromRGB(0xbbbbbb);
    content5.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content5];
    
    pageControl.center = CGPointMake(pageControl.center.x ,content5.frame.origin.y+content5.frame.size.height+y5+scrollView.frame.origin.y);
    //pageControl.center = CGPointMake(pageControl.center.x ,content5.frame.origin.y+content5.frame.size.height+y5+10);

    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, scrollView.frame.size.height-190, kScreenWidth, 190)];
    [imageview1 setCenter:CGPointMake(160.0f,imageview1.center.y)];
    [imageview1 setImage:[[UIImage imageNamed:@"login_Introduction_1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview1.userInteractionEnabled = YES;
    [scrollView addSubview:imageview1];

    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, scrollView.frame.size.height-190, kScreenWidth, 190)];

    [imageview2 setCenter:CGPointMake(160.0f+320.0f,imageview2.center.y)];
    [imageview2 setImage:[[UIImage imageNamed:@"login_Introduction_2.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview2.userInteractionEnabled = YES;
    [scrollView addSubview:imageview2];

    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(640, scrollView.frame.size.height-190, kScreenWidth, 190)];

    [imageview3 setCenter:CGPointMake(160.0f+320.0f+320.0f,imageview3.center.y)];
    [imageview3 setImage:[[UIImage imageNamed:@"login_Introduction_3.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview3.userInteractionEnabled = YES;
    [scrollView addSubview:imageview3];

    UIImageView *imageview4 = [[UIImageView alloc] initWithFrame:CGRectMake(960, scrollView.frame.size.height-190, kScreenWidth, 190)];
    [imageview4 setCenter:CGPointMake(160.0f+320.0f+320.0f+320.0f,imageview4.center.y)];
    [imageview4 setImage:[[UIImage imageNamed:@"login_Introduction_4.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview4.userInteractionEnabled = YES;
    
    [scrollView addSubview:imageview4];
    
    UIImageView *imageview5 = [[UIImageView alloc] initWithFrame:CGRectMake(960, scrollView.frame.size.height-190, kScreenWidth, 190)];
    [imageview5 setCenter:CGPointMake(160.0f+320.0f+320.0f+320.0f+320.f,imageview4.center.y)];
    [imageview5 setImage:[[UIImage imageNamed:@"login_Introduction_5.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview5.userInteractionEnabled = YES;
    
    [scrollView addSubview:imageview5];
    
    [self.view addSubview:scrollView];
    
    [self.view addSubview:pageControl];
    [self HideSomething];
    

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    logo.center = CGPointMake(logo.center.x, yoffest+25);
    
    [self performSelector:@selector(work) withObject:nil afterDelay:3];
    
}
- (void)work
{
    [UIView animateWithDuration:1.2 animations:^{
        logo.center = CGPointMake(kScreenWidth/2,y1+25);
    } completion:^(BOOL finished) {
        [self showEverything];
    }];

}
- (void)HideSomething
{
    _sinaBtn.hidden = YES;
    pageControl.hidden = YES;
    scrollView.hidden = YES;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-190, kScreenWidth, 190)];
    [imageview setImage:[UIImage imageNamed:@"login_Introduction_1.png"]];
    imageview.userInteractionEnabled = YES;
    imageview.tag = 2008;
    [self.view addSubview:imageview];

}
- (void)showEverything
{

    
    _sinaBtn.alpha = 0;
    pageControl.hidden = 0;
    scrollView.hidden = 0;
    [UIView animateWithDuration:1 animations:^{
        _sinaBtn.alpha = 1;
        pageControl.hidden = 1;
        scrollView.hidden = 1;
    }];
    
    _sinaBtn.hidden = NO;
    pageControl.hidden = NO;
    scrollView.hidden = NO;
    [[self.view viewWithTag:2008]removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sinaBtnAction
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"AcountAction"
                                                    withAction:@"try_login_sina"
                                                     withLabel:nil
                                                     withValue:nil];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"YES" forKey:@"isWantToLoginWithSina"];
    GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.sinaweibo logIn];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = (scrollView.contentOffset.x +160) /320;
    pageControl.currentPage = page;
    
}
- (void) changePage:(id)sender {
    int page = pageControl.currentPage;
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];
}

@end
