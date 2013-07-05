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



@interface GKRootViewController ()

@end

@implementation GKRootViewController
{
    @private  NSMutableDictionary * _dataDic;
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
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"table"])
    {
    
    }
    else
    {
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
        [MMMTML globalTMLWithBlock:^(NSDictionary * dictionary, NSArray *array,NSError *error) {
            if(!error)
            {
                    _dataArray = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                    _dataDic = [NSMutableArray arrayWithArray:array];
                
                    NSData *Data1 = [NSKeyedArchiver archivedDataWithRootObject:_dataArray];
                    NSData *Data2 = [NSKeyedArchiver archivedDataWithRootObject:_dataDic];
                    [[NSUserDefaults standardUserDefaults] setObject:Data1 forKey:@"table"];
                    [[NSUserDefaults standardUserDefaults] setObject:Data2 forKey:@"table2"];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
