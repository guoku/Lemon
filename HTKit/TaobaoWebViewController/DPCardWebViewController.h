//
//  DPCardWebViewController.h
//  Deeppurple
//
//  Created by TingTing Du on 12-5-23.
//  Copyright (c) 2012年 果库. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
@interface DPCardWebViewController : GKBaseViewController<UIWebViewDelegate>

{
    NSDictionary *_data;
    NSURL * _link;
    UIWebView *_webView;
    UIButton *_previousPageBtn;
    UIButton *_nextPageBtn;
}
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSURL * link;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *previousPageBtn;
@property (nonatomic, strong) UIButton *nextPageBtn;
+ (DPCardWebViewController *)linksWebViewControllerWithURL:(NSURL *)url;
@end
