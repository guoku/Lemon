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
    GKNote * _note;
    CGFloat score;
    GKEntityLike *entityLike;
    NSMutableDictionary * _message;
    UILabel * label;
}
@synthesize data = _data;
@synthesize ratingView = _ratingView;
@synthesize seperatorLineImageView = _seperatorLineImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _message = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (id)initWithDetailData:(GKDetail *)data
{
    self = [super init];
    {
        _data = data;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"添加点评页";
    

    [self setViewText];
    
}
-(void)setViewText
{
    [self.ratingView displayRating:_data.my_score/2];
    GKUser *user = [[GKUser alloc] initFromNSU];

    for (GKNote * note in _data.notes_list) {
        if(note.creator.user_id == user.user_id)
        {
            _note = note;
            self.textView.text = note.note;
            label.hidden = NO;
            break;
        }
    }
}
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor =UIColorFromRGB(0xf9f9f9);
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    UIButton *sendBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 32)];
    [sendBTN setTitle:@"保存" forState:UIControlStateNormal];
    [sendBTN.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [sendBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [sendBTN setImageEdgeInsets:UIEdgeInsetsMake(0, -20.0f, 0, 0)];
    [sendBTN addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *followBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sendBTN];
    [self.navigationItem setRightBarButtonItem:followBtnItem animated:YES];
    
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"使用评价"];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);    
    
    self.ratingView = [[RatingView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_ratingView setImagesDeselected:@"star_l.png" partlySelected:@"star_l_half.png" fullSelected:@"star_l_full.png" andDelegate:self];
    _ratingView.center = CGPointMake(160, 20);
    [self.view addSubview:_ratingView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, _ratingView.frame.origin.y+_ratingView.frame.size.height, kScreenWidth, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    label.textColor = UIColorFromRGB(0x666666);
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
    _textView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    _textView.textColor = UIColorFromRGB(0x666666);
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
    if (newRating !=0) {
        label.hidden = YES;
    }
    else
    {
        label.hidden = NO;
    }
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
        score = _ratingView.rating;
        score = score * 2;
        [self submit];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1)
    {
        if([alertView isKindOfClass:[GKAlertView class]])
        {
            score = ((GKAlertView *)alertView).ratingView.rating;
            score = score * 2;
            [self submit];
        }
    }
}
- (void)submit
{
    NSUInteger  note_id = 0;
    if (_note)
    {
        note_id = _note.note_id;
    }
    [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
    [GKNote postEntityNoteWithEntityID:_data.entity_id NoteID:note_id Score:score Content:_textView.text Block:^(NSDictionary *note, NSError *error) {
        if(!error)
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
            [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                            withAction:@"add_note"
                                                             withLabel:nil
                                                             withValue:nil];
            
                _textView.text = nil;
                [GKMessageBoard showMBWithText:@"点评成功" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
                [self dismissViewControllerAnimated:YES completion:NULL];
            
            entityLike = [note valueForKeyPath:@"like_content"];
            if(_data.my_score)
            {
                CGFloat sum = (_data.avg_score *_data.score_user_num) - _data.my_score + score;
                _data.avg_score = sum/_data.score_user_num;
                _data.my_score = score;
            }
            else
            {
                CGFloat sum = (_data.avg_score *_data.score_user_num) + score;
                _data.score_user_num ++;
                _data.avg_score = sum/_data.score_user_num;
                _data.my_score = score;
            }
            if(entityLike.status)
            {
                _data.liked_count ++;
            }
            GKEntity * entity = (GKEntity *)_data;
            for(NSString  * pidString in entity.pid_list ) {
                entity.pid = [pidString integerValue];
                if(entity.entitylike.status)
                {
                    [entity save];
                }
            }
            if((entityLike.status)&&(!_data.entitylike.status))
            {
                _data.entitylike = entityLike;
                [_message setValue:@(_data.entity_id) forKey:@"entityID"];
                [_message setValue:@(_data.liked_count) forKey: @"likeCount"];
                [_message setValue:_data.entitylike forKey:@"likeStatus"];
                [_message setValue:_data forKey:@"entity"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGKN_EntityLikeChange object:nil userInfo:_message];
            }
            else
            {
                [_message setValue:@(_data.entity_id) forKey:@"entityID"];
                [_message setValue:_data forKey:@"entity"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGKN_EntityChange object:nil userInfo:_message];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GKAddNewNoteNotification object:nil userInfo:note];
            

          
        }
        else
        {
            switch (error.code) {
                case -999:
                    [GKMessageBoard hideMB];
                    break;
                case kUserSessionError:
                {
                    [GKMessageBoard hideMB];
                }
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
@end

