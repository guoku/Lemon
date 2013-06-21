//
//  GKUserViewController.m
//  AppBase
//
//  Created by huiter on 13-6-6.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserViewController.h"

@interface GKUserViewController ()

@end

@implementation GKUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUserID:(NSUInteger)user_id
{
    self = [super init];
    {
        _user_id = user_id;        
    }
    return self;
}
- (id)initWithData:(GKUser *)data
{
    self = [super init];
    {
        if ([data isKindOfClass:[GKUser class]])
        {
            _user_id = data.user_id;
            _user = data;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
