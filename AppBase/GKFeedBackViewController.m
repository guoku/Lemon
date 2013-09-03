//
//  GKFeedBackViewController.m
//  Grape
//
//  Created by huiter on 13-4-3.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKFeedBackViewController.h"
#import "GKFeedback.h"

@interface GKFeedBackViewController ()

@end

@implementation GKFeedBackViewController
@synthesize textView = _textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    
    UIButton *sendBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 32)];
    [sendBTN setTitle:@"发送" forState:UIControlStateNormal];
    [sendBTN.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [sendBTN addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *followBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sendBTN];
    [self.navigationItem setRightBarButtonItem:followBtnItem animated:YES];
    
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"意见反馈"];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.trackedViewName = @"意见页";
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, self.view.frame.size.width - 40.0f, 100.0f)];
    [_textView setKeyboardType:UIKeyboardTypeDefault];
    [_textView setReturnKeyType:UIReturnKeyDefault];
    [_textView setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    [_textView setScrollEnabled:YES];
    [_textView setEditable:YES];
    [_textView.layer setCornerRadius:6.0f];
    _textView.layer.borderColor = [[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f] CGColor];
    _textView.layer.borderWidth = 1.0f;
    [_textView becomeFirstResponder];
    [_textView setBounces:NO];

    _textView.spellCheckingType = UITextSpellCheckingTypeNo;
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self.view addSubview:_textView];
    
    UILabel *noteL = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 115.0f, self.view.frame.size.width - 40.0f, 40.0f)];
    [noteL setBackgroundColor:[UIColor clearColor]];
    [noteL setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    [noteL setTextAlignment:NSTextAlignmentLeft];
    [noteL setLineBreakMode:NSLineBreakByWordWrapping];
    [noteL setNumberOfLines:2];
    //[noteL setTextColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f]];
    [noteL setTextColor:UIColorFromRGB(0x999999)];
    noteL.text = @"欢迎吐槽，不要忘了留下自己的联系方式。亦可在新浪微博上 @妈妈清单某工程师 进行投诉。";
    [self.view addSubview:noteL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendButtonAction:(id)sender
{
    GKLog(@"feed back %@", _textView.text);
    if(_textView.text.length == 0)
    {
        [GKMessageBoard showMBWithText:@"还没有写意见反馈呢" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
        return;
    }
    if(_textView.text.length <10)
    {
        [GKMessageBoard showMBWithText:@"请输入10个字以上" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
        return;
    }
    [GKFeedback postFeedBackWittContent:_textView.text Block:^(BOOL is_success, NSError *error) {
        if (!error)
        {
             [GKMessageBoard showMBWithText:@"反馈成功" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2]; 
            [self.navigationController popViewControllerAnimated:YES];
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
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
