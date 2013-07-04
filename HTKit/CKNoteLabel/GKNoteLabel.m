//
//  GKNoteLabel.m
//  Grape
//
//  Created by huiter on 13-4-29.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNoteLabel.h"
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
@synthesize note = _note;
@synthesize gkdelegate = _gkdelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        fontsize = 14;
        self.backgroundColor = [UIColor clearColor];
        _content = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];

        [_content setAdjustsFontSizeToFitWidth:NO];
        [_content setNumberOfLines:3];
        [_content setBackgroundColor:[UIColor clearColor]];
        [_content setLineBreakMode:UILineBreakModeTailTruncation];
        [_content setTextAlignment:UITextAlignmentLeft];
        [_content setVerticalAlignment:TTTAttributedLabelVerticalAlignmentTop];
        [_content setLeading:4];
        
        [_content setTextColor:UIColorFromRGB(0x666666)];
        _content.delegate = self;
        
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
- (void)setNote:(GKNote *)note
{
    if([note isKindOfClass:[GKNote class]])
    {
        _note = note;
        text = _note.note;
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
    if(text != nil)
    {
    UIFont *italicSystemFont = [UIFont fontWithName:@"Helvetica" size:fontsize-1];
    [self.content setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);

        NSRegularExpression *regexp = EnglishRegularExpression();
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {

            CTFontRef italicFont = CTFontCreateWithName((__bridge CFStringRef)italicSystemFont.fontName, italicSystemFont.pointSize, NULL);
            if (italicFont) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicFont range:result.range];
                CFRelease(italicFont);
            }
        }];
        
        return mutableAttributedString;
    }];
 
    NSRegularExpression *urlregexp =  UrlRegularExpression();
    NSArray *urlarray = [urlregexp matchesInString: _content.text
                                         options: 0
                                           range: NSMakeRange( 0, [_content.text length])];
        for (NSTextCheckingResult *match in urlarray)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.content.text substringWithRange:match.range]]];
            [self.content addLinkToURL:url withRange:match.range];
        }
        
    }

}
#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"在Safari中打开", nil), nil] showInView:self];
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
