//
//  GKUserGuideViewController.m
//  果库2.0
//
//  Created by huiter on 12-12-11.
//  Copyright (c) 2012年 果库. All rights reserved.
//

#import "GKUserGuideViewController.h"
#import "GKAppDelegate.h"
#import "GKRootViewController.h"
#import "SMPageControl.h"

#import "MMDrawerController.h"
#import "GKCenterViewController.h"
#import "GKLeftViewController.h"
#import "GKRightViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface GKUserGuideViewController ()

@end

@implementation GKUserGuideViewController
{
    @private
    UIScrollView *scrollView;
    SMPageControl *pageControl;
}

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
    UIImageView * bg = [[UIImageView alloc]initWithFrame:self.view.frame];

    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
    [bg setImage:[UIImage imageNamed:@"userguide_bg_568.png"]];
    }
    else
    {
     [bg setImage:[UIImage imageNamed:@"userguide_bg.png"]];
    }
    [self.view addSubview:bg];
    // Do any additional setup after loading the view from its nib.
    [self initGuide];//初始化引导
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark GK部分
-(void)initGuide
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,kScreenHeight)];
    [scrollView setContentSize:CGSizeMake(1280, kScreenHeight)];
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
    pageControl.center = CGPointMake(160, kScreenHeight-30);
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"pageControl_press.png"];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"pageControl.png"];
    
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 274, kScreenHeight-83)];
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        imageview1.frame = CGRectMake(0, 0, 274,imageview1.frame.size.height-20);
    }
    [imageview1 setCenter:CGPointMake(160.0f,kScreenHeight/2)];
    [imageview1 setImage:[[UIImage imageNamed:@"userguide-1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview1.userInteractionEnabled = YES;
    [scrollView addSubview:imageview1];
    /*
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:nil forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(120,kScreenHeight-44-92, 80, 37)];
    [button1 addTarget:self action:@selector(Next1) forControlEvents:UIControlEventTouchUpInside];
    [imageview1 addSubview:button1];
    */
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 274,kScreenHeight-83)];
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        imageview2.frame = CGRectMake(0, 0, 274,imageview2.frame.size.height-20);
    }
    [imageview2 setCenter:CGPointMake(160.0f+320.0f,kScreenHeight/2)];
    [imageview2 setImage:[[UIImage imageNamed:@"userguide-2.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview2.userInteractionEnabled = YES;
    [scrollView addSubview:imageview2];
    /*
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:nil forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(120,kScreenHeight-44-92, 80, 37)];
    [button2 addTarget:self action:@selector(Next2) forControlEvents:UIControlEventTouchUpInside];
    [imageview2 addSubview:button2];
    */
    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(640, 0, 274,kScreenHeight-83)];
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        imageview3.frame = CGRectMake(0, 0, 274,imageview3.frame.size.height-20);
    }
    [imageview3 setCenter:CGPointMake(160.0f+320.0f+320.0f,kScreenHeight/2)];
    [imageview3 setImage:[[UIImage imageNamed:@"userguide-3.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview3.userInteractionEnabled = YES;
    [scrollView addSubview:imageview3];
    /*
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:nil forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(120,kScreenHeight-44-92, 80, 37)];
    [button3 addTarget:self action:@selector(Next3) forControlEvents:UIControlEventTouchUpInside];
    [imageview3 addSubview:button3];
    */
    UIImageView *imageview4 = [[UIImageView alloc] initWithFrame:CGRectMake(960, 0, 274, kScreenHeight-83)];
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        imageview4.frame = CGRectMake(0, 0, 274,imageview4.frame.size.height-20);
    }
    [imageview4 setCenter:CGPointMake(160.0f+320.0f+320.0f+320.0f,kScreenHeight/2)];
    [imageview4 setImage:[[UIImage imageNamed:@"userguide-4.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(230, 10, 150, 10)]];
    imageview4.userInteractionEnabled = YES;

    [scrollView addSubview:imageview4];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:nil forState:UIControlStateNormal];
    [button setFrame:CGRectMake(92,imageview4.frame.size.height-85, 90, 36)];
    [button setCenter:CGPointMake(imageview4.frame.size.width/2, imageview4.frame.size.height-75+18)];
    [button addTarget:self action:@selector(beginInGuoku) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"进入果库" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [button setBackgroundImage:[[UIImage imageNamed:@"green_btn_bg.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [button setHidden:NO];
    [imageview4 addSubview:button];
    
    

    
    [self.view addSubview:scrollView];
    
    [self.view addSubview:pageControl];    
}

- (void)Next1
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         scrollView.contentOffset = CGPointMake(320,0);
                     }];

}
- (void)Next2
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         scrollView.contentOffset = CGPointMake(640,0);
                     }];
}
- (void)Next3
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         scrollView.contentOffset = CGPointMake(960,0);
                     }];
}

- (void)beginInGuoku
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    UIViewController * leftSideDrawerViewController = [[GKLeftViewController alloc] init];
    
    UIViewController * centerViewController = [[GKCenterViewController alloc] init];
    
    UIViewController * rightSideDrawerViewController = [[GKRightViewController alloc] init];
    
    GKNavigationController * navigationController = [[GKNavigationController alloc] initWithRootViewController:centerViewController];
    
    GKRootViewController  * drawerController = [[GKRootViewController alloc]
                                                initWithCenterViewController:navigationController
                                                leftDrawerViewController:leftSideDrawerViewController
                                                rightDrawerViewController:rightSideDrawerViewController];
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    [UIView animateWithDuration:0.8f animations:^{
          scrollView.alpha = 0;
    }completion:^(BOOL finished) {
        [(GKAppDelegate *)[[UIApplication sharedApplication] delegate] window].rootViewController =  drawerController;
    }];


}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = (scrollView.contentOffset.x +160) /320;
    pageControl.currentPage = page;
    
    if (scrollView.contentOffset.x+scrollView.frame.size.width >= scrollView.contentSize.width+50)
    {
        [self beginInGuoku];
    }
    
}
- (void) changePage:(id)sender {
    int page = pageControl.currentPage;
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];
}
@end
