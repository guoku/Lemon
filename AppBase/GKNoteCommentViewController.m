//
//  GKNoteCommentViewController.m
//  Grape
//
//  Created by huiter on 13-3-30.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNoteCommentViewController.h"
#import "GKAppDelegate.h"
#import "GKNoteCommentCell.h"
#import "GKComment.h"
#import "GKUserViewController.h"
#import "GKNoteCommentHeaderView.h"
#import "NSString+GKHelper.h"
#import "GKUser.h"
@interface GKNoteCommentViewController ()


@end

@implementation GKNoteCommentViewController
{
@private
    __strong NSMutableDictionary * _message;
    NSMutableArray * _dataArray;
    __strong GKComment * _notecomment;
    __strong GKUser * _user;
    CGFloat headheight;
}
@synthesize note = _note;
@synthesize entity = _entity;
@synthesize table = _table;
@synthesize headerView = _headerView;
@synthesize mask = _mask;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNote:(GKNote *)note Entity:(GKEntity *)entity;
{
    self = [super init];
    {
        _note = note;
        _entity = entity;
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    
    UIButton *backBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateNormal];
    [backBTN setImage:[UIImage imageNamed:@"button_icon_back.png"] forState:UIControlStateHighlighted];
    UIEdgeInsets insets = UIEdgeInsetsMake(10,10, 10, 10);
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:insets]forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[[UIImage imageNamed:@"button_press.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    [backBTN addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
    UIButton *refreshBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [refreshBTN setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
    [refreshBTN addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBTN];
    
    self.navigationItem.titleView = [GKTitleView setTitleLabel:@"评论"];
    self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44 -40) style:UITableViewStylePlain];
    _table.backgroundColor = UIColorFromRGB(0xf6f6f6);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = NO;
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
        view.delegate = self;
        _refreshHeaderView = view;
        [self.table addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    self.headerView = [[GKNoteCommentHeaderView alloc]initWithFrame:CGRectZero];
    headheight = [GKNoteCommentHeaderView height:_note];
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, headheight);

    _headerView.delegate = self;
    [self.headerView setNoteData:_note entityData:_entity];
    self.table.tableHeaderView = [[UIView alloc]initWithFrame:_headerView.frame];
    [self.table.tableHeaderView addSubview:_headerView];
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(13, 6, 240, 29)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 2;
	textView.returnKeyType = UIReturnKeyDefault; //just as an example
	textView.font = [UIFont fontWithName:@"Helvetica" size:12];
    textView.textColor = UIColorFromRGB(0x666666);
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor clearColor];
    
    textView.text = @"评论";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"comment_input.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(13, 6, 240, 29);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"input.png"];
    UIImage *background = rawBackground;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:entryImageView];
    [containerView addSubview:textView];
  
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"button_green.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 58, 6, 50, 29);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)reload:(id)sender
{
    [GKComment globalNoteCommetWithNoteID:_note.note_id Block:^(NSArray *comment_list, NSError *error) {
        if(!error)
        {
            _dataArray = [NSMutableArray arrayWithArray:comment_list];
            GKLog(@"%@", _dataArray);
            [self.table reloadData];
           
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
        [self doneLoadingTableViewData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"点评评论页";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewNoteComment:) name:GKAddNewNoteCommentNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNoteComment:) name:GKDeleteNoteCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	// Do any additional setup after loading the view.
    [self reload:nil];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKAddNewNoteCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKDeleteNoteCommentNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self resignTextView:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (void)addNewNoteComment:(NSNotification *)noti
{
    NSDictionary *notidata = [noti userInfo];
//    NSUInteger note_id = [[notidata objectForKey:@"noteID"]integerValue];
    GKComment * _comment = [notidata valueForKeyPath:@"content"];
    if(_comment.note_id == _note.note_id)
    {
        _note.comment_count += 1;
//        _note.comment_count = [[notidata objectForKey:@"noteCommentCount"]integerValue];
        self.headerView.noteData = _note;
        [_dataArray addObject:_comment];
        [self.table reloadData];
    }
}
- (void)deleteNoteComment:(NSNotification *)noti
{
    NSDictionary *notidata = [noti userInfo];
//    GKLog(@"%@", notidata);
//    NSUInteger note_id = [[notidata objectForKey:@"noteID"]integerValue];
    NSUInteger note_comment_id = [[notidata valueForKeyPath:@"note_comment_id"] integerValue];
//    if(note_id == _note.note_id)
//    {
////        _note.comment_count = [[notidata objectForKey:@"noteCommentCount"]integerValue];
        _note.comment_count -= 1;
        self.headerView.noteData = _note;
//
        NSLock *lock = [[NSLock alloc] init];

        //线程1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [lock lock];
            int i =0;
            for (GKComment * note_comment in _dataArray)
            {
                
                if (note_comment.comment_id == note_comment_id) {
                    [_dataArray removeObjectAtIndex:i];
                    break;
                }
                i++;
            }
            [lock unlock];
        });
        

        [self.table reloadData];
//    }
}
-(void)resignTextView:(id)sender
{
//    GKLog(@"sender sender %@", textView.text);
    [textView resignFirstResponder];
}
- (void)sendButtonAction:(id)sender
{

    if (![kUserDefault stringForKey:kSession])
    {
        [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
    }
    else {
        if(textView.text.length == 0)
        {
            [GKMessageBoard showMBWithText:@"评论不能为空" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            return;
        }
          [self resignTextView:nil];
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
        [GKComment postNoteCommentWithNoteID:_note.note_id Content:textView.text Block:^(NSDictionary *NoteComments, NSError *error) {
       GKLog(@"note note %@", NoteComments);
       if(!error)
       {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
           [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                           withAction:@"add_note_comment"
                                                            withLabel:nil
                                                            withValue:nil];
           textView.text = nil;
//           [_message removeAllObjects];
           _notecomment = [NoteComments valueForKeyPath:@"content"];
//           [_message setValue:@(_note.note_id) forKey:@"noteID"];
//           [_message setValue:@(_note.comment_count + 1) forKey:@"noteCommentCount"];
//           [_message setValue:_notecomment forKey:@"noteComment"];
//           [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewNoteComment" object:nil userInfo:_message];
           
           [GKMessageBoard hideMB];
        
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
                   GKAppDelegate *delegate = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
                   [delegate.sinaweibo logOut];
                   [[NSNotificationCenter defaultCenter] postNotificationName:GKUserLogoutNotification object:nil];
                   [(GKAppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
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
 }

#pragma mark 重载tableview必选方法
//返回一共有多少个Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回每个Section有多少Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

//定义每个Row
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *NoteCommentTableIdentifier = @"NoteCommentTableIdentifier";
    
    GKNoteCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  NoteCommentTableIdentifier];
    if (cell == nil) {
        cell = [[GKNoteCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: NoteCommentTableIdentifier];
    }
    cell.delegate = self;
    cell.data = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [GKNoteCommentCell height:[_dataArray objectAtIndex:indexPath.row]];
    return height;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    _user = [[GKUser alloc] initFromNSU];
    if([_dataArray count]>indexPath.row)
    {
    GKComment * comment =  _dataArray[indexPath.row];
    if(comment.creator.user_id == _user.user_id)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        GKComment * comment =  _dataArray[indexPath.row];
        NSUInteger commentid = comment.comment_id;

       
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
        [GKComment deleteNoteCommentWithCommentID:commentid Block:^(BOOL is_removed, NSError *error) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
            if(!error &&is_removed)
            {
//                [_message removeAllObjects];
//                [_message setValue:@(_note.note_id) forKey:@"noteID"];
//                [_message setValue:@(commentid) forKey:@"noteCommentID"];
//                [_message setValue:@(_note.comment_count-1) forKey:@"noteCommentCount"];
                [_dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteNoteComment" object:nil userInfo:_message];
                
                [GKMessageBoard hideMB];
            }
            else
            {
                NSString * errorMsg = [error localizedDescription];
                GKLog(@"error %@", errorMsg);
                [GKMessageBoard showMBWithText:errorMsg customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            }
        }];
    }
}
#pragma mark 刷新通用代码
- (void)refresh
{
    _reloading = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self makeHearderReloading];
    //[self reload:nil];
    [self performSelector:@selector(reload:) withObject:nil afterDelay:0.3];
}
-(void)reloadTableViewDataSource
{
    _reloading = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self reload:nil];
    
}
- (void)doneLoadingTableViewData{
    _reloading = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    CGPoint offset = self.table.contentOffset;
    offset.y = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentOffset = offset;
    }completion:^(BOOL finished) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    }];
}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark -
#pragma mark 重载EGORefreshTableHeaderView必选方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    //[self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}

- (void)makeHearderReloading
{
    [_refreshHeaderView setState:EGOOPullRefreshNormal];
    if (self.table.isDecelerating) {
        [self.table setContentOffset:self.table.contentOffset animated:NO];
    }
    CGPoint offset = self.table.contentOffset;
    if (offset.y >= 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.table.contentOffset = CGPointMake(offset.x, -65.);
        }completion:^(BOOL finished) {
            [_refreshHeaderView setState:EGOOPullRefreshLoading];
        }];
    }
    
    
}
//Code from Brett Schumann
- (void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;

	
	// commit animations
	[UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
     if([textView.text hasPrefix:@"评论"] == 1 )
     {
         textView.text =@"";
     }
    self.mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UITapGestureRecognizer *Tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [Tap1 setNumberOfTapsRequired:1];
    [_mask addGestureRecognizer:Tap1];
    [self.view insertSubview:_mask belowSubview:containerView];
}
-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    if([textView.text isEqualToString:@""])
    {
        textView.text =@"评论";
    }
    [_mask removeFromSuperview];
}
   
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    [self resignTextView:nil];
    [_mask removeFromSuperview];
}
@end