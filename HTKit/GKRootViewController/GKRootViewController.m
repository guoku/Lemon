//
//  GKRootViewController.m
//  Grape
//
//  Created by huiter on 13-3-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKRootViewController.h"
#import "MMDrawerController.h"
#import "GKCenterViewController.h"
#import "GKLeftViewController.h"
#import "GKRightViewController.h"
#import "MMExampleDrawerVisualStateManager.h"



@interface GKRootViewController ()

@end

@implementation GKRootViewController
//@synthesize tabVC = _tabVC;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
	// Do any additional setup after loading the view.
    //self.tabVC = [[GKTabViewController alloc]init];
    
    //[self addChildViewController:_tabVC];
    //[self.view addSubview:_tabVC.view];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
