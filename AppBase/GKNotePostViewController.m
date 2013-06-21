//
//  GKNotePostViewController.m
//  Grape
//
//  Created by huiter on 13-4-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNotePostViewController.h"
#import "GKAlertView.h"
@interface GKNotePostViewController ()

@end

@implementation GKNotePostViewController
{
@private
    CGFloat y;    
}
@synthesize ratingView = _ratingView;
@synthesize seperatorLineImageView = _seperatorLineImageView;

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
    self.trackedViewName = @"添加点评页";
    [self setFooterViewText];
    
}
-(void) setFooterViewText
{
    
}
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = kColorf9f9f9;
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backBTN setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBTN setImageEdgeInsets:UIEdgeInsetsMake(0, -20.0f, 0, 0)];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBTN];
    [self.navigationItem setLeftBarButtonItem:back animated:YES];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIButton *sendBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [sendBTN setTitle:@"保存" forState:UIControlStateNormal];
    [sendBTN.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"green_btn_bg.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [sendBTN setImageEdgeInsets:UIEdgeInsetsMake(0, -20.0f, 0, 0)];
    [sendBTN addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *followBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sendBTN];
    [self.navigationItem setRightBarButtonItem:followBtnItem animated:YES];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);    
    
    self.ratingView = [[RatingView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_ratingView setImagesDeselected:@"star_l.png" partlySelected:@"star_l_half.png" fullSelected:@"star_l_full.png" andDelegate:self];
    _ratingView.center = CGPointMake(160, 20);
    [self.view addSubview:_ratingView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, _ratingView.frame.origin.y+_ratingView.frame.size.height, kScreenWidth, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    label.textColor = kColor666666;
    label.text = @"轻点星形来评分";
    [self.view addSubview:label];
    
    self.seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,label.frame.origin.y+label.frame.size.height, kScreenWidth, 2)];
    [_seperatorLineImageView setImage:[UIImage imageNamed:@"splitline.png"]];
    [self.view addSubview:_seperatorLineImageView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0,_seperatorLineImageView.frame.origin.y+_seperatorLineImageView.frame.size.height,kScreenWidth,kScreenHeight-320-65-15)];
    [_textView setKeyboardType:UIKeyboardTypeDefault];
    [_textView setReturnKeyType:UIReturnKeyDefault];
    [_textView setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [_textView setScrollEnabled:YES];
    [_textView setEditable:YES];
    [_textView becomeFirstResponder];
    [_textView setBounces:NO];
    _textView.textColor = kColor666666;
    _textView.spellCheckingType = UITextSpellCheckingTypeNo;
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self.view addSubview:_textView];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ratingChanged:(float)newRating {

}
-(void)resignTextView:(id)sender
{
    [_textView resignFirstResponder];
}
- (void)sendButtonAction:(id)sender
{
    if(_ratingView.rating == 0)
    {
        GKAlertView *alertView = [[GKAlertView alloc] initWithTitle:@"请评分" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
        
        [alertView show];        
    }
    else
    {
        NSLog(@"%f",_ratingView.rating);
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1)
    {
        if([alertView isKindOfClass:[GKAlertView class]])
        {
            NSLog(@"%f",((GKAlertView *)alertView).ratingView.rating);
        }
    }
}
@end

