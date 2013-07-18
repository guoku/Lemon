//
//  GKUserBase.m
//  Grape
//
//  Created by 谢家欣 on 13-4-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUserBase.h"

@implementation GKUserBase {
@private
    NSString * _avatarImageURLString;
}

@synthesize user_id = _user_id;
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize location = _location;
@synthesize city = _city;
@synthesize relation = _relation;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _nickname = [attributes valueForKeyPath:@"nickname"];
        _gender = [attributes valueForKeyPath:@"gender"];
        _location = [attributes valueForKeyPath:@"location"];
        _city = [attributes valueForKeyPath:@"city"];
        _avatarImageURLString = [attributes valueForKeyPath:@"avatar_small"];
        if(!_avatarImageURLString)
        {
            _avatarImageURLString = @"http://image.guoku.com/avatar/large_181259_c3ac1096db6cf045cc4c9ed3a62f1c7c.jpe";
        }
        _relation = [[GKUserRelation alloc] initWithAttributes:[attributes valueForKeyPath:@"relation"]];
    }
    return self;
}

- (NSURL *)avatarImageURL
{
    return [NSURL URLWithString:_avatarImageURLString];
}

+ (void)getUserBaseByArray:(NSArray *)array Block:(void (^)(NSArray * entitylist, NSError *error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    [parameters setObject:array forKey:@"uid"];
    [[GKAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"maria/user/list/brief/"] parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray *listFromResponse = [[JSON listResponse] valueForKey:@"data"];
                NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:[listFromResponse count]];
                for(NSDictionary * attributes in listFromResponse){
                    
                    GKUserBase * user = [[GKUserBase alloc] initWithAttributes:attributes];
                    [mutableList addObject:user];
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
