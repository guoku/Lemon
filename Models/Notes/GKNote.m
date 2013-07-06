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
@synthesize hooter_count = _hooter_count;
@synthesize comment_count = _comment_count;
@synthesize created_time = _created_time;
@synthesize updated_time = _updated_time;
@synthesize note_poke = _note_poke;
@synthesize creator = _creator;



- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if (self) {
        
        _note_id = [[attributes valueForKeyPath:@"note_id"] integerValue];
        _entity_id = [[attributes valueForKeyPath:@"entity_id"] integerValue];
        _added_to_selection = [[attributes valueForKeyPath:@"added_to_selection"] boolValue];
        _note = [attributes valueForKeyPath:@"note"];
        _poker_count = [[attributes valueForKeyPath:@"poker_count"] integerValue];
        _hooter_count = [[attributes valueForKeyPath:@"hooter_count"] integerValue];
        _comment_count = [[attributes valueForKeyPath:@"comment_count"] integerValue];
        _created_time = [NSDate dateFromString:[attributes valueForKeyPath:@"created_time"]];
        _updated_time = [NSDate dateFromString:[attributes valueForKeyPath:@"updated_time"]];
        _imageURLString = [attributes valueForKeyPath:@"entity_image"];
        _creator = [[GKUserBase alloc] initWithAttributes:[attributes valueForKeyPath:@"creator"]];
        _note_poke = [[GKNotePoke alloc] initWithAttributes:[attributes valueForKeyPath:@"poker"]];
    }
    
    return self;
}

- (NSURL *)imageURL
{
    return [NSURL URLWithString:_imageURLString];
}

+ (void)postEntityNoteWithEntityID:(NSUInteger)entity_id
                            NoteID:(NSUInteger)note_id
                           Content:(NSString *)content
                             Block:(void (^)(NSDictionary *note, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:3];
    [paramters setValue:[NSString stringWithFormat:@"%u", entity_id] forKey:@"eid"];
    [paramters setValue:content forKey:@"note"];
    if (note_id != 0)
    {
        [paramters setValue:[NSString stringWithFormat:@"%u", note_id] forKey:@"note_id"];
    }
    GKLog(@"paramters %@", paramters);
    [[GKAppDotNetAPIClient sharedClient] postPath:@"note/create/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
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
//                    GKLog(@"%@", attributes);
                    GKNote * _note = [[GKNote alloc] initWithAttributes:attributes];
                    [noteDict setValue:_note forKey:@"content"];
//                    [_note saveToSQLite];
                    break;
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
                   PokedOrHotted:(NOTE_POKE_OR_HOOT)poked_or_hooted
                           Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramters setObject:[NSString stringWithFormat:@"%u", note_id] forKey:@"note_id"];
    
    NSString * poke_or_hoot_URLString;
    switch (poked_or_hooted) {
        case kPoker:
            poke_or_hoot_URLString = @"note/poke/";
            break;
        case kHooter:
            poke_or_hoot_URLString = @"note/hoot/";
            break;
        default:
            break;
    }
    
    
    [[GKAppDotNetAPIClient sharedClient] postPath:poke_or_hoot_URLString parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
       
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
                    GKNotePoke * notePoke = [[GKNotePoke alloc] initWithAttributes:attributes];
                    [notePokeDict setObject:notePoke forKey:@"content"];
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
