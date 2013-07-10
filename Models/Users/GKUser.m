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


@implementation GKUser
{
    @private
    NSString * _avatarImageURLString;
}


@synthesize user_id = _user_id;
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize location = _location;
@synthesize city = _city;
@synthesize bio = _bio;
@synthesize stage = _stage;
@synthesize birth_date = _birth_date;
@synthesize liked_count = _liked_count;
@synthesize follows_count = _follows_count;
@synthesize fans_count = _fans_count;
@synthesize relation = _relation;




- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _user_id = [[attributes valueForKeyPath:@"user_id"] integerValue];
        _nickname = [attributes valueForKeyPath:@"nickname"];
        _location = [attributes valueForKeyPath:@"location"];
        _city = [attributes valueForKeyPath:@"city"];
        _avatarImageURLString = [attributes valueForKeyPath:@"avatar_url"];
        if(!_avatarImageURLString)
        {
            _avatarImageURLString = @"http://image.guoku.com/avatar/large_181259_c3ac1096db6cf045cc4c9ed3a62f1c7c.jpe";
        }
        _bio = [attributes valueForKeyPath:@"bio"];
        if([_bio isEqual:[NSNull null]])
        {
            _bio = @"";
        }
        _gender = [attributes valueForKeyPath:@"gender"];
        
        
        _liked_count = [[attributes valueForKeyPath:@"like_count"] integerValue];
        _follows_count = [[attributes valueForKeyPath:@"following_count"] integerValue];
        _fans_count = [[attributes valueForKeyPath:@"fans_count"] integerValue];
        
        _stage = [[attributes valueForKeyPath:@"mom_stage"] integerValue];
        if([[attributes valueForKeyPath:@"baby_birthday"] isEqual:[NSNull null]])
        {
            _birth_date = [NSDate date];
        }
        else
        {
            _birth_date = [NSDate dateFromString:[attributes valueForKeyPath:@"baby_birthday"]];
        }
 
        
        _relation = [[GKUserRelation alloc] initWithAttributes:[attributes valueForKeyPath:@"relation"]];

    }
    return self;
}
-(GKUserBase *)getUserBase
{
    NSMutableDictionary *a = [[NSMutableDictionary alloc]initWithCapacity:0];
    [a setObject:@(_user_id) forKey:@"user_id"];
    [a setObject:_nickname forKey:@"nickname"];
    [a setObject:_gender forKey:@"gender"];
    [a setObject:_location forKey:@"loaction"];
    [a setObject:_relation forKey:@"relation"];
    [a setObject:_city forKey:@"city"];
    [a setObject:_avatarImageURLString forKey:@"avatar_url"];
    
    GKUserBase *userBase = [[GKUserBase alloc]initWithAttributes:a];
    return userBase;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.user_id) forKey:@"user_id"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:_avatarImageURLString forKey:@"avatar"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.city forKey:@"city"];    
    [aCoder encodeObject:self.birth_date forKey:@"birth_date"];
    [aCoder encodeObject:self.bio forKey:@"bio"];
    [aCoder encodeObject:@(self.stage) forKey:@"stage"];
    [aCoder encodeObject:@(self.follows_count) forKey:@"follows_count"];
    [aCoder encodeObject:@(self.fans_count) forKey:@"fans_count"];
    [aCoder encodeObject:@(self.liked_count) forKey:@"like_count"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.user_id = [[aDecoder decodeObjectForKey:@"user_id"]intValue];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        _avatarImageURLString = [aDecoder decodeObjectForKey:@"avatar"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.bio = [aDecoder decodeObjectForKey:@"bio"];
        self.stage = [[aDecoder decodeObjectForKey:@"stage"]intValue];
        self.birth_date = [aDecoder decodeObjectForKey:@"birth_date"];
        self.liked_count = [[aDecoder decodeObjectForKey:@"like_count"] intValue];
        self.follows_count = [[aDecoder decodeObjectForKey:@"follows_count"] intValue];
        self.fans_count = [[aDecoder decodeObjectForKey:@"fans_count"] intValue];
    }
    return self;
}

- (NSURL *)avatarImageURL
{
    return [NSURL URLWithString:_avatarImageURLString];
}
- (id)initFromNSU
{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"login_user"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"login_user"];
}



#pragma mark -

+ (void)globalUserProfileWithUserID:(NSUInteger)user_id Block:(void (^)( NSDictionary * dict, NSError * error))block {
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] initWithCapacity:1];
    if (user_id)
    {
        [parameters setValue:[NSNumber numberWithUnsignedInteger:user_id] forKey:@"user_id"];
    }

    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/get_user_info" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
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
        }
    }];
}

+ (void)UserFollowActionWithUserID:(NSUInteger)user_id Action:(GK_USER_RELATION)action Block:(void (^)(NSDictionary * user_relation, NSError * error))block
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    [parameters setValue:[NSString stringWithFormat:@"%u", user_id] forKey:@"followee_id"];
    NSString * urlString;
    switch (action) {
        case kFOLLOWED:
            urlString = @"maria/follow/";
            break;
        case kFANS:
            urlString = @"maria/unfollow/";
        default:
            break;
    }
    [[GKAppDotNetAPIClient sharedClient] getPath:urlString parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
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
                    GKUserRelation  * user_relation = [[GKUserRelation alloc] initWithAttributes:[attributes objectForKey:@"relation"]];
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

    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/get_followings" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
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
    [parameters setValue:[NSString stringWithFormat:@"%u", user_id] forKey:@"user_id"];
    [parameters setValue:[NSString stringWithFormat:@"%u", page] forKey:@"page"];
    
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/get_fans" parameters:[parameters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
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
                                       Block:(void (^)(NSDictionary * dict, NSError * error))block
{
    
    NSMutableDictionary * _paramters = [NSMutableDictionary dictionaryWithDictionary:paramters];
    [_paramters setValue:[kUserDefault valueForKeyPath:kDeviceToken] forKey:@"dev_token"];
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/register_by_weibo" parameters:[_paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * _listresponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * _mutableDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary *attributes in _listresponse)
                {
                    NSString * session = [attributes valueForKey:@"session"];
                    [kUserDefault setObject:session forKey:kSession];
                    GKUser * _user = [[GKUser alloc] initWithAttributes:[attributes objectForKey:@"user"]];
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

- (void)changeStageWithStage:(NSUInteger)stage
                            Date:(NSDate*)date
                               Block:(void (^)(NSDictionary *dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:4];
    [paramters setValue:[NSString stringWithFormat:@"%u", stage] forKeyPath:@"mom_stage"];
    [paramters setValue:[NSDate stringFromDate:date WithFormatter:@"yyyy-MM-dd"] forKeyPath:@"baby_birthday"];
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/set_stage"parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSUInteger  res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        NSError * aError;
        GKLog(@"%@", JSON);
        switch (res_code) {
            case SUCCESS:
            {
                
                NSArray * entitylikeResponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * mutalbleDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary *attributes in entitylikeResponse)
                {
                    [mutalbleDict setValue:attributes forKeyPath:@"content"];
                }
                
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:mutalbleDict], nil);
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
