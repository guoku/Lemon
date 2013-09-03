//
//  GKNavigationController.m
//  Grape
//
//  Created by huiter on 13-3-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNavigationController.h"
#import "UIResponder+MotionRecognizers.h"
#import "AudioToolbox/AudioToolbox.h"
#import "GKAppDotNetAPIClient.h"

@interface GKNavigationController ()

@end

@implementation GKNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        gestureRecognizer.numberOfTouchesRequired = 1;
        [self.view addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addMotionRecognizerWithAction:@selector(motionWasRecognized:)];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeMotionRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleSwipeGesture:(id)sender
{
    //[[[GKAppDotNetAPIClient sharedClient]operationQueue]cancelAllOperations];
    if ([self.viewControllers count]>1) {
        [self popViewControllerAnimated:YES];
    }
    else
    {
        //[self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)pop
{
    if([self.viewControllers count]>1)
    {
        [GKMessageBoard showMBWithText:kGK_PopSucceedText customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
        [self popToRootViewControllerAnimated:YES];
    }
    else
    {
        [GKMessageBoard showMBWithText:kGK_PopFailText customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
        [self popToRootViewControllerAnimated:YES];
    }
}

- (void) motionWasRecognized:(NSNotification*)notif {
    /*
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"妈妈清单小提示：\n摇晃设备可迅速返回最上层" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"返回最上层", nil];
    [alertView show];
     */
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self pop];
    }
}
@end
