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
#import "MMMTML.h"
#import "GKAppDelegate.h"



@interface GKRootViewController ()

@end

@implementation GKRootViewController
{

    @private  NSMutableArray * _dataArray;
}
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GKLogin) name: GKUserLoginNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GKLogout) name: GKUserLogoutNotification  object:nil];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)GKLogin
{

}
- (void)GKLogout
{
 
}



@end
