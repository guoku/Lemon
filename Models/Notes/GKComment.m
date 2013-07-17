//
//  GKComment.m
//  Grape
//
//  Created by 谢家欣 on 13-3-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKComment.h"
#import "GKAppDotNetAPIClient.h"
#import "NSDate+GKHelper.h"
#import "NSDictionary+GKHelp.h"

NSString * const GKAddNewNoteCommentNotification = @"GKAddNewNoteCommentNotification";
NSString * const GKDeleteNoteCommentNotification = @"GKDeleteNoteCommentNotification";


@implementation GKComment

@synthesize note_id = _note_id;
@synthesize comment_id = _comment_id;
@synthesize comment = _comment;
@synthesize created_time = _created_time;
@synthesize updated_time = _updated_time;
@synthesize creator = _creator;
@synthesize replied_user_id = _replied_user_id;
@synthesize reply_user = _reply_user;


- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        _note_id = [[attributes valueForKeyPath:@"note_id"] integerValue];
        _comment_id = [[attributes valueForKeyPath:@"comment_id"] integerValue];
        _comment = [attributes valueForKeyPath:@"comment"];
        _created_time = [NSDate dateFromString:[attributes valueForKeyPath:@"created_time"]];
        _updated_time = [NSDate dateFromString:[attributes valueForKeyPath:@"updated_time"]];
        _creator = [[GKUserBase alloc] initWithAttributes:[attributes valueForKeyPath:@"creator"]];
        if(![[attributes valueForKeyPath:@"replied_comment_id"] isEqual:[NSNull null]])
        {
            _replied_user_id = [[attributes valueForKeyPath:@"replied_comment_id"] integerValue];
        }
        else
        {
            _replied_user_id = 0;
        }
        if(![[attributes valueForKeyPath:@"replied_user"] isEqual:[NSNull null]])
        {
            _reply_user = [[GKUserBase alloc] initWithAttributes:[attributes valueForKeyPath:@"replied_user"]];
        }
        else
        {
            _reply_user = nil;
        }
    }
    return self;
}


+ (void)globalNoteCommetWithNoteID:(NSUInteger)note_id Block:(void (^)(NSArray * comment_list, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramters setValue:[NSString stringWithFormat:@"%u", note_id] forKey:@"note_id"];
    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"note/comment/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSArray * listCommentResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
        NSMutableArray * _commentList = [NSMutableArray arrayWithCapacity:[listCommentResponse count]];
        for(NSDictionary * attributes in listCommentResponse)
        {
            GKComment * _noteComment = [[GKComment alloc] initWithAttributes:attributes];
            [_commentList addObject:_noteComment];
        }
        
        if (block)
        {
            block([NSArray arrayWithArray:_commentList], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            block([NSDictionary dictionary], error);
        }
    }];
}

+ (void)postNoteCommentWithNoteID:(NSUInteger)note_id Content:(NSString *)content reply:(NSUInteger)reply_id Block:(void (^)(NSDictionary * NoteComment, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramters setValue:content forKey:@"comment"];
    if(reply_id)
    {
        [paramters setValue:[NSString stringWithFormat:@"%u",reply_id]  forKey:@"replied_comment_id"];
    }
    
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/note/%u/add/comment/",note_id] parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        GKLog(@"note comment %@", JSON);
        
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * listCommentResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * _mutableDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary * attributions in listCommentResponse)
                {
                    GKComment * _noteComment = [[GKComment alloc] initWithAttributes:[attributions objectForKey:@"comment"]];
                    [_mutableDict setValue:_noteComment forKey:@"content"];
                    [_mutableDict setValue:@(note_id) forKey:@"note_id"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:GKAddNewNoteCommentNotification object:nil userInfo:_mutableDict];
                }
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:_mutableDict], nil);
                }
            }
                break;
            case SESSION_ERROR:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kUserSessionError userInfo:userInfo];
            }
                break;
            default:
                break;
        }
        if (res_code != SUCCESS)
        {
            if (block)
            {
                block([NSDictionary dictionary], aError);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       if (block)
       {
           GKLog(@"%@", error);
           block([NSDictionary dictionary], error);
       }
    }];
}

+ (void)deleteNoteCommentWithCommentID:(NSUInteger)comment_id NoteID:(NSUInteger)note_id
                                 Block:(void (^)(BOOL is_removed, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:1];
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/note/%u/del/comment/%u",note_id,comment_id] parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSError * aError;
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        switch (res_code) {
            case SUCCESS:
            {
                NSDictionary * _userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:comment_id], @"note_comment_id", nil];
                if (block)
                {
                    block(YES, nil);
                    [[NSNotificationCenter defaultCenter] postNotificationName:GKDeleteNoteCommentNotification object:nil userInfo:_userInfo];
                }
                
            }
                break;
            case SESSION_ERROR:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kUserSessionError userInfo:userInfo];
            }
                break;
            default:
                break;
        }
        
        if (res_code != SUCCESS)
        {
            if(block)
            {
                block(NO, aError);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block(NO, error);
        }
        
    }];
    
}

@end
