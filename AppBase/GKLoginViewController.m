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
    CGFloat y1;
    CGFloat y2;
    CGFloat y3;
    CGFloat y4;
    
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
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%f",kScreenHeight);
    if(kScreenHeight == 548)
    {
        y1 = 67;
        y2 = 13;
        y3 = 37;
        y4 = 32;
    }
    else
    {
        y1 = 35;
        y2 = 9;
        y3 = 23;
        y4 = 27;
    }
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    NSLog(@"y1%f",y1);
    logo.frame = CGRectMake(0, y1, 136, 31);
    logo.center = CGPointMake(kScreenWidth/2,logo.center.y);
    [self.view addSubview:logo];
    
    UILabel * slogan = [[UILabel alloc]initWithFrame:CGRectMake(0, logo.frame.origin.y+logo.frame.size.height+y2, kScreenWidth, 14)];
    slogan.textAlignment = NSTextAlignmentCenter;
    slogan.text = @"记录点点滴滴";
    slogan.font = [UIFont fontWithName:@"Helvetica" size:14];
    slogan.textColor = UIColorFromRGB(0x666666);
    slogan.backgroundColor = [UIColor clearColor];
    [self.view addSubview:slogan];
    
	// Do any additional setup after loading the view.
    _sinaBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, slogan.frame.origin.y+slogan.frame.size.height+y3,285, 42)];
    _sinaBtn.center = CGPointMake(kScreenWidth/2, _sinaBtn.center.y);
    [_sinaBtn setTitle:@"新浪微博登录" forState:UIControlStateNormal];
    [_sinaBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_sinaBtn setImage:[UIImage imageNamed:@"icon_sina.png" ]forState:UIControlStateNormal];
    [_sinaBtn setImage:[UIImage imageNamed:@"icon_sina.png" ]forState:UIControlStateHighlighted];
    [_sinaBtn setBackgroundImage:[[UIImage imageNamed:@"red_button.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10 ] forState:UIControlStateNormal];
    [_sinaBtn setBackgroundImage:[[UIImage imageNamed:@"red_button_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10 ] forState:UIControlStateHighlighted];
    [_sinaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sinaBtn.titleLabel setTextAlignment:UITextAlignmentLeft];
    _sinaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_sinaBtn addTarget:self action:@selector(sinaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sinaBtn];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,_sinaBtn.frame.size.height+_sinaBtn.frame.origin.y, 320,kScreenHeight- (_sinaBtn.frame.size.height+_sinaBtn.frame.origin.y))];
    [scrollView setContentSize:CGSizeMake(1280, 200)];
    //scrollView.backgroundColor = [UIColor colorWithRed:39.0f / 255.0f green:39.0f / 255.0f blue:39.0/ 255.0f alpha:1.0f];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView setPagingEnabled:YES];
    [scrollView setBounces:YES];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.minimumZoomScale = 0.5f;
    
    pageControl = [[SMPageControl alloc] init];
    pageControl.frame = CGRectMake(100,kScreenHeight-40, 120, 20);
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"pageControl_press.png"];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"pageControl.png"];
    
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    
    UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(0,y4, kScreenWidth, 14)];
    title1.textAlignment = NSTextAlignmentCenter;
    title1.text = @"记录点点滴滴";
    title1.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    title1.textColor = UIColorFromRGB(0x898989);
    title1.backgroundColor = [UIColor clearColor];
    //[scrollView addSubview:title1];
    
    UILabel * title2 = [[UILabel alloc]initWithFrame:CGRectMake(320,y4, kScreenWidth, 14)];
    title2.textAlignment = NSTextAlignmentCenter;
    title2.text = @"各个阶段该买什么，一目了然";
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
    
    UILabel * content1 = [[UILabel alloc]initWithFrame:CGRectMake(0+30, y4+24, kScreenWidth-60, 40)];
    content1.center = CGPointMake(kScreenWidth/2, 140);
    content1.numberOfLines = 0;
    content1.textAlignment = NSTextAlignmentCenter;
    content1.text = @"记录点点滴滴";
    content1.font = [UIFont fontWithName:@"Helvetica" size:12];
    content1.textColor = UIColorFromRGB(0xbbbbbb);
    content1.backgroundColor = [UIColor clearColor];
    //[scrollView addSubview:content1];
    
    UILabel * content2 = [[UILabel alloc]initWithFrame:CGRectMake(320+30, y4+24, kScreenWidth-60, 40)];
    content2.numberOfLines = 0;
    content2.textAlignment = NSTextAlignmentCenter;
    content2.text = @"从准备怀孕到宝宝3岁，每个阶段细致专业的购物清单，一目了然。";
    content2.font = [UIFont fontWithName:@"Helvetica" size:12];
    content2.textColor = UIColorFromRGB(0xbbbbbb);
    content2.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content2];
    
    UILabel * content3 = [[UILabel alloc]initWithFrame:CGRectMake(640+30, y4+24, kScreenWidth-60, 40)];
    content3.numberOfLines = 0;
    content3.textAlignment = NSTextAlignmentCenter;
    content3.text = @"东西一多就不知道买什么，先看看朋友们选什么，贴心又放心。";
    content3.font = [UIFont fontWithName:@"Helvetica" size:12];
    content3.textColor = UIColorFromRGB(0xbbbbbb);
    content3.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content3];
    
    UILabel * content4 = [[UILabel alloc]initWithFrame:CGRectMake(960+30, y4+24, kScreenWidth-60, 40)];
    content4.numberOfLines = 0;
    content4.textAlignment = NSTextAlignmentCenter;
    content4.text = @"东西好不好，安全不安全，用过的妈妈来评价。看看选选心中有数。";
    content4.font = [UIFont fontWithName:@"Helvetica" size:12];
    content4.textColor = UIColorFromRGB(0xbbbbbb);
    content4.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content4];
    
    
    pageControl.center = CGPointMake(160, _sinaBtn.frame.origin.y+_sinaBtn.frame.size.height+85);
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, scrollView.frame.size.height-200, kScreenWidth, 200)];
    [imageview1 setCenter:CGPointMake(160.0f,imageview1.center.y)];
    [imageview1 setImage:[[UIImage imageNamed:@"1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview1.userInteractionEnabled = YES;
    [scrollView addSubview:imageview1];

    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, scrollView.frame.size.height-200, kScreenWidth, 200)];

    [imageview2 setCenter:CGPointMake(160.0f+320.0f,imageview2.center.y)];
    [imageview2 setImage:[[UIImage imageNamed:@"2.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview2.userInteractionEnabled = YES;
    [scrollView addSubview:imageview2];

    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(640, scrollView.frame.size.height-200, kScreenWidth, 200)];

    [imageview3 setCenter:CGPointMake(160.0f+320.0f+320.0f,imageview3.center.y)];
    [imageview3 setImage:[[UIImage imageNamed:@"3.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview3.userInteractionEnabled = YES;
    [scrollView addSubview:imageview3];

    UIImageView *imageview4 = [[UIImageView alloc] initWithFrame:CGRectMake(960, scrollView.frame.size.height-200, kScreenWidth, 200)];
    [imageview4 setCenter:CGPointMake(160.0f+320.0f+320.0f+320.0f,imageview4.center.y)];
    [imageview4 setImage:[[UIImage imageNamed:@"4.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview4.userInteractionEnabled = YES;
    
    [scrollView addSubview:imageview4];
    
 
    
    
    
    
    [self.view addSubview:scrollView];
    
    //[self.view addSubview:pageControl];

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
