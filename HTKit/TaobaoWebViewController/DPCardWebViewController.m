//
//  DPCardWebViewController.m
//  Deeppurple
//
//  Created by TingTing Du on 12-5-23.
//  Copyright (c) 2012年 妈妈清单. All rights reserved.
//

#import "DPCardWebViewController.h"
@interface DPCardWebViewController ()

- (void)initViews;

- (void)closeWebView;

- (void)goBack;

- (void)goForward;

- (void)reload;
@end

@implementation DPCardWebViewController

@synthesize data = _data;
@synthesize link = _link;
@synthesize webView = _webView,previousPageBtn = _previousPageBtn,nextPageBtn = _nextPageBtn;


- (void)initViews
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;
    
    //[self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.navigationController.toolbar setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
    self.navigationController.toolbar.tintColor = UIColorFromRGB(0xf9f9f9);

    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    // close web view button
    UIButton *closeWebBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)];
    [closeWebBtn addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [closeWebBtn setShowsTouchWhenHighlighted:YES];
    [closeWebBtn setTitle:@"完成" forState:UIControlStateNormal];
    [closeWebBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
    [closeWebBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [closeWebBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
    [closeWebBtn setBackgroundImage:[[UIImage imageNamed:@"webview_button.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateNormal];
    [closeWebBtn setBackgroundImage:[[UIImage imageNamed:@"webview_button_press.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:1 ] forState:UIControlStateHighlighted];
    UIBarButtonItem *closeWebview = [[UIBarButtonItem alloc] initWithCustomView:closeWebBtn] ;
    
    // refresh web view button
    UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [refreshBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn setShowsTouchWhenHighlighted:YES];
    [refreshBtn setImage:[UIImage imageNamed:@"webview_refresh.png"] forState:UIControlStateNormal];
    [refreshBtn setImage:[UIImage imageNamed:@"webview_refresh_press.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *refreshWebview = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    
    // previous page button
    self.previousPageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [_previousPageBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_previousPageBtn setShowsTouchWhenHighlighted:YES];
    [_previousPageBtn setImage:[UIImage imageNamed:@"webview_back.png"] forState:UIControlStateNormal];
    [_previousPageBtn setImage:[UIImage imageNamed:@"webview_back_press.png"] forState:UIControlStateDisabled];
    UIBarButtonItem *previousPage = [[UIBarButtonItem alloc] initWithCustomView:_previousPageBtn];
    [_previousPageBtn setEnabled:NO];
    if ([_webView canGoBack]) {
        [_previousPageBtn setEnabled:YES];
    }
    
    // next page button
    self.nextPageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [_nextPageBtn addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    [_nextPageBtn setShowsTouchWhenHighlighted:YES];
    [_nextPageBtn setImage:[UIImage imageNamed:@"webview_forward.png"] forState:UIControlStateNormal];
    [_nextPageBtn setImage:[UIImage imageNamed:@"webview_forward_press.png"] forState:UIControlStateDisabled];
    UIBarButtonItem *nextPage = [[UIBarButtonItem alloc] initWithCustomView:_nextPageBtn];
    [_nextPageBtn setEnabled:NO];
    if ([_webView canGoForward]) {
        [_nextPageBtn setEnabled:YES];
    }
    UIBarButtonItem * fixedSpaceBarButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButton1.width = 0.0f;
    UIBarButtonItem * fixedSpaceBarButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButton2.width = 15.0f;
    UIBarButtonItem * fixedSpaceBarButton3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButton3.width = 50.0f;
    
    self.navigationController.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self.navigationController.toolbar setBackgroundImage:[[UIImage imageNamed:@"webview_toolbar.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.toolbar setShadowImage:nil forToolbarPosition:UIToolbarPositionAny];
    [self setToolbarItems:[NSArray arrayWithObjects:fixedSpaceBarButton1, closeWebview, fixedSpaceBarButton3, previousPage, fixedSpaceBarButton2, nextPage, fixedSpaceBarButton3, refreshWebview, fixedSpaceBarButton1, nil] animated:YES];

    self.navigationController.toolbar.frame = CGRectMake(self.navigationController.toolbar.frame.origin.x,self.navigationController.toolbar.frame.origin.y, kScreenWidth, 44);
    
    
}

- (void)closeWebView
{
    self.webView.delegate = nil;
    if ([_webView isLoading]) {
        [_webView stopLoading];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)goBack
{
   [_webView goBack];
}

- (void)goForward
{
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (void)reload
{
    [_webView reload];
}

#pragma mark - Class Method

+ (DPCardWebViewController *)linksWebViewControllerWithURL:(NSURL *)url
{
    DPCardWebViewController * _webVC = [[DPCardWebViewController alloc] init];
    _webVC.link = url;
    return _webVC;
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
    self.trackedViewName = @"淘宝Wap页";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initViews];
    
    NSURLRequest * _request;
        _request = [NSURLRequest requestWithURL:_link];
    GKLog(@"link %@",_link);
    [_webView loadRequest:_request];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [GKMessageBoard hideActivity];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [GKMessageBoard showActivity];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [GKMessageBoard hideActivity];
    if ([webView canGoForward]) {
        _nextPageBtn.enabled = YES;
    }
    else {
        _nextPageBtn.enabled = NO;
    }
    if ([_webView canGoBack]) {
        _previousPageBtn.enabled = YES;
    }
    else {
        _previousPageBtn.enabled = NO;
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [GKMessageBoard hideActivity];
    GKLog(@"%@",error);
    switch (error.code) {
        case -999:
        case 101:
        case -1003:
            break;
        default:
        {
            [GKMessageBoard showMBWithText:@"加载失败" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
        }
            break;
    }


}
@end
