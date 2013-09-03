//
//  GKNoteLabel.m
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNoteLabel.h"
static inline NSRegularExpression * ParenthesisRegularExpression() {
    static NSRegularExpression *_parenthesisRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"(#|＃)([A-Z0-9a-z\u4e00-\u9fa5(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _parenthesisRegularExpression;
}
static inline NSRegularExpression * EnglishRegularExpression() {
    static NSRegularExpression *_englishRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _englishRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"([。，！？、！#＃0-9A-Za-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _englishRegularExpression;
}
static inline NSRegularExpression * UrlRegularExpression() {
    static NSRegularExpression *_urlRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _urlRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"(http(s)?://([A-Z0-9a-z._-]*(/)?)*)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _urlRegularExpression;
}

@implementation GKNoteLabel
{
@private
    NSUInteger fontsize;
    NSString *text;
}
@synthesize content = _content;
@synthesize data = _data;
@synthesize gkdelegate = _gkdelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        fontsize = 14;
        self.backgroundColor = [UIColor clearColor];
        _content = [[RTLabel alloc] initWithFrame:CGRectZero];
        [_content setBackgroundColor:[UIColor clearColor]];
        [_content setParagraphReplacement:@""];
        _content.lineSpacing = 4.0;
        _content.delegate = self;
        [_content setTextColor:UIColorFromRGB(0x666666)];
        
        [self addSubview:_content];
        
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.8;
        [self addGestureRecognizer:longPress];
    }
    return self;
}
- (void)setData:(GKNote *)data
{
    if([data isKindOfClass:[GKNote class]])
    {
        _data = data;
        text = _data.note;
    }
    [self setNeedsLayout];
}
- (void)setComment:(GKComment *)comment
{
    if([comment isKindOfClass:[GKComment class]])
    {
        _comment = comment;
        text = _comment.comment;
    }
    [self setNeedsLayout];
}
- (void)setFontsize:(NSUInteger)size
{
    fontsize = size;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_content setFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
    [_content setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:fontsize]];
    
    if(text!=nil)
    {
    NSMutableString * resultText = [NSMutableString stringWithString:text];
          /*
    NSRegularExpression *regexp =  ParenthesisRegularExpression();
    NSArray *array = [regexp matchesInString: text
                                     options: 0
                                       range: NSMakeRange( 0, [text length])];

    NSUInteger i = 0;
    NSUInteger j = 0;
      
    for (NSTextCheckingResult *match in array)
    {
        j = match.range.location+i;
        
        NSString * a = [NSString stringWithFormat:@"<a href='tag:%@'><font color='#4b7189'>",[[text substringWithRange:NSMakeRange(match.range.location+1,match.range.length-1)] encodeBase64String]];
        
        [resultText insertString:a atIndex:j];
        NSString * b = [NSString stringWithFormat:@"</font></a>"];
        j = match.range.length+j+a.length;
        [resultText insertString:b atIndex:j];
        
        i = i + b.length + a.length;
        GKLog(@"%@",resultText);
    }
    */
        GKLog(@"%@",resultText);
        [_content setText:resultText];
    }
    /*
    NSRegularExpression *urlregexp =  UrlRegularExpression();
    NSArray *urlarray = [urlregexp matchesInString: _content.text
                                         options: 0
                                           range: NSMakeRange( 0, [_content.text length])];
        for (NSTextCheckingResult *match in urlarray)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.content.text substringWithRange:match.range]]];
    
        }
     */       
}


#pragma mark - TTTAttributedLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    /*
	GKLog(@"did select url %@", url);
    
    NSArray  * array= [[url absoluteString] componentsSeparatedByString:@":"];
    if([array[0] isEqualToString:@"http"])
    {
        [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"在Safari中打开", nil), nil] showInView:self];
    }
    if([array[0] isEqualToString:@"tag"])
    {
        if (_gkdelegate && [_gkdelegate respondsToSelector:@selector(showTagWithTagString:)]) {
            [_gkdelegate showTagWithTagString:[[[array[1] decodeBase64String]stringByReplacingOccurrencesOfString:@"#" withString:@""]stringByReplacingOccurrencesOfString:@"＃" withString:@""]];
        }
    }
     */
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    if(actionSheet.tag!=2014)
    {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
    }
    else
    {
        [[UIPasteboard generalPasteboard] setPersistent:YES];
        [[UIPasteboard generalPasteboard] setValue:self.content.text forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateBegan) {
        GKLog(@"UIGestureRecognizerStateBegan");
        UIActionSheet * shareOptionSheet = nil;
        shareOptionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:@"复制文本", nil];
        shareOptionSheet.tag = 2014;
        [shareOptionSheet showInView:self];
        [shareOptionSheet setActionSheetStyle:UIActionSheetStyleDefault];

    }
    
}
@end
