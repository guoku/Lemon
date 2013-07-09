//
//  GKLoadingViewController.m
//  MMM
//
//  Created by huiter on 13-7-10.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKLoadingViewController.h"
#import "GKAppDelegate.h"

@interface GKLoadingViewController ()

@end

@implementation GKLoadingViewController
{
@private
    UIImageView * logo;
    CGFloat y1;
    CGFloat yoffest;
    
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
    if(kScreenHeight == 548)
    {
        y1 = 67;
        yoffest = 170;
    }
    else
    {
        y1 = 35;
        yoffest = 135;
    }
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    
    logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo.png"]];
    logo.frame = CGRectMake(0, y1, 140, 55);
    logo.center = CGPointMake(kScreenWidth/2-0.5,logo.center.y);
    [self.view addSubview:logo];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-190, kScreenWidth, 190)];
    [imageview setImage:[UIImage imageNamed:@"login_Introduction_1.png"]];
    imageview.userInteractionEnabled = YES;
    imageview.tag = 2008;
    [self.view addSubview:imageview];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    logo.center = CGPointMake(logo.center.x, yoffest+55/2);
    
    logo.hidden = NO;
    
    [self performSelector:@selector(showEverything) withObject:nil afterDelay:0.3];
}
- (void)showEverything
{

    [UIView animateWithDuration:0.6 animations:^{
        //logo.center = CGPointMake(logo.center.x,y1+55/2);
        logo.center = CGPointMake(logo.center.x,-55);
        logo.alpha = 0;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:2008]removeFromSuperview];
        GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                
            }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
