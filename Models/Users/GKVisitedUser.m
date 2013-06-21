//
//  GKVisitedUser.m
//  Grape
//
//  Created by 谢家欣 on 13-4-9.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKVisitedUser.h"
#import "GKAppDotNetAPIClient.h"
#import "NSDictionary+GKHelp.h"


@implementation GKVisitedUser



+ (void)visitedUserWithUserID:(NSUInteger)user_id Page:(NSUInteger)page Type:(VisitedType)visitedtpye
                                Block:(void (^)(NSArray * entitylist, NSError *error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    [parameters setObject:[NSString stringWithFormat:@"%u", user_id] forKey:@"user_id"];
    [parameters setObject:[NSString stringWithFormat:@"%u", page] forKey:@"page"];
    NSString * _requestURIString;
    switch (visitedtpye) {
        case kUserLike:
            _requestURIString = @"user/like/";
            break;
        case kUserPost:
            _requestURIString = @"user/post/";
            break;
        case kUserNotes:
            _requestURIString = @"user/notes/";
            break;
        case kUserTags:
            _requestURIString = @"user/tags/";
            break;
        default:
            _requestURIString = @"user/like/";
            break;
    }
    
    [[GKAppDotNetAPIClient sharedClient] getPath:_requestURIString parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray *listFromResponse = [[JSON listResponse] valueForKey:@"data"];
                NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:[listFromResponse count]];
                for(NSDictionary * attributes in listFromResponse){
                    switch (visitedtpye) {
                        case kUserLike:
                        {
                            GKEntity * entity = [[GKEntity alloc] initWithAttributes:attributes];
                            [mutableList addObject:entity];
                        }
                            break;
                        case kUserPost:
                        {
                            GKEntity * entity = [[GKEntity alloc] initWithAttributes:attributes];
                            [mutableList addObject:entity];
                        }
                            break;
                        case kUserNotes:
                        {
                            GKNote * note = [[GKNote alloc] initWithAttributes:attributes];
                            [mutableList addObject:note];
                        }
                            break;
                        case kUserTags:
                        {
                            GKTags * tag = [[GKTags alloc] initWithAttributes:attributes];
                            [mutableList addObject:tag];
                        }
                            break;
                        default:
                            break;
                            
                    }
                    
                    
                }
                GKLog(@"%@", mutableList);
                if(block) {
                    block([NSArray arrayWithArray:mutableList], nil);
                }
            
            }
                break;
            case OBJECT_EMPTY:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:EntityErrorDomain code:kEntityIsEmpty userInfo:userInfo];
                
            }
                break;
            default:
                break;
        }
        if (res_code != SUCCESS)
        {
            block([NSArray array], aError);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block)
        {
            GKLog(@"%@", error);
            block([NSArray array], error);
        }
    }];
}

@end
