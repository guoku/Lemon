//
//  GKNote.m
//  Grape
//
//  Created by 谢家欣 on 13-3-24.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKNote.h"
#import "GKAppDotNetAPIClient.h"
//#import "NSString+GKHelper.h"
#import "NSDate+GKHelper.h"
#import "NSDictionary+GKHelp.h"
#import "GKDBCore.h"

NSString * const GKAddNewNoteNotification = @"GKAddNewNoteNotification";

@implementation GKNote
{
@private
    NSString * _imageURLString;
}
@synthesize note_id = _note_id;
@synthesize entity_id = _entity_id;
@synthesize added_to_selection = _added_to_selection;
@synthesize note = _note;
@synthesize poker_count = _poker_count;
@synthesize comment_count = _comment_count;
@synthesize created_time = _created_time;
@synthesize updated_time = _updated_time;
@synthesize creator = _creator;
@synthesize score = _score;
@synthesize poker_already = _poker_already;
@synthesize comments_list = _comments_list;



- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if (self) {
        
        _note_id = [[attributes valueForKeyPath:@"note_id"] integerValue];
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _added_to_selection = [[attributes valueForKeyPath:@"added_to_selection"] boolValue];
        _note = [attributes valueForKeyPath:@"note"];
        _poker_count = [[attributes valueForKeyPath:@"poker_id_list"] count];
        _comment_count = [[attributes valueForKeyPath:@"comment_id_list"] count];
        _created_time = [NSDate dateFromString:[attributes valueForKeyPath:@"created_time"]];
        _updated_time = [NSDate dateFromString:[attributes valueForKeyPath:@"updated_time"]];
        _imageURLString = [attributes valueForKeyPath:@"entity_image"];
        _creator = [[GKUserBase alloc] initWithAttributes:[attributes valueForKeyPath:@"creator"]];
        _poker_already = [[attributes valueForKeyPath:@"poked_already"]boolValue];
        _score = [[attributes valueForKeyPath:@"score"] integerValue];
        _comments_list = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"comment_list"] count]];
        for (NSDictionary * comment_attrs in [attributes valueForKeyPath:@"comment_list"] )
        {
            GKComment * _comment = [[GKComment alloc] initWithAttributes:comment_attrs];
            [_comments_list addObject:_comment];
        }
        _poke_id_list = [NSMutableArray arrayWithArray:[attributes valueForKeyPath:@"poker_id_list"]];
    }
    
    return self;
}

- (NSURL *)imageURL
{
    return [NSURL URLWithString:_imageURLString];
}

+ (void)postEntityNoteWithEntityID:(NSUInteger)entity_id
                            NoteID:(NSUInteger)note_id
                            Score:(NSUInteger)score
                           Content:(NSString *)content
                             Block:(void (^)(NSDictionary *note, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:3];
    [paramters setValue:[NSString stringWithFormat:@"%u", entity_id] forKey:@"eid"];
    [paramters setValue:content forKey:@"note"];
    [paramters setValue:[NSString stringWithFormat:@"%u",score] forKey:@"score"];
    if (note_id != 0)
    {
        [paramters setValue:[NSString stringWithFormat:@"%u", note_id] forKey:@"note_id"];
    }
    GKLog(@"paramters %@", paramters);
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/entity/%u/mark",entity_id] parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * listNoteResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * noteDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for(NSDictionary *attributes in listNoteResponse)
                {
                    NSLog(@"%@",attributes);
                    if(![[attributes objectForKey:@"note"]isEqual:[NSNull null]])
                    {
                        GKNote * _note = [[GKNote alloc] initWithAttributes:[attributes objectForKey:@"note"]];
                        [noteDict setValue:_note forKey:@"content"];
                    }
                    [noteDict setValue:@(entity_id) forKey:@"entity_id"];
                    [noteDict setValue:@(score) forKey:@"score"];
                    if(![[attributes objectForKey:@"like"]isEqual:[NSNull null]])
                    {
                        GKEntityLike * entityLike = [[GKEntityLike alloc] initWithAttributes:[attributes objectForKey:@"like"]];
                        if (entityLike.status) {
                            [entityLike saveToSQLite];
                        }
                        [noteDict setValue:entityLike forKeyPath:@"like_content"];

                    }
                }
                if (block)
                {
                    GKLog(@"post result ------------%@", noteDict);
                    block([NSDictionary dictionaryWithDictionary:noteDict], nil);
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:GKAddNewNoteNotification object:nil userInfo:noteDict];
            }
                break;
            case NOTE_ID_ERROR:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:EntityErrorDomain code:kNoteIdError userInfo:userInfo];
            }
                break;
            case PREMISSIONS_DENY:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:EntityErrorDomain code:kPremissonDenyError userInfo:userInfo];
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
                GKLog(@"%@", aError);
                block([NSDictionary dictionary], aError);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block)
        {
            GKLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];
}


+ (void)pokeEntityNoteWithNoteID:(NSUInteger)note_id
                           Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:2];
        
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/note/%u/poke",note_id] parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
       
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * PokeOrHootResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * notePokeDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary * attributes in PokeOrHootResponse)
                {
                    break;
                }
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:notePokeDict], nil);
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

@end
