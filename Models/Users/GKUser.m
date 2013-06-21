//
//  GKUser.m
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKUser.h"
#import "NSDate+GKHelper.h"
#import "NSDictionary+GKHelp.h"

#import "GKAppDotNetAPIClient.h"
#import "GKDBCore.h"
#import "GKEntityLike.h"

NSString *const GKUserLogoutNotification = @"GKUserLogoutNotification";
NSString * const GKUserLoginNotification = @"GKUserLoginNotification";

static  NSString * CREATE_USER_TABLE_SQL = @"CREATE TABLE IF NOT EXISTS user \
                                (id INTEGER PRIMARY KEY NOT NULL, \
                                user_id INTEGER UNIQUE NOT NULL, \
                                username VARCHAR(255), \
                                nickname VARCHAR(255), \
                                gender CHAR(1), \
                                location VARCHAR(30), \
                                email VARCHAR(60), \
                                email_verified BOOLEAN, \
                                website VARCHAR(255), \
                                bio VARCHAR(255), \
                                birth_date timestamp, \
                                liked_count INTEGER, \
                                post_entities INTEGER, \
                                post_entity_notes INTEGER, \
                                tags INTEGER, \
                                followings INTEGER, \
                                fans INTEGER)";


static  NSString * INSERT_USER_SQL = @"REPLACE INTO user (user_id, username, nickname, gender, location, email, website, bio, birth_date, email_verified, liked_count, post_entities, post_entity_notes, tags, followings, fans) VALUES (:user_id, :username, :nickname, :gender, :location, :email, :website, :bio, :birth_date, :email_verified, :liked_count, :post_entities, :post_entity_notes, :tags, :followings, :fans)";


static NSString * REMOVE_USER_SQL = @"DELETE FROM user WHERE user_id = :user_id";
@implementation GKUser

@synthesize user_id = _user_id;
@synthesize username = _username;
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize location = _location;
@synthesize email = _email;
@synthesize email_verified = _email_verified;
@synthesize website = _website;
@synthesize bio = _bio;
@synthesize session = _session;
@synthesize birth_date = _birth_date;
@synthesize liked_count = _liked_count;
@synthesize post_entities = _post_entities;
@synthesize post_entity_notes = _post_entity_notes;
@synthesize tags = _tags;
@synthesize followings = _followings;
@synthesize fans = _fans;
@synthesize relation = _relation;
@synthesize avatars = _avatars;
@synthesize weibo_token = _weibo_token;
@synthesize taobao_token = _taobao_token;


- (BOOL)createUserTable
{
    return [[GKDBCore sharedDB] createTableWithSQL:CREATE_USER_TABLE_SQL];
    //    return YES;
}


- (id)initFromSQLite
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    FMResultSet * rs = [[GKDBCore sharedDB] queryDataWithSQL:@"SELECT * FROM user"];
    while ([rs next]) {
        _user_id = [rs intForColumn:@"user_id"];
        _username = [rs stringForColumn:@"username"];
        _nickname = [rs stringForColumn:@"nickname"];
        _gender = [rs stringForColumn:@"gender"];
        _location = [rs stringForColumn:@"location"];
        _email = [rs stringForColumn:@"email"];
        _website = [rs stringForColumn:@"website"];
        _bio = [rs stringForColumn:@"bio"];
        _birth_date = [rs dateForColumn:@"birth_date"];
        _email_verified = [rs boolForColumn:@"email_verified"];
        _liked_count = [rs intForColumn:@"liked_count"];
        _post_entities = [rs intForColumn:@"post_entities"];
        _post_entity_notes = [rs intForColumn:@"post_entity_notes"];
        _tags = [rs intForColumn:@"tags"];
        _followings = [rs intForColumn:@"followings"];
        _fans = [rs intForColumn:@"fans"];
//        _relation = [rs]
    }
    _avatars = [[GKUserAvatar alloc] initFromSQLiteWithUserID:_user_id];
    _weibo_token = [[GKUserWeiboToken alloc] initFromSQLiteWithUserID:_user_id];
    _taobao_token = [[GKUserTaobaoToken alloc] initFromSQLiteWithUserID:_user_id];
    return self;

}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _username = [attributes valueForKeyPath:@"username"];
        _nickname = [attributes valueForKeyPath:@"nickname"];
        _location = [attributes valueForKeyPath:@"location"];
        _email = [attributes valueForKeyPath:@"email"];
        _email_verified = [[attributes valueForKeyPath:@"email_verified"] boolValue];
        _website = [attributes valueForKeyPath:@"website"];
        _bio = [attributes valueForKeyPath:@"bio"];
        _gender = [attributes valueForKeyPath:@"gender"];
        _session = [attributes valueForKeyPath:@"session"];
        
        _liked_count = [[attributes valueForKeyPath:@"liked_count"] integerValue];
        _post_entities = [[attributes valueForKeyPath:@"post_entities"] integerValue];
        _post_entity_notes = [[attributes valueForKeyPath:@"post_entity_notes"] integerValue];
        _tags = [[attributes valueForKeyPath:@"tags"] integerValue];
        _followings = [[attributes valueForKeyPath:@"followings"] integerValue];
        _fans = [[attributes valueForKeyPath:@"fans"] integerValue];
//        _relation = [[attributes valueForKeyPath:@"relation"] integerValue];
        
        _birth_date = [NSDate dateFromString:[attributes valueForKeyPath:@"birth_date"]];
        
        _relation = [[GKUserRelation alloc] initWithAttributes:[attributes valueForKeyPath:@"relation"]];
        _avatars = [[GKUserAvatar alloc] initWithAttributes:[attributes valueForKeyPath:@"avatars"]];
        _weibo_token = [[GKUserWeiboToken alloc] initWithAttributes:[attributes valueForKeyPath:@"weibo_token"]];
        _taobao_token = [[GKUserTaobaoToken alloc] initWithAttributes:[attributes valueForKeyPath:@"taobao_token"]];
//        GKLog(@"taobao user screen name %@", _taobao_token.screen_name);
    }
    return self;
}



- (GKUser *)save
{
    [self createUserTable];
    if (_session)
    {
        GKLog(@" session ------------ %@", _session);
        [kUserDefault setObject:_session forKey:kSession];
        [kUserDefault synchronize];
    }
    
    NSMutableDictionary * argsDict = [NSMutableDictionary dictionaryWithCapacity:16];
    [argsDict setValue:[NSString stringWithFormat:@"%u", _user_id] forKey:@"user_id"];
    [argsDict setValue:_username forKey:@"username"];
    [argsDict setValue:_nickname forKey:@"nickname"];
    [argsDict setValue:_gender forKey:@"gender"];
    [argsDict setValue:_location forKey:@"location"];
    [argsDict setValue:_email forKey:@"email"];
    [argsDict setValue:_website forKey:@"website"];
    [argsDict setValue:_bio forKey:@"bio"];
    [argsDict setValue:[NSDate stringFromDate:_birth_date] forKey:@"birth_date"];
    [argsDict setValue:[NSString stringWithFormat:@"%d", _email_verified] forKey:@"email_verified"];
    [argsDict setValue:[NSString stringWithFormat:@"%u", _liked_count] forKey:@"liked_count"];
    [argsDict setValue:[NSString stringWithFormat:@"%u", _post_entities] forKey:@"post_entities"];
    [argsDict setValue:[NSString stringWithFormat:@"%u", _post_entity_notes] forKey:@"post_entity_notes"];
    [argsDict setValue:[NSString stringWithFormat:@"%u", _tags] forKey:@"tags"];
    [argsDict setValue:[NSString stringWithFormat:@"%u", _followings] forKey:@"followings"];
    [argsDict setValue:[NSString stringWithFormat:@"%u", _fans] forKey:@"fans"];
    GKLog(@"save to sqlite %@", argsDict);
    [[GKDBCore sharedDB] beginTransaction];
    [[GKDBCore sharedDB] insertDataWithSQL:INSERT_USER_SQL ArgsDict:argsDict];
    [_avatars saveToSQLite];
    [_weibo_token saveToSQLite];

    [_taobao_token saveToSQLite];
    [[GKDBCore sharedDB] commit];
    return self;
}

- (BOOL)removeFromSQLite
{
    [_avatars removeFromSQLiteWithUserID:self.user_id];
    [_weibo_token removeFromSQLite];
    [_taobao_token removeFromSQLite];
//    [_weibo_token removeFromSQILiteWithUserID:self.user_id];
//    [_taobao_token removeFromSQLiteWithUserID:self.user_id];
    NSDictionary * argsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%u", self.user_id], @"user_id", nil];

    GKLog(@"delete user info %@", argsDict);
    if ([[GKDBCore sharedDB] removeDataWithSQL:REMOVE_USER_SQL ArgsDict:argsDict])
    {
        [kUserDefault removeObjectForKey:kSession];
        [kUserDefault synchronize];
        return YES;
    }
    return YES;
}

#pragma mark -

+ (void)globalUserProfileWithUserID:(NSUInteger)user_id Block:(void (^)( NSDictionary * dict, NSError * error))block {
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] initWithCapacity:1];
    if (user_id)
    {
        [parameters setValue:[NSNumber numberWithUnsignedInteger:user_id] forKey:@"user_id"];
    }
//    else
//    {
//        NSMutableDictionary * _res = [NSMutableDictionary dictionaryWithCapacity:1];
//        GKUser * _user = [[GKUser alloc] initFromSQLite];
//        [_res setValue:_user forKey:@"content"];
//        if(block)
//        {
//            block([NSDictionary dictionaryWithDictionary:_res], nil);
//        }
//        return;
//    }
    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"user/profile/" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
//        GKLog(@"%@",  JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * _profiles = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                GKLog(@"%@", _profiles);
                NSMutableDictionary * _res = [NSMutableDictionary dictionaryWithCapacity:1];
                for( NSDictionary *attributes in _profiles )
                {
                    GKUser * user = [[GKUser alloc] initWithAttributes:attributes];
                    GKLog(@"user %@ post entity %u", user.username, user.post_entity_notes);
                    [_res setValue:user forKey:@"content"];
                }
                
                if (block) {
                    block([NSDictionary dictionaryWithDictionary:_res], nil);
                }
            
            }
                break;
                
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            GKLog(@"errr -------- %@", error);
            block([NSDictionary dictionary], error);
        }
    }];
}

+ (void)globaluserRegisterWithEmail:(NSString *)email Passwd:(NSString *)passwd NickName:(NSString *)nickname
                            Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:3];
    [paramters setValue:email forKey:@"email"];
    [paramters setValue:passwd forKey:@"passwd"];
    [paramters setValue:nickname forKey:@"nickname"];
    [paramters setValue:[kUserDefault valueForKeyPath:kDeviceToken] forKey:@"dev_token"];
    [[GKAppDotNetAPIClient sharedClient] postPath:@"account/register/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"response json %@", JSON);
        NSError * aError;
        NSUInteger  res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * _prefiles = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * _mutableDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary * attributes in _prefiles)
                {
                    GKUser * _user = [[GKUser alloc] initWithAttributes:attributes];
                    [_user save];
                    [_mutableDict setValue:_user forKey:@"content"];
                    break;
                }
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:_mutableDict], nil);
                    [[NSNotificationCenter defaultCenter] postNotificationName:GKUserLoginNotification object:nil userInfo:_mutableDict];
                }
            }
                break;
            case EMAIL_IS_REGISTER:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kEmailIsUsedError userInfo:userInfo];
            }
                break;
            case NICK_IS_USED:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kNicknameIsUsedError userInfo:userInfo];
            }
                break;
            default:
                break;
        }
        
        if (res_code != SUCCESS)
        {
            block([NSDictionary dictionary], aError);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];
}

+ (void)globalUserLoginWithEmail:(NSString *)email passwd:(NSString *)passwd
                           Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:2];
//    [parameters setValue:kGuokuApiKey forKey:@"api_key"];
    [paramters setValue:email forKey:@"email"];
    [paramters setValue:passwd forKey:@"passwd"];
//    [parameters setValue:[NSString SignWithParamters:parameters] forKey:@"sign"];
    [paramters setValue:[kUserDefault valueForKeyPath:kDeviceToken] forKey:@"dev_token"];
    [[GKAppDotNetAPIClient sharedClient] postPath:@"account/login/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSError * aError;
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * _profiles = [[JSON valueForKey:@"results"] valueForKey:@"data"];
                NSMutableDictionary * _res = [NSMutableDictionary dictionaryWithCapacity:[_profiles count]];
                for( NSDictionary *attributes in _profiles )
                {
                    GKUser * user = [[GKUser alloc] initWithAttributes:attributes];
                    GKLog(@"username %@", user.username);
                    [user save];
                    [_res setValue:user forKey:@"content"];
                }
                if (block) {
                    block([NSDictionary dictionaryWithDictionary:_res], nil);
                    [[NSNotificationCenter defaultCenter] postNotificationName:GKUserLoginNotification object:_res userInfo:nil];
                }
                
            }
                break;
            case PASSWD_NOT_MATCAH:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kUserPasswdError userInfo:userInfo];
            }
                break;
            case ABSENT_USER:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kAbsenUserError userInfo:userInfo];
            }
            default:
            {
                
            }
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
        if(block)
        {
            GKLog(@"%@", error);
            block([NSDictionary dictionary], error);
        }
    }];
}

+ (void)globalUserLogoutWithBlock:(void (^)(BOOL is_logout, NSError * error))block
{
    
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * _dev_token = [kUserDefault stringForKey:kDeviceToken];
    [paramters setValue:_dev_token forKey:@"dev_token"];
//    [[[GKAppDotNetAPIClient sharedClient] operationQueue] cancelAllOperations];
    [[GKAppDotNetAPIClient sharedClient] postPath:@"account/logout/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {

        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * userLogoutResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                GKLog(@"%@", userLogoutResponse);
                
                BOOL is_success = NO;
                for (NSDictionary * attributes in userLogoutResponse)
                {
                    is_success = [[attributes valueForKeyPath:@"is_logout"] boolValue];
                    break;
                }
                [GKEntityLike DeleteAllData];
                if(is_success && block)
                {
                    block(is_success, nil);
                }
            
            }
                break;
                
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            GKLog(@"%@", error);
            block(NO, error);
            //[[NSNotificationCenter defaultCenter] postNotificationName:GKUserLogoutNotification object:nil];
        }
    }];
}

+ (void)ForgetPasswdWithEmail:(NSString *)email Block:(void (^)(BOOL is_send_email, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramters setValue:email forKey:@"email"];
    [[GKAppDotNetAPIClient sharedClient] postPath:@"account/forget/passwd/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSError * aError;
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        switch (res_code) {
            case EMAIL_NOT_EXIST:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kAbsentEmailError userInfo:userInfo];
                if (block)
                {
                    block(NO, aError);
                }
            }
                break;
                
            default:
                block(YES, nil);
                break;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            block(NO, error);
        }
    }];
}

+ (void)UserFollowActionWithUserID:(NSUInteger)user_id Action:(GK_USER_RELATION)action Block:(void (^)(NSDictionary * user_relation, NSError * error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    [parameters setValue:[NSString stringWithFormat:@"%u", user_id] forKey:@"user_id"];
    NSString * urlString;
    switch (action) {
        case kFOLLOWED:
            urlString = @"user/follow/action/";
            break;
        case kFANS:
            urlString = @"user/unfollow/action/";
        default:
            break;
    }
    [[GKAppDotNetAPIClient sharedClient] postPath:urlString parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"user relation %@", JSON);
        
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * actionResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * _mutabledict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary * attributes in actionResponse)
                {
                    
                    GKUserRelation  * user_relation = [[GKUserRelation alloc] initWithAttributes:attributes];
                    [_mutabledict setValue:user_relation forKey:@"content"];
                    break;
                }
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:_mutabledict], nil);
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
            block([NSDictionary dictionary], error);
        }
    }];
}

+ (void)globalUserFollowingsWithUserID:(NSUInteger)user_id Page:(NSUInteger)page
                                Block:(void (^)(NSArray * following_list, NSError * error))block
{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] initWithCapacity:4];
    [parameters setValue:[NSString stringWithFormat:@"%u", user_id] forKey:@"user_id"];
    [parameters setValue:[NSString stringWithFormat:@"%u", page] forKey:@"page"];

    
    [[GKAppDotNetAPIClient sharedClient] postPath:@"user/following/" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * _following_list = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:[_following_list count]];
                for (NSDictionary *attributes in _following_list)
                {
                    GKUser * _user = [[GKUser alloc] initWithAttributes:attributes];
                    [_mutableArray addObject:_user];
                }
                if (block)
                {
                    block([NSArray arrayWithArray:_mutableArray], nil);
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
            GKLog(@"------------get following error %@", error);
            block([NSArray array], error);
        }
    }];
}

+ (void)globalUserFansWithUserID:(NSUInteger)user_id Page:(NSUInteger)page
                           Block:(void (^)(NSArray * fans_list, NSError * error))block {
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] initWithCapacity:4];
//    [parameters setValue:kGuokuApiKey forKey:@"api_key"];
    [parameters setValue:[NSString stringWithFormat:@"%u", user_id] forKey:@"user_id"];
    [parameters setValue:[NSString stringWithFormat:@"%u", page] forKey:@"page"];
//    [parameters setValue:[NSString SignWithParamters:parameters] forKey:@"sign"];
    
    [[GKAppDotNetAPIClient sharedClient] postPath:@"user/fans/" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * _fans_list = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableArray * _mutableArray = [NSMutableArray arrayWithCapacity:[_fans_list count]];
                for (NSDictionary *attributes in _fans_list)
                {
                    GKUser * _user = [[GKUser alloc] initWithAttributes:attributes];
                    [_mutableArray addObject:_user];
                }
                if (block)
                {
                    block([NSArray arrayWithArray:_mutableArray], nil);
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
        if (block)
        {
            GKLog(@"----------------get fans error %@", error);
            block([NSArray array], error);
        }
    }];
    
}

#pragma mark - register by weibo
+ (void)registerByWeiboOrTaobaoWithParamters:(NSDictionary *)paramters
                                        Type:(GKThreePartAccountURL)type
                                       Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    
    NSMutableDictionary * _paramters = [NSMutableDictionary dictionaryWithDictionary:paramters];
    [_paramters setValue:[kUserDefault valueForKeyPath:kDeviceToken] forKey:@"dev_token"];
    NSString * _urlString;
    switch (type) {
        case GKWeiboURLType:
            _urlString = @"account/weibo/register/";
            break;
        case GKTaobaoURLType:
            _urlString = @"account/taobao/register/";
            break;
        default:
            break;
    }
    [[GKAppDotNetAPIClient sharedClient] postPath:_urlString parameters:[_paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * _listresponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * _mutableDict = [NSMutableDictionary dictionaryWithCapacity:[_listresponse count]];
                for (NSDictionary *attributes in _listresponse)
                {
                    GKUser * _user = [[GKUser alloc] initWithAttributes:attributes];
                    [_mutableDict setValue:_user forKey:@"content"];
                    [_user save];
                    break;
                }
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:_mutableDict], nil);
                    [[NSNotificationCenter defaultCenter] postNotificationName:GKUserLoginNotification object:nil userInfo:nil];
                }
            }
                break;
            case NEED_REGISTER:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kNeedRegister userInfo:userInfo];
            }
                break;
            case EMAIL_IS_REGISTER:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kEmailIsUsedError userInfo:userInfo];
            }
                break;
            case NICK_IS_USED:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:UserErrorDomain code:kNicknameIsUsedError userInfo:userInfo];
            }
                break;
            default:
                break;
        }
        
        if (res_code != SUCCESS)
        {
            if (block)
                block([NSDictionary dictionary], aError);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       if (block)
       {
           GKLog(@"%@", error);
           block([NSDictionary dictionary], error);
       }
        
    }];
}


#pragma mark - bind by three part
+ (void)bindByWeiboOrTaobaoWithParamters:(NSDictionary *)paramters Type:(GKThreePartAccountURL)type Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSString * _urlString;
    switch (type) {
        case GKWeiboURLType:
            _urlString = @"account/weibo/bind/";
            break;
        case GKTaobaoURLType:
            _urlString = @"account/taobao/bind/";
            break;
        default:
            break;
    }
    GKLog(@"%@", paramters);
    [[GKAppDotNetAPIClient sharedClient] postPath:_urlString parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        GKLog(@"%@", JSON);
        NSError * aError;
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * tokenResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * _mutableDict = [NSMutableDictionary dictionaryWithCapacity:[tokenResponse count]];
                for (NSDictionary * attributes in tokenResponse)
                {
                    switch (type) {
                        case GKTaobaoURLType:
                        {
                            GKUserTaobaoToken * _token = [[GKUserTaobaoToken alloc] initWithAttributes:attributes];
                            [_mutableDict setValue:_token forKey:@"content"];
                            [_token saveToSQLite];
                        }
                            break;
                        case GKWeiboURLType:
                        {
                            GKUserWeiboToken * _token = [[GKUserWeiboToken alloc] initWithAttributes:attributes];
                            [_mutableDict setValue:_token forKey:@"content"];
                            [_token saveToSQLite];
                        }
                        default:
                            break;
                    }

                }
                
                if(block)
                {
                    block([NSDictionary dictionaryWithDictionary:_mutableDict], nil);
                }
            }
                break;
            case OTHER_USER_BINDED:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:ThreePartErrorDomain code:kOtherUserBinded userInfo:userInfo];
            }
                break;
            case USER_ALREADY_BINDED:
            {
                NSString * errorMsg = [JSON valueForKeyPath:@"res_msg"];
                NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
                aError = [NSError errorWithDomain:ThreePartErrorDomain code:kUserAlreadyBinded userInfo:userInfo];
            }
            default:
                break;
        }
        if (res_code != SUCCESS)
        {
            if (block)
                block([NSDictionary dictionary], aError);
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
