//
//  GKVersion.m
//  Grape
//
//  Created by 谢家欣 on 13-5-4.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKVersion.h"
#import "NSDate+GKHelper.h"
#import "NSDictionary+GKHelp.h"
#import "GKAppDotNetAPIClient.h"

@implementation GKVersion

@synthesize device = _device;
@synthesize version = _version;
@synthesize message = _message;
@synthesize pub_time = _pub_time;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _device = [attributes valueForKeyPath:@"device"];
        _version = [attributes valueForKeyPath:@"version"];
        _message = [attributes valueForKeyPath:@"message"];
        _pub_time = [NSDate dateFromString:[attributes valueForKeyPath:@"pub_time"]];
    }
    
    return self;
}

+ (void)getAppVersionWithBlock:(void (^)(NSDictionary * dict, NSError * error))block
{
    NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:1 ];
    if (!isPad)
    {
        [paramters setValue:@"iPhone" forKey:@"dev"];
    }
    [[GKAppDotNetAPIClient sharedClient] getPath:@"maria/update/" parameters:[paramters Paramters] success:^(AFHTTPRequestOperation *operation, id JSON) {
        GKLog(@"%@", JSON);
        NSUInteger res_code = [[JSON valueForKeyPath:@"res_code"] integerValue];
        switch (res_code) {
            case SUCCESS:
            {
                NSArray * listReponse = [[JSON valueForKeyPath:@"results"] valueForKeyPath:@"data"];
                NSMutableDictionary * mutableDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary * attributes in listReponse)
                {
                    GKVersion * _version = [[GKVersion alloc] initWithAttributes:attributes];
                    [mutableDict setValue:_version forKey:@"content"];
                }
                if (block)
                {
                    block([NSDictionary dictionaryWithDictionary:mutableDict], nil);
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
            block([NSDictionary dictionary], error);
        }
    }];
}

@end
