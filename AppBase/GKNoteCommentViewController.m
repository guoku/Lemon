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
    NSUInteger reply_id;
    NSUInteger _note_id;
    NSUInteger _entity_id;
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
        reply_id = 0;
        self.navigationItem.titleView = [GKTitleView setTitleLabel:@"评论"];
        self.view.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        self.view.backgroundColor = UIColorFromRGB(0xffffff);
        _message = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return self;
}

- (id)initWithNote:(GKNote *)note Entity:(GKEntity *)entity;
{
    self = [super init];
    {
        _note = note;
        _entity = entity;
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44 -40) style:UITableViewStylePlain];
        _table.backgroundColor = UIColorFromRGB(0xffffff);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.allowsSelection = NO;
        [_table setDelegate:self];
        [_table setDataSource:self];
        headheight = [GKNoteCommentHeaderView height:_note];
        self.headerView = [[GKNoteCommentHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,headheight)];
        _headerView.delegate = self;
        _headerView.notedelegate = self;
        [self.headerView setNoteData:_note entityData:_entity];
        
        self.table.tableHeaderView = [[UIView alloc]initWithFrame:_headerView.frame];
        [self.table.tableHeaderView addSubview:_headerView];
        [self setTableHeaderView];
        
        [self.view addSubview:_table];
        [self reload:nil];
        
        [self.view addSubview:containerView];
    }
    return self;
}
- (id)initWithNoteID:(NSUInteger)note_id EntityID:(NSUInteger)entity_id
{
    self = [super init];
    {
        _note_id = note_id;
        _entity_id = entity_id;
        [self.view addSubview:containerView];
      
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
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBTN];


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
    _dataArray = _note.comments_list;
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

    


}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   if((!_note)||(!(_entity)))
   {
       [GKDetail globalDetailPageWithEntityId:_entity_id Block:^(NSDictionary *dict, NSError *error) {
           if(!error)
           {
               GKDetail * data =  [dict valueForKeyPath:@"content"];
               _entity = data;
               for (GKNote * note in data.notes_list) {
                   if(note.note_id == _note_id)
                   {
                       _note = note;
                       break;
                   }
               }
               self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44 -40) style:UITableViewStylePlain];
               _table.backgroundColor = UIColorFromRGB(0xffffff);
               _table.separatorStyle = UITableViewCellSeparatorStyleNone;
               _table.allowsSelection = NO;
               [_table setDelegate:self];
               [_table setDataSource:self];
               headheight = [GKNoteCommentHeaderView height:_note];
               self.headerView = [[GKNoteCommentHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,headheight)];
               [self.headerView setNoteData:_note entityData:_entity];
               
               _headerView.delegate = self;
               self.table.tableHeaderView = [[UIView alloc]initWithFrame:_headerView.frame];
               [self.table.tableHeaderView addSubview:_headerView];
               
               [self.view insertSubview:self.table belowSubview:containerView];
               [self reload:nil];
           }
           else
           {
               [GKMessageBoard showMBWithText:@"加载失败" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
           }
           
       }];
   }
    
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
    GKComment * _comment = [notidata valueForKeyPath:@"content"];
    if([[notidata valueForKeyPath:@"note_id"]integerValue] == _note.note_id)
    {
        _note.comment_count += 1;
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
        NSString *resultString = [[NSString alloc]init ];
        if(textView.text.length == 0)
        {
            [GKMessageBoard showMBWithText:@"评论不能为空" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
            return;
        }
 
        NSString *string = [NSString stringWithFormat:@"%@",textView.text];
        if([string hasPrefix:@"回复"])
        {
            NSArray  * array= [string componentsSeparatedByString:@"："];
            if(([array count]>1)&&(![[array  objectAtIndex:1]isEqualToString:@""]))
            {
                for (int i = 1 ;i< [array count];i++) {
                    resultString = [NSString stringWithFormat:@"%@%@",resultString,[array objectAtIndex:i]];
                }
            }
            else
            {
                [GKMessageBoard showMBWithText:@"评论不能为空" customView:[[UIView alloc] initWithFrame:CGRectZero] delayTime:1.2];
                reply_id = 0;
                return;
            }
        }
        else
        {
            resultString = textView.text;
        }
        [self resignTextView:nil];
 
        [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
        [GKComment postNoteCommentWithNoteID:_note.note_id Content:resultString reply:reply_id Block:^(NSDictionary *NoteComments, NSError *error) {
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
       GKLog(@"note note %@", NoteComments);
       if(!error)
       {
          
           [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"ItemAction"
                                                           withAction:@"add_note_comment"
                                                            withLabel:nil
                                                            withValue:nil];
           textView.text = nil;
           _notecomment = [NoteComments valueForKeyPath:@"content"];
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
- (void)replyButtonAction:(GKComment *)comment
{
    NSLog(@"%u",[_dataArray indexOfObjectIdenticalTo:comment]);

    textView.text =[NSString stringWithFormat:@"回复%@：",comment.creator.nickname];
    reply_id = comment.comment_id;
    
    [textView becomeFirstResponder];
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
        [GKComment deleteNoteCommentWithCommentID:commentid NoteID:_note.note_id Block:^(BOOL is_removed, NSError *error) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
            if(!error &&is_removed)
            {
                [_dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                
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
    _mask.backgroundColor = UIColorFromRGB(0xffffff);
    _mask.alpha = 0.5;
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
- (void)tapPokeRoHootButtonWithNote:(id)noteobj Poke:(id)poker;
{
    GKNote * noteData = noteobj;
    UIButton * pokeBtn = poker;
    
    [GKMessageBoard showMBWithText:nil customView:nil delayTime:0.0];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sync"];
    [GKNote pokeEntityNoteWithNoteID:noteData.note_id Selected:pokeBtn.selected Block:^(NSDictionary *dict, NSError *error) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sync"];
        if (!error)
        {
            if(!pokeBtn.selected)
            {
                noteData.poker_already = YES;
                noteData.poker_count++;
                GKUser *me = [[GKUser alloc]initFromNSU];
                [noteData.poke_id_list insertObject:@(me.user_id) atIndex:0];
                [pokeBtn setTitle:[NSString stringWithFormat:@"%u", noteData.poker_count] forState:UIControlStateNormal];
                self.headerView.noteData = noteData;
                pokeBtn.selected = YES;
            }
            else
            {
                noteData.poker_already = NO;
                noteData.poker_count--;
                GKUser *me = [[GKUser alloc]initFromNSU];
                NSUInteger index = -1;
                for (NSString * string in noteData.poke_id_list) {
                     if([string isEqual:@(me.user_id)])
                    {
                        index = [noteData.poke_id_list indexOfObject:string];
                    }
                }
                if(index != -1)
                {
                    [noteData.poke_id_list removeObjectAtIndex:index];
                }
                [pokeBtn setTitle:[NSString stringWithFormat:@"%u", noteData.poker_count] forState:UIControlStateNormal];
                self.headerView.noteData = noteData;
                pokeBtn.selected = YES;
            }
            
            [_message setValue:@(noteData.note_id) forKey:@"noteID"];
            [_message setValue:noteData forKey: @"note"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kGKN_NotePokeChange object:nil userInfo:_message];
            
            [GKMessageBoard hideMB];
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
- (void)setTableHeaderView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    view.backgroundColor =UIColorFromRGB(0xf2f2f2);
    
    [_table addSubview:view];
}

@end